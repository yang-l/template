#!/usr/bin/env bash

set -Eeuo pipefail

err() {
  echo "errexit with status [$?] at line $(caller)" >&2
  awk 'NR>L-5 && NR<L+3 { printf "%-5d%3s%s\n",NR,(NR==L?">> ":""),$0 }' L=$1 $0
}
trap 'err $LINENO' ERR


# test related variables
TEST_FILE='input.txt'           # generate a output file with the random number in each line
TEST_RANGE_MIN=1                # the low end of a range when generate a test file
TEST_RANGE_MAX=10000000000000   # the high end of range when generate a test file
TEST_COUNT_NUM=100000000        # the nubmer of numbers (one in each line) when generate a test file

# operation related settings
FUNCTION=sort                   # available - sort / generate_test
INPUT_FILE="${TEST_FILE}"
CHUNK_SIZE_IN_LINES=1000000     # chunk size in number of lines after spliting the INPUT_FILE
MAX_PROCS=8                     # concurrent count when running sorting (passed to xargs)
OUTPUT_FILE='output.txt'
TOP_X=10                        # top x records
SHOW_INFO=''

usage() {
  echo "Usage: $0 [ -f FUNCTION ] [ -i INPUT_FILE ] [ -p MAX_PROCS] [ -l CHUNK_SIZE_IN_LINES ] [ -x TOP_RECORDS ] [ -v VERBOSE ]"
}

show_usage() {
  usage
  exit 1
}

get_options() {
  while getopts ":f:i:p:x:v:" options; do
    case "${options}" in
      f)
        case "${OPTARG}" in
          sort|generate_test)
            FUNCTION="${OPTARG}"
            ;;
          *)
            echo "ERROR - Invalid FUNCTION name - '-f ${OPTARG}'"
            echo "INFO  - Available FUNCTION names are [ sort | generate_test ]"
            show_usage
            ;;
        esac
        ;;
      i)
        INPUT_FILE="${OPTARG}"
        ;;
      p)
        MAX_PROCS="${OPTARG}"
        ;;
      l)
        CHUNK_SIZE_IN_LINES="${CHUNK_SIZE_IN_LINES}"
        ;;
      x)
        TOP_X="${OPTARG}"
        ;;
      v)
        SHOW_INFO="${OPTARG}"
        ;;
      :)
        echo "ERROR - An argument is expected for '-${OPTARG}'"
        show_usage
        ;;
      *)
        show_usage
        ;;
    esac
  done
}

generate_test_file(){
  # generate a file with one positive number in each line randomly
  # OSX only
  jot -r "${TEST_COUNT_NUM}" "${TEST_RANGE_MIN}" "${TEST_RANGE_MAX}" > "$TEST_FILE"
}

sort_and_find_top_x_number() {
  if [ ! -f "${INPUT_FILE}" ]; then
    echo "ERROR - Unable to find the input file in '-i ${INPUT_FILE}'"
    show_usage
  fi

  ## all splited files are started with x
  # clean up leftover
  rm -fr x* "${OUTPUT_FILE}"

  # split the fine in chunks,
  split -l "${CHUNK_SIZE_IN_LINES}" "${INPUT_FILE}"

  if [ "${SHOW_INFO}" != "" ]; then
    echo "INFO  - number of parallet threads [ ${MAX_PROCS} ]"
    echo "INFO  - find top [ ${TOP_X} ] records"
  fi

  # sort - LC_ALL=C to speed up performance
  ## Note - the following 2 commands do all the work.
  ## However, this entire script could just simply be replaced by something in the commandline like
  ### LC_ALL=C sort -unr VERY_LARGE_TEXT_FILE | head -n TOP_X_RECORD
  ls x* | xargs -n 1 -P "${MAX_PROCS}" -I {} sh -c "LC_ALL=C sort -S 75% --parallel 4 -unr {} | head -n ${TOP_X} >> ${OUTPUT_FILE}"

  # output final result
  LC_ALL=C sort -S 75% --parallel 4 -unr $OUTPUT_FILE | head -n "${TOP_X}"

  ## performance
  #
  # $ ls
  # total 2719880
  # 1.3G input.txt
  # 3.4K topX.sh
  #
  # $ time LC_ALL=C sort -S 75% --parallel 8 -unr input.txt | head -n 10
  # 9999999983702
  # 9999999741558
  # 9999999678694
  # 9999999636784
  # 9999999464490
  # 9999999278225
  # 9999999273568
  # 9999999057036
  # 9999999043066
  # 9999998763669
  #
  # real    12m6.179s
  # user    4m44.202s
  # sys     4m49.063s
  #
  # $ time LC_ALL=C sort -S 75% --parallel 4 -unr input.txt | head -n 10
  # 9999999983702
  # 9999999741558
  # 9999999678694
  # 9999999636784
  # 9999999464490
  # 9999999278225
  # 9999999273568
  # 9999999057036
  # 9999999043066
  # 9999998763669
  #
  # real    18m59.385s
  # user    5m49.303s
  # sys     8m16.626s
  #
  # $ time ./topX.sh
  # 9999999983702
  # 9999999741558
  # 9999999678694
  # 9999999636784
  # 9999999464490
  # 9999999278225
  # 9999999273568
  # 9999999057036
  # 9999999043066
  # 9999998763669
  #
  # real    5m21.519s
  # user    3m6.914s
  # sys     4m31.823s
}

process() {
  case "${FUNCTION}" in
    generate_test)
      generate_test_file
      ;;
    sort)
      sort_and_find_top_x_number
      ;;
    *)
      show_usage
      ;;
  esac
}

main() {
  get_options "$@"
  process

  return
}
main "$@"

export function insertNSort(array: Array<number>, item: number) {
  if (item > array[array.length - 1]) {
    // only insert into the array if item is greater than the smallest number of the top X numbers
    insertNSortHelper(array, item, 0, array.length);
    array.splice(array.length - 1, 1); // maintain the top X numbers
  }
}

function insertNSortHelper(array: Array<number>, item: number, left: number, right: number) {
  if (left < right - 1) {
    // floor((left + right)/2)
    const mid = (left + right) >>> 1; //eslint-disable-line no-bitwise
    if (item > array[mid]) {insertNSortHelper(array, item, left, mid);} // greater value to the left of array
    else {insertNSortHelper(array, item, mid, right);} // smaller value to the right of array
  } else {
    if (item > array[left]) {array.splice(left, 0, item);} // add a greater value to the left
    else if (item < array[right]) {array.splice(right + 1, 0, item);} // add a smaller value to the right
    else if (item === array[right - 1]) {array.push(item);} // do not add a duplicated number into the sorted arrary, but to the end
    else {array.splice(right, 0, item);}
  }
}

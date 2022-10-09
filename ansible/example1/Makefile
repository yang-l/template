S3_BUCKET = thisisatestbucketencroach2021
S3_KEY = tf.tfstate
S3_REGION = us-east-1

install_requirements:
	ansible-galaxy collection install community.general
	ansible-galaxy collection install community.docker

init:
	ansible-playbook main.yml -e task=init -e backend_s3_bucket=$(S3_BUCKET) -e backend_s3_key=$(S3_KEY) -e backend_s3_region=$(S3_REGION)

plan:
	ansible-playbook main.yml -e task=plan

apply:
	ansible-playbook main.yml -e task=apply

destroy:
	ansible-playbook main.yml -e task=destroy

test:
	ansible-playbook main.yml -e task=test

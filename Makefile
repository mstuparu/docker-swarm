# SSH public key
export TF_VAR_aws_ssh_pub_key=$(shell cat ~/.ssh/swarm.pub)

myapp_image=mstuparu/myapp
myapp_vers=0.5

swarm_create_app="docker service create --name myapp --replicas 5 --update-delay 5s --publish 80:8080 ${myapp_image}:${myapp_vers}"
swarm_update_app="docker service update --image ${myapp_image}:${myapp_vers} myapp"

tf=plan

infra:
	@echo "Provision the swarm infrastructure with terraform"
	cd terraform && terraform ${tf}

ssh-key:
	@echo Create the swarm ssh key
	@ssh-keygen -f ~/.ssh/swarm
	@ssh-add ~/.ssh/swarm

build:
	@echo Building docker image
	docker build -t mstuparu/myapp:${myapp_vers} app

push:
	@echo Building docker image
	docker push mstuparu/myapp

deploy-swarm:
	@echo Ansible config of swarm cluster
	cd ansible && ansible-playbook deploy-swarm.yml

create-app:
	@echo Ansible config of swarm cluster
	cd ansible && ansible-playbook swarm-app-action.yml -e 'swarm_action=${swarm_create_app}'

deploy-app:
	@echo Ansible config of swarm cluster
	cd ansible && ansible-playbook swarm-app-action.yml -e 'swarm_action=${swarm_update_app}'

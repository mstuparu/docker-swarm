# SSH public key
export TF_VAR_aws_ssh_pub_key=$(shell cat ~/.ssh/swarm.pub)

# App specific and release version set
export myapp_image=mstuparu/myapp
export myapp_vers=0.6

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
	docker build -t mstuparu/myapp:${myapp_vers} -t mstuparu/myapp:latest app

push:
	@echo Building docker image
	docker push mstuparu/myapp

localdev:
	@echo Building docker image
	cd app && docker-compose up -d

deploy-swarm:
	@echo Ansible config of swarm cluster
	cd ansible && ansible-playbook deploy-swarm.yml

create-app:
	@echo Ansible create service app on swarm
	cd ansible && ansible-playbook swarm-app-action.yml -e 'swarm_action=${swarm_create_app}'

deploy-app:
	@echo Ansible update service app on swarm
	cd ansible && ansible-playbook swarm-app-action.yml -e 'swarm_action=${swarm_update_app}'

clean:
	@echo Delete all resources
	cd app && docker-compose down
	cd terraform && terraform destroy

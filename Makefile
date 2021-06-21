.PHONY: all init rebuild help up

DOCKER_EXEC=docker-compose -f docker-compose.yml
DOCKER_EXEC_PROD=docker-compose -f docker-compose.prod.yml
BIN_DIR=./bin

all: help

init: ## Initialize everything
	$(DOCKER_EXEC) up -d --build

initprod: ## Initialize on prod
	$(DOCKER_EXEC_PROD) up -d --build

deploy: ## deploy stuff
	# push files in plugins folder
	#rsync -chavzP -v --stats --include-from=rsync.list ./ 10academywordpress:/usr/app/
	rsync ./*.yml 10academywordpress:/usr/app/
	# restart docker on live
	ssh 10academywordpress "cd /usr/app && make restartprod"

rebuild: ## Builds docker containers
	$(DOCKER_EXEC) up -d --build

rebuildprod: ## Rebuild on prod
	$(DOCKER_EXEC_PROD) up -d --build

restartprod: ## Restart on prod
	$(DOCKER_EXEC_PROD) restart

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up: ## Start docker containers
	docker-compose up -d

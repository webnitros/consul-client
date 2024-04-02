include ./.env
export

export TYPE_SERVICE=$(filter-out $@,$(MAKECMDGOALS))

test:
	@echo "Service: $(TYPE_SERVICE)"

up:
	docker compose up
stop:
	docker compose stop
down:
	docker compose down --volumes --remove-orphans
build:
	docker compose server build
destroy:
	docker compose down --volumes --remove-orphans
destroy-all:
	docker compose down --rmi all --volumes --remove-orphans
remake:
	@make down
	@make install
install:
	@make build
	@make up

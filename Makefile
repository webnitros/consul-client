up:
	docker compose up -d
stop:
	docker compose stop
down:
	docker compose down --volumes --remove-orphans

destroy:
	docker compose down --volumes --remove-orphans
destroy-all:
	docker compose down --rmi all --volumes --remove-orphans
install:
	@make build
	@make up
remake:
	@make destroy
	@make up

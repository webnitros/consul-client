up:
	docker compose up
stop:
	docker compose stop
down:
	docker compose down --volumes --remove-orphans
build:
	#docker compose build
	docker build -t webnitros/consul:latest .
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

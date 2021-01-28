up:
	docker-compose up -d
build:
	docker-compose build --no-cache --force-rm
stop:
	docker-compose stop
down:
	docker-compose down --remove-orphans
ps:
	docker-compose ps
restart:
	@make down
	@make up
init:
	docker-compose up -d --build
	docker-compose exec php php artisan key:generate
	@make fresh
destroy:
	docker-compose down --rmi all --volumes --remove-orphans
remake:
	@make destroy
	@make init
migrate:
	docker-compose exec php php artisan migrate
fresh:
	docker-compose exec php php artisan migrate:fresh --seed
seed:
	docker-compose exec php php artisan db:seed

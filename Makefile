dev:
	MIX_ENV=dev SECURE_CHANNELS=true API_JWT_SECRET=dev METRICS_JWT_SECRET=dev FLY_REGION=fra FLY_ALLOC_ID=123e4567-e89b-12d3-a456-426614174000 DB_ENC_KEY="1234567890123456" ERL_AFLAGS="-kernel shell_history enabled" iex -S mix phx.server

seed:
	mix run priv/repo/seeds.exs

prod:
	MIX_ENV=prod FLY_APP_NAME=realtime-local API_KEY=dev SECURE_CHANNELS=true API_JWT_SECRET=dev METRICS_JWT_SECRET=dev FLY_REGION=fra FLY_ALLOC_ID=123e4567-e89b-12d3-a456-426614174000 DB_ENC_KEY="1234567890123456" SECRET_KEY_BASE=M+55t7f6L9VWyhH03R5N7cIhrdRlZaMDfTE6Udz0eZS7gCbnoLQ8PImxwhEyao6D DASHBOARD_USER=realtime_local DASHBOARD_PASSWORD=password ERL_AFLAGS="-kernel shell_history enabled" iex -S mix phx.server

swagger:
	mix phx.swagger.generate

bench.%:
	MIX_ENV=dev SECURE_CHANNELS=true API_JWT_SECRET=dev METRICS_JWT_SECRET=dev FLY_REGION=fra FLY_ALLOC_ID=123e4567-e89b-12d3-a456-426614174000 DB_ENC_KEY="1234567890123456" ERL_AFLAGS="-kernel shell_history enabled" mix run bench/$*

#########################
# Docker
#########################

start:
	docker-compose up

start.%:
	docker-compose -f docker-compose.$*.yml up

stop:
	docker-compose down --remove-orphans

stop.%:
	docker-compose -f docker-compose.yml -f docker-compose.$*.yml down  --remove-orphans

rebuild:
	make stop
	docker-compose build
	docker-compose up --force-recreate --build

rebuild.%:
	make stop.$*
	docker-compose -f docker-compose.yml -f docker-compose.$*.yml build
	docker-compose -f docker-compose.yml -f docker-compose.$*.yml up --force-recreate --build

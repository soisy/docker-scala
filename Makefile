export UID := $(shell id -u)
export GID := $(shell id -g)

build:
	docker-compose build

run:
	docker-compose run --rm scala bash

push:
	docker-compose push scala 

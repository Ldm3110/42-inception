# Temporary Makefile to run only mariaDB

IMAGE_NAME = my_nginx

CONTAINERS = $(shell docker ps -aq)
IMAGE_EXIST = $(shell docker image ls | grep $(IMAGE_NAME))

all: build run

info:
	docker image ls && docker ps -a

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -it $(IMAGE_NAME):latest

clear_all: clear_cont clear_img

clear_cont:
	@if [ -n "$(CONTAINERS)" ]; then \
		docker stop $(CONTAINERS); \
		docker rm $(CONTAINERS); \
	else \
		echo "Aucun conteneur à supprimer"; \
	fi

clear_img:
	@if [ -n "$(IMAGE_EXIST)" ]; then \
		docker image rm $(IMAGE_NAME);\
	else \
		echo "No image to remove"; \
	fi

build:
	docker build -t show_image_docker . --network host \
			--build-arg http_proxy=${http_proxy}\
			--build-arg https_proxy=${https_proxy}

build_without_proxy:
	docker build -t show_image_docker .

up: 
	docker-compose up


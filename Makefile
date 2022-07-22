.PHONY: build push run share

IMG:=ubuntu/ezored:latest

build:
	docker build -t $(IMG) .

# push: build
# 	docker push $(IMG)
#
# pull:
# 	docker pull $(IMG)

up:
	docker run \
		 -e USER=$$(id -u -n) \
		 -e GROUP=$$(id -g -n) \
		 -e UID=$$(id -u) \
		 -e GID=$$(id -g) \
		 -e PATH=/home/$$(id -u -n)/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\
		 -v `pwd`/host:/home/$$(id -u -n)/host \
		 -d \
		 -w /home/$$(id -u -n)/host \
		 --name ezored \
		 $(IMG) bash

run:
	docker run \
		 -e USER=$$(id -u -n) \
		 -e GROUP=$$(id -g -n) \
		 -e UID=$$(id -u) \
		 -e GID=$$(id -g) \
		 -e PATH=/home/$$(id -u -n)/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\
		 -v `pwd`/host:/home/$$(id -u -n)/host \
		 -it \
		 -w /home/$$(id -u -n)/host \
		 --name ezored \
		 --rm $(IMG)

run-as-root:
	docker run \
		 -v `pwd`/host:/host \
		 -it \
		 -w /host \
		 --rm $(IMG)

images:
	docker images --format "{{.Repository}}:{{.Tag}}"| sort

ls:
	docker images --format "{{.ID}}: {{.Repository}}"

size:
	docker images --format "{{.Size}}\t: {{.Repository}}"

tags:
	docker images --format "{{.Tag}}\t: {{.Repository}}"| sort -t ':' -k2 -n

net:
	docker network ls

rm-network:
	docker network ls| awk '$$2 !~ "(bridge|host|none)" {print "docker network rm " $$1}' | sed '1d'

ip:
	docker ps -q \
	| xargs docker inspect --format '{{ .Name }}:{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'\
	| \sed 's/^.*://'

memory:
	docker inspect `docker ps -aq` | grep -i mem

fix:
	docker images -q --filter "dangling=true"| xargs docker rmi -f

rm:
	docker rm ezored

rmi:
	docker rmi $(IMG)

rmi-all:
	@docker images --format "docker rmi {{.ID}}"

rm-all:
	docker ps -aq -f status=exited| xargs docker rm

stop-all:
	docker ps -aq -f status=running| xargs docker stop

ps:
	docker ps -a

status:
	docker stats --all --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

info:
	docker inspect -f '{{ index .Config.Labels "build_version" }}' $(IMG)

save:
	docker save $(IMG) | gzip > ezored_latest.tar.gz

scp:
	scp dev:backup/ezored_latest.tar.gz .

install:ezored_latest.tar.gz
	docker load < ezored_latest.tar.gz

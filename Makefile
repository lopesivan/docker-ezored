.PHONY: build push run share

IMG:=ununtu/ezored:latest

build:
	docker build -t $(IMG) .

# push: build
# 	docker push $(IMG)
#
# pull:
# 	docker pull $(IMG)

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

rmi:
	docker rmi $(IMG)

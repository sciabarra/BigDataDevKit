docker ps -a -q  | xargs docker rm
docker images | grep '<none>' | awk '{print $3}' | xargs docker rmi -f

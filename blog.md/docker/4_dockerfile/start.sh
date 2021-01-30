docker stop $(docker ps -q)
docker container prune y
docker build --rm -t consul:centos-1.0 .
docker run -it --name consul-1 consul:centos-1.0
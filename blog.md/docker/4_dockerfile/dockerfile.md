前言

在上一篇文章[docker常用命令的实践与解析](https://yzstu.blog.csdn.net/article/details/110749325 )中，我们提到了可以使用commit命令来在本地创建镜像，但是commit创建的镜像其实是不够正规的，第三方无法了解镜像创建的过程，所以只能作为我们在本地归档的一种方法，用commit创建的镜像在实际生产过程中是无法上传到公司仓库的，举一个简单的例子，我们在我们的镜像中隐藏一个挖矿脚本，如果用commit来打包，那么公司安全部门只能拿到我们最终生成的镜像，假如生产环境引入我们的镜像，那就会给公司服务器造成不必要的负担，也会引起其他的麻烦。这种前提下，公司可以要求开发者使用DockerFile来创建镜像，同时要求必须使用公司仓库已经存在的镜像作为base image，那这样安全部门只需要拿到我们的DockerFile文件来分析即可，在DickerFile通过审核之后，也可以直接用DickerFile文件来构建镜像上传，这样就隔离了开发者与仓库，避免了一些安全问题，同时由于DockerFile文件也有记录的功能，在镜像出现问题后，也可以更好的排查错误。

# DockerFile相关

[DockerFile官方文档]( https://docs.docker.com/engine/reference/builder/ )

docker系统可以通过DockerFile文档来自动构建镜像，DockerFile是一个包含了所有用户用以组装镜像的命令的文本文档。

# 命令

## FROM

### 相关

FROM指令初始化一个新的构建阶段，并为后续指令设置**基本映像**，一般Dockerfile必须以FROM指令开头。设置的基本镜像可以是任何可用的镜像，包括你从本地或者远程仓库拉取的镜像，但是为了在生产中保持任意环境下都可用，我们一般建议使用公共或内部公开的仓库中的镜像作为基本镜像。

```
基本镜像(base image)：后续所有操作都在这个镜像上进行
```

### 通式

FROM的用法通常是以下三种

```bash
FROM [--platform=<platform>] <image> [AS <name>]
```

```bash
FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
```

```bash
FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
```

### 注意

```
1.ARG命令是唯一允许出现在FROM命令之前的命令，其具体用法在下文描述
2.FROM可以在单个Dockerfile中多次出现，以创建多个映像或将一个构建阶段用作对另一个构建阶段的依赖。只需在每个新的FROM指令之前记录一次提交输出的最后一个图像ID。每个FROM指令清除由先前指令创建的任何状态。
3.通过将AS名称添加到FROM指令中，可以选择为新的构建阶段指定名称。该名称可以在后续的FROM和COPY --from = <名称>指令中使用，以引用此阶段中构建的映像。
4.tag或digest是可选的。如果您忽略其中任何一个，那么缺省情况下构建器将采用最新标签。如果构建器找不到合适的标签值，则返回错误。
5.在FROM引用多平台镜像的情况下，可设置--platform标志可用于指定镜像的平台。例如linux/amd64，linux/arm64或Windows/amd64。默认情况下，使用构建请求的平台类型。
```

## RUN

### 相关

RUN命令后的指令是在镜像构建的时候执行的命令

### 通式

```bash
RUN <command> 
```

```bash
RUN ["executable", "param1", "param2"]
executable：一个可执行的脚本文件
param1、param2：executable所传入的参数
```

### 注意

每一条RUN命令都会生成一个中间镜像，在一般情况下，建议将RUN下可以合成一条的指令合并在一起，如：

```bash
RUN /bin/bash -c 'source $HOME/.bashrc; \
echo $HOME'
```

## CMD

### 相关

CMD的也是后跟可执行的命令，与RUN的区别是CMD后的命令是在docker run的时候执行的。

### 通式

```bash
CMD command param1 param2 
```

```bash
CMD ["executable","param1","param2"]
```

```bash
CMD ["param1","param2"] 
```

### 注意

一个Dockerfile中仅能够存在一条CMD命令，若存在多条，将只执行最后一条

## LABEL

### 相关

LABEL指令会向镜像中添加一些元数据，且LABEL数据是一种键值对的形式，要在LABEL值中包含空格，请像在命令行分析中一样使用引号和反斜杠。

### 通式

```bash
LABEL <key>=<value> <key>=<value> <key>=<value> ...
```

### 注意

如果当前设置的LABEL数据与父镜像的LABEL数据冲突了，将覆盖父镜像的LABEL对应数据

## MAINTAINER 

### 相关

MAINTAINER指令设置生成镜像的“作者”字段。docker官方建议使用LABEL命令来代替MAINTAINER，因为LABEL的用法更为灵活，且能够通过docker inspect命令来很方便的查看。如：

```
LABEL maintainer="dikeywang@163.com"
```

### 通式

```bash
MAINTAINER <name>
```

## ENV

### 相关

ENV命令能在环境变量中添加一对kv形式的数据，使用ENV命令所添加的数据能够在后续的过程中一直使用。

### 通式

```dockerfile
ENV <key>=<value> ...
```

### 注意

```
1.在docker run命令中，可以通过-e或者--env来替换Dockerfile中设置的ENV参数值
2.使用docker inspect命令也可以看到环境变量中的值
```

## ADD

### 相关

ADD与COPY类似，且在相同需求下，但是官方建议使用COPY命令

### 通式

```dockerfile
ADD [--chown=<user>:<group>] <src>... <dest>
ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]
```

ADD指令从<src>复制新文件、目录或远程文件，并将它们添加到路径<dest>处的映像文件系统中。

可以指定多个<src>资源，但如果它们是文件或目录，则它们的路径被解释为相对于构建上下文的源。

<src>还可以是一个通配符，比如

```dockerfile
ADD hom* /mydir/
```

### 注意

```
ADD 的优点：在执行 <源文件> 为 tar 压缩文件的话，压缩格式为 gzip, bzip2 以及 xz 的情况下，会自动复制并解压到 <目标路径>。
ADD 的缺点：在不解压的前提下，无法复制 tar 压缩文件。会令镜像构建缓存失效，从而可能会令镜像构建变得比较缓慢。具体是否使用，可以根据是否需要自动解压来决定。
```

## COPY

### 相关

 复制指令，从上下文目录中复制文件或者目录到容器里指定路径。 使用方式与ADD类似，但是在相同的需求下官方更建议使用COPY。

### 通式

```dockerfile
COPY [--chown=<user>:<group>] <src>... <dest>
COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]
```

## ENTRYPOINT

### 相关

类似于 CMD 指令，但其不会被 docker run 的命令行参数指定的指令所覆盖，而且这些命令行参数会被当作参数送给 ENTRYPOINT 指令指定的程序。

但是, 如果运行 docker run 时使用了 --entrypoint 选项，此选项的参数可当作要运行的程序覆盖 ENTRYPOINT 指令指定的程序。

### 通式

```dockerfile
ENTRYPOINT ["executable", "param1", "param2"]
ENTRYPOINT command param1 param2
```

### 注意

 如果 Dockerfile 中如果存在多个 ENTRYPOINT 指令，仅最后一个生效。 

## VOLUME

### 相关

定义匿名数据卷。在启动容器时忘记挂载数据卷，会自动挂载到匿名卷。 

在启动容器 docker run 的时候，我们可以通过 -v 参数修改挂载点。

### 通式

```dockerfile
VOLUME ["/data"]
```

## WORKDIR

### 相关

指定工作目录。用 WORKDIR 指定的工作目录，会在构建镜像的每一层中都存在。（WORKDIR 指定的工作目录，必须是提前创建好的）。

docker build 构建镜像过程中的，每一个 RUN 命令都是新建的一层。只有通过 WORKDIR 创建的目录才会一直存在。

### 通式

```dockerfile
WORKDIR /path/to/workdir
```

## ARG

### 相关

构建参数，与 ENV 作用一至。不过作用域不一样。ARG 设置的环境变量仅对 Dockerfile 内有效，也就是说只有 docker build 的过程中有效，构建好的镜像内不存在此环境变量。

构建命令 docker build 中可以用 --build-arg <参数名>=<值> 来覆盖。

### 通式

```dockerfile
ARG <name>[=<default value>]
```

## ONBUILD

### 相关

 用于延迟构建命令的执行。简单的说，就是 Dockerfile 里用 ONBUILD 指定的命令，在本次构建镜像的过程中不会执行（假设镜像为 test-build）。当有新的 Dockerfile 使用了之前构建的镜像 FROM test-build ，这是执行新镜像的 Dockerfile 构建时候，会执行 test-build 的 Dockerfile 里的 ONBUILD 指定的命令。 

### 通式

```dockerfile
ONBUILD <INSTRUCTION>
```

## HEALTHCHECK

### 相关

 用于指定某个程序或者指令来监控 docker 容器服务的运行状态。 

### 通式

```dockerfile
HEALTHCHECK [选项] CMD <命令>：设置检查容器健康状况的命令
HEALTHCHECK NONE：如果基础镜像有健康检查指令，使用这行可以屏蔽掉其健康检查指令
HEALTHCHECK [选项] CMD <命令> : 这边 CMD 后面跟随的命令使用，可以参考 CMD 的用法。
```

### EXPOSE

### 相关

仅仅只是声明端口。帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射。在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口。

### 通式

```dockerfile
EXPOSE <port> [<port>/<protocol>...]
```

## USER

### 相关

 用于指定执行后续命令的用户和用户组，这边只是切换后续命令执行的用户 

### 通式

```dockerfile
USER <user>[:<group>]
USER <UID>[:<GID>]
```

### 注意

相关的user或group已经在容器中存在了

# 实战

现在我将在我的服务器上新建一个dockerfile文件，并对其进行构建。

## 需求

新建一个镜像，封装consul注册中心，开箱即用。

因为我最近正在做相关的工作，所以使用的这个例子，如果之前没有接触过consul的安装，可以自行去查找资料，这有利于你理解下面的内容

## 前期准备

### base image 选型

这里我们使用的是官方的alpine，alpine是一个基于Alpine Linux的Docker镜像，只有5MB，有许多组件都是用这个作为base image。

### consul选型

选择当前较新的1.9.1---2021.1.2

## Dockerfile

```dockerfile
# Set the base image
FROM alpine:3.12

# This is the release of Consul to pull in.
ENV CONSUL_VERSION=1.9.1

# This is the location of the releases.
ENV HASHICORP_RELEASES=https://releases.hashicorp.com

# Create a consul user and group first so the IDs get set the same way, even as
# the rest of this may change over time.
RUN addgroup consul && \
    adduser -S -G consul consul

# Set up certificates, base tools, and Consul.
# libc6-compat is needed to symlink the shared libraries for ARM builds
# Set the shell 
# e: if return 0 exit, 
# u: when an undefined variable is used during execution, an error message is displayed,
# x: after the instruction is executed, the instruction and its parameters will be displayed first.
RUN set -eux && \
    # apk: the package tool in alpine
    # install curl dumb-init gnupg libcap openssl su-exec iputils jq libc6-compat 
    apk add --no-cache ca-certificates curl dumb-init gnupg libcap openssl su-exec iputils jq libc6-compat && \
    gpg --keyserver pgp.mit.edu --recv-keys 91A6E7F85D05C65630BEF18951852D87348FFC4C && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    # choose a system 
    apkArch="$(apk --print-arch)" && \
    case "${apkArch}" in \
        aarch64) consulArch='arm64' ;; \
        armhf) consulArch='armhfv6' ;; \
        x86) consulArch='386' ;; \
        x86_64) consulArch='amd64' ;; \
        *) echo >&2 "error: unsupported architecture: ${apkArch} (see ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/)" && exit 1 ;; \
    esac && \
    # get consul
    wget ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${consulArch}.zip && \
    wget ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS && \
    wget ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig && \
    # check the consul
    gpg --batch --verify consul_${CONSUL_VERSION}_SHA256SUMS.sig consul_${CONSUL_VERSION}_SHA256SUMS && \
    grep consul_${CONSUL_VERSION}_linux_${consulArch}.zip consul_${CONSUL_VERSION}_SHA256SUMS | sha256sum -c && \
    # unzip the consul
    unzip -d /bin consul_${CONSUL_VERSION}_linux_${consulArch}.zip && \
    cd /tmp && \
    # delete the temp file
    rm -rf /tmp/build && \
    gpgconf --kill all && \
    apk del gnupg openssl && \
    rm -rf /root/.gnupg && \
    # tiny smoke test to ensure the binary we downloaded runs
    consul version

# The /consul/data dir is used by Consul to store state. The agent will be started
# with /consul/config as the configuration directory so you can add additional
# config files in that location.
RUN mkdir -p /consul/data && \
    mkdir -p /consul/config && \
    chown -R consul:consul /consul

# set up nsswitch.conf for Go's "netgo" implementation which is used by Consul,
# otherwise DNS supercedes the container's hosts file, which we don't want.
RUN test -e /etc/nsswitch.conf || echo 'hosts: files dns' > /etc/nsswitch.conf
# Expose the consul data directory as a volume since there's mutable state in there.
VOLUME /consul/data

# Server RPC is used for communication between Consul clients and servers for internal
# request forwarding.
EXPOSE 8300

# Serf LAN and WAN (WAN is used only by Consul servers) are used for gossip between
# Consul agents. LAN is within the datacenter and WAN is between just the Consul
# servers in all datacenters.
EXPOSE 8301 8301/udp 8302 8302/udp

# HTTP and DNS (both TCP and UDP) are the primary interfaces that applications
# use to interact with Consul.
EXPOSE 8500 8600 8600/udp

# Consul doesn't need root privileges so we run it as the consul user from the
# entry point script. The entry point script also uses dumb-init as the top-level
# process to reap any zombie processes created by Consul sub-processes.
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# By default you'll get an insecure single-node development server that stores
# everything in RAM, exposes a web UI and HTTP endpoints, and bootstraps itself.
# Don't use this configuration for production.
CMD ["agent", "-dev", "-client", "0.0.0.0"]
```

##  docker-entrypoint.sh

```shell
#!/usr/bin/dumb-init /bin/sh
set -e

# Note above that we run dumb-init as PID 1 in order to reap zombie processes
# as well as forward signals to all processes in its session. Normally, sh
# wouldn't do either of these functions so we'd leak zombies as well as do
# unclean termination of all our sub-processes.
# As of docker 1.13, using docker run --init achieves the same outcome.

# You can set CONSUL_BIND_INTERFACE to the name of the interface you'd like to
# bind to and this will look up the IP and pass the proper -bind= option along
# to Consul.
CONSUL_BIND=
if [ -n "$CONSUL_BIND_INTERFACE" ]; then
  CONSUL_BIND_ADDRESS=$(ip -o -4 addr list $CONSUL_BIND_INTERFACE | head -n1 | awk '{print $4}' | cut -d/ -f1)
  if [ -z "$CONSUL_BIND_ADDRESS" ]; then
    echo "Could not find IP for interface '$CONSUL_BIND_INTERFACE', exiting"
    exit 1
  fi

  CONSUL_BIND="-bind=$CONSUL_BIND_ADDRESS"
  echo "==> Found address '$CONSUL_BIND_ADDRESS' for interface '$CONSUL_BIND_INTERFACE', setting bind option..."
fi

# You can set CONSUL_CLIENT_INTERFACE to the name of the interface you'd like to
# bind client intefaces (HTTP, DNS, and RPC) to and this will look up the IP and
# pass the proper -client= option along to Consul.
CONSUL_CLIENT=
if [ -n "$CONSUL_CLIENT_INTERFACE" ]; then
  CONSUL_CLIENT_ADDRESS=$(ip -o -4 addr list $CONSUL_CLIENT_INTERFACE | head -n1 | awk '{print $4}' | cut -d/ -f1)
  if [ -z "$CONSUL_CLIENT_ADDRESS" ]; then
    echo "Could not find IP for interface '$CONSUL_CLIENT_INTERFACE', exiting"
    exit 1
  fi

  CONSUL_CLIENT="-client=$CONSUL_CLIENT_ADDRESS"
  echo "==> Found address '$CONSUL_CLIENT_ADDRESS' for interface '$CONSUL_CLIENT_INTERFACE', setting client option..."
fi

# CONSUL_DATA_DIR is exposed as a volume for possible persistent storage. The
# CONSUL_CONFIG_DIR isn't exposed as a volume but you can compose additional
# config files in there if you use this image as a base, or use CONSUL_LOCAL_CONFIG
# below.
CONSUL_DATA_DIR=/consul/data
CONSUL_CONFIG_DIR=/consul/config

# You can also set the CONSUL_LOCAL_CONFIG environemnt variable to pass some
# Consul configuration JSON without having to bind any volumes.
if [ -n "$CONSUL_LOCAL_CONFIG" ]; then
	echo "$CONSUL_LOCAL_CONFIG" > "$CONSUL_CONFIG_DIR/local.json"
fi

# If the user is trying to run Consul directly with some arguments, then
# pass them to Consul.
if [ "${1:0:1}" = '-' ]; then
    set -- consul "$@"
fi

# Look for Consul subcommands.
if [ "$1" = 'agent' ]; then
    shift
    set -- consul agent \
        -data-dir="$CONSUL_DATA_DIR" \
        -config-dir="$CONSUL_CONFIG_DIR" \
        $CONSUL_BIND \
        $CONSUL_CLIENT \
        "$@"
elif [ "$1" = 'version' ]; then
    # This needs a special case because there's no help output.
    set -- consul "$@"
elif consul --help "$1" 2>&1 | grep -q "consul $1"; then
    # We can't use the return code to check for the existence of a subcommand, so
    # we have to use grep to look for a pattern in the help output.
    set -- consul "$@"
fi

# If we are running Consul, make sure it executes as the proper user.
if [ "$1" = 'consul' -a -z "${CONSUL_DISABLE_PERM_MGMT+x}" ]; then
    # If the data or config dirs are bind mounted then chown them.
    # Note: This checks for root ownership as that's the most common case.
    if [ "$(stat -c %u "$CONSUL_DATA_DIR")" != "$(id -u consul)" ]; then
        chown consul:consul "$CONSUL_DATA_DIR"
    fi
    if [ "$(stat -c %u "$CONSUL_CONFIG_DIR")" != "$(id -u consul)" ]; then
        chown consul:consul "$CONSUL_CONFIG_DIR"
    fi

    # If requested, set the capability to bind to privileged ports before
    # we drop to the non-root user. Note that this doesn't work with all
    # storage drivers (it won't work with AUFS).
    if [ ! -z ${CONSUL_ALLOW_PRIVILEGED_PORTS+x} ]; then
        setcap "cap_net_bind_service=+ep" /bin/consul
    fi

    set -- su-exec consul:consul "$@"
fi

exec "$@"
```



## start.sh

一个启动脚本

```shell
docker stop $(docker ps -q)
docker rm consul-1
docker build --rm -t consul:centos-1.0 .
docker run -it -p 8500:8500 --name consul-1  consul:centos-1.0
```

## 构建并启动

将以上三个文件放到同一个文件夹下，执行start.sh脚本，确认无误后访问[yourIp:8500](yourIp:8500)

![1609613270860](G:\个人\MDFile\docker\4_dockerfile\images\consul_site.png)

此时就已经在你的服务器上搭建了一个consul节点，不过是以dev模式启动的。

# 总结

这一篇文章浪费了两个周，其中大部分时间浪费在了base image的选型上，最后是参考官方的Dockerfile才解决了问题。

总体上来说，入门不算难，难的是写好一个Dockerfile需要比较深厚的shell基础。

文章中有一些细节没有写出来，如果你在跟着做的过程中出现了问题，欢迎私信我交流。
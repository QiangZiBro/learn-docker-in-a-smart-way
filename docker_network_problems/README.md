# Docker网络问题经验谈

[TOC]

## 导言

docker是环境管理和项目部署的一大利器，笔者研究生阶段在实验、比赛中使用良多。本文汇总国内开发者使用docker遇到头疼的网络问题。

宿主机使用由docker镜像构建的命令行代理，可参考https://github.com/QiangZiBro/Qdotfiles，本文不讲解。假设你的宿主机命令行代理端口是8999，下面介绍几种使用场景。

## 国内镜像源配置

第1步，`vim /etc/docker/daemon.json`，将本文件写为：

```bash
{
    "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```

> Docker中国区官方镜像
> https://registry.docker-cn.com
>
> 网易
> http://hub-mirror.c.163.com
>
> ustc 
> https://docker.mirrors.ustc.edu.cn
>
> 中国科技大学
> https://docker.mirrors.ustc.edu.cn
>
> 阿里云容器  服务
> https://cr.console.aliyun.com/
>
> 首页点击“创建我的容器镜像”  得到一个专属的镜像加速地址，类似于“https://1234abcd.mirror.aliyuncs.com”

第2步

```bash
systemctl restart docker.service
```

## 编译时使用代理

遇到一些git/pip操作，仍然无法连接，首先将宿主机配置好代理，编译时：

```bash
docker build -t image_name . --network host \
        --build-arg http_proxy=${http_proxy}\
        --build-arg https_proxy=${https_proxy}
```

## 运行时使用代理

首先将宿主机配置好代理，运行时：

```bash
docker run -it --network=host \
        --env http_proxy=${http_proxy}\
        --env https_proxy=${https_proxy} image_name
```

## pycharm使用docker时使用代理

还有一种情况是使用专业版pycharm+docker环境，运行时会遇到一些下载操作，这种情况也需要使用代理。和上一个方法一样，对每一个运行配置，只需要加入下面参数即可。

```bash
--env http_proxy=${http_proxy} --env https_proxy=${https_proxy} 
```

## docker-compose 中设置代理

```bash
version: "3.0"
services:
    my_service:
        image: image_name
        build:
            context: ./
            dockerfile: Dockerfile
        network_mode: "host" #注意使用此模式不需要端口映射，否则会报错
        environment:
            - "http_proxy=127.0.0.1:8999"
            - "https_proxy=127.0.0.1:8999"
```


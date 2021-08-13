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

> 国内从 DockerHub 拉取镜像有时会遇到困难，此时可以配置镜像加速器。Docker 官方和国内很多云服务商都提供了国内加速器服务，例如：
> 
>- 科大镜像：**https://docker.mirrors.ustc.edu.cn/**
> - 网易：**https://hub-mirror.c.163.com/**
> - 阿里云：**https://<你的ID>.mirror.aliyuncs.com**
>- 七牛云加速器：**https://reg-mirror.qiniu.com**
> 
> 当配置某一个加速器地址之后，若发现拉取不到镜像，请切换到另一个加速器地址。国内各大云服务商均提供了 Docker 镜像加速服务，建议根据运行 Docker 的云平台选择对应的镜像加速服务。
>
> 阿里云镜像获取地址：https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors，登陆后，左侧菜单选中镜像加速器就可以看到你的专属地址了：
> 
>![img](https://www.runoob.com/wp-content/uploads/2019/10/02F3AF04-8203-4E3B-A5AF-96973DBE515F.jpg)

第2步

```bash
systemctl restart docker.service
```

## Docker pull 设置代理

参考https://docs.docker.com/config/daemon/systemd/#httphttps-proxy

## 编译时使用代理

遇到一些git/pip操作，仍然无法连接，首先将宿主机配置好代理，编译时：

```bash
docker build -t image_name . --network host \
        --build-arg http_proxy=${http_proxy}\
        --build-arg https_proxy=${https_proxy}
```

## 运行容器时使用代理

方法1：首先将宿主机配置好代理，运行时：

```bash
docker run -it --network=host \
        --env http_proxy=${http_proxy}\
        --env https_proxy=${https_proxy} image_name
```

方法2：参考[官方文档](https://docs.docker.com/network/proxy/)，编辑`~/.docker/config.json`，添加如下内容 

```bash
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "127.0.0.1:1087",
     "httpsProxy": "127.0.0.1:1087",
     "noProxy": "*.test.example.com,.example2.com,127.0.0.0/8"
   }
 }
}
```

保存后，之后的容器代理就是配置文件设置的代理 。

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
            - "http_proxy=${http_proxy}"
            - "https_proxy=${https_proxy}"
```

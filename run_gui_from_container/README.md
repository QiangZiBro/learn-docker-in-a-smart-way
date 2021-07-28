# 宿主机上运行Docker容器gui

[TOC]

## 导言

问：我想在容器里运行一个带`cv2.show()`/`plt.show()`/各种图形显示的程序，该怎么做？

答：看本文即可。本文提供在Mac/Linux的docker容器里显示图形界面的方法（Windows用户默泪…抱歉笔者手边没有windows系统）



容器里没有显示屏，无法供我们运行opencv或者plt的显示，但可以通过中间程序搭起桥梁。本文相关Dockerfile，python显示文件可在https://github.com/QiangZiBro/docker-tutorial/tree/main/run_gui_from_container找到。

## Mac上运行的docker容器显示图像

### 解决方案

socat+xquartz，docker容器内部`$DISPLAY`设为主机ip

### 准备工作

第0步，homebrew安装

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

第1步，socat 安装，用 **socat** 来解决容器和 Mac 主机 GUI 的通信问题：

<img src="https://gitee.com/qiangzibro/uPic/raw/master/uPic/1046925-20190824165625707-1560779550.png" alt="img" style="zoom: 25%;" />

```
brew install socat
```

第2步，xquartz 安装，处理 X windows system

```
brew install xquartz
```

安装好了之后需要**注销并重新进入 Mac 主机**。

第3步，xquartz 配置

重启之后我们发现有了环境变量 `$DISPLAY`。

```
echo $DISPLAY
/private/tmp/com.apple.launchd.nzm51qjuIW/org.macosforge.xquartz:0
```

**点击应用图标**或者**命令行输入**：

```
open -a Xquartz
```

程序坞可以看到有一个 Xquartz 应用：

![img](https://gitee.com/qiangzibro/uPic/raw/master/uPic/1046925-20190824173752510-977533929.png)

在这个应用下进行偏好设置，勾选允许从网络客户端连接：

![img](https://gitee.com/qiangzibro/uPic/raw/master/uPic/1046925-20190824174022289-1832774345.png)

**配置之后，此时暂时 Command+Q 退出 Xquartz 应用。**

第4步，Socat 配置，我们在有了 DISPLAY 环境变量之后，才会对 Socat 进行配置，输入：

```
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

**注意这个进程一直是运行状态，不要中断它。**

### 容器配置

让我们查看**主机 OS 上的 IP 地址**：

```
ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'
```

第2个是我的mac ip

```
inet 127.0.0.1
inet 192.168.3.2
```

因此，**容器内**设置环境变量指向这个 IP 地址（由于退出容器后不会保存环境变量，因此每次进入容器都要执行这个命令）：

```
export DISPLAY=192.168.3.2:0
```

至此，如果没有问题，我们运行显示图片的程序就可以成功了。



技巧1： 在docker run 时设置环境变量

```bash
docker run -e DISPLAY=192.168.3.2:0 [image_id]
```

技巧2： 在docker-compose时写入环境变量

```yaml
version: '3'
services:
  show_image:
    image: [image_id]
    command: bash -c "python main.py"
    environment:
      - "DISPLAY=192.168.3.2:0"
```



## Linux上运行的docker容器显示图像

### 解决方案

运行docker时共享`/tmp/.X11-unix`这个文件夹

### 准备工作

```bash
#安装xserver
sudo apt install x11-xserver-utils
#许可所有用户都可访问xserver    注意加号前应有空格
xhost +
# 查看当前显示的环境变量值 (要在显示屏查看，其他ssh终端不行) 
echo $DISPLAY 
```

我的是

```text
:11.0
```

### 容器配置

使用image创建docker容器时，通过-v参数设置docker内外路径挂载，使显示xserver设备的socket文件在docker内也可以访问。并通过-e参数设置docker内的DISPLAY参数和宿主机一致。

技巧1：在创建docker容器时，添加选项如下:

```bash
-v /tmp/.X11-unix:/tmp/.X11-unix
-e DISPLAY=:11.0
#例如：
docker run -itd --name 容器名 -h 容器主机名 --privileged \
           -v /tmp/.X11-unix:/tmp/.X11-unix  \
           -e DISPLAY=:11.0 镜像名或id /bin/bash
```

技巧2： 使用docker-compose

```bash
version: '3'
services:
  show_image:
    image: show_image_docker
    volumes:
        - /tmp/.X11-unix:/tmp/.X11-unix
    command: bash -c "python main.py"
    environment:
      - "DISPLAY=:0"
```

## 运行Github例子

```bash
# 做好上述准备工作
git clone https://github.com/QiangZiBro/docker-tutorial
cd docker-tutorial/run_gui_from_container
bash setup.sh # 生成docker-compose.yml文件
make build
make up
```

## 参考资料

[ 1 ] : https://www.cnblogs.com/noluye/p/11405358.html

[ 2 ] : https://blog.csdn.net/a806689294/article/details/111462627
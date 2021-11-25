## 配置

首先，到一个容量尚可的硬盘

```bash
mkdir nextcloud
cd nextcloud
mkdir nextcloud db
vim docker-compose.yml
```
将下列内容复制进去
```dockerfile
version: '2'

services:
  db:
    image: mariadb
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    restart: always
    volumes:
      - ./db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_PASSWORD=password
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: nextcloud
    ports:
      - 8080:80
      - 80:80
    links:
      - db
    volumes:
      - ./nextcloud:/var/www/html
    restart: always
```

打开8080端口，按下图配好

![40917422.png](https://gitee.com/qiangzibro/uPic/raw/master/uPic/40917422.png)



## 使用

### 技巧1 命令行上传文件

```bash
curl -u 用户名:密码 -s -S -T 要上传的文件路径 "http://你的ip地址/remote.php/files/目标文件路径/"
```


### 技巧2 命令行下载文件
```bash
curl -u 用户名:密码 "http://你的ip地址/remote.php/files/文件路径" --output 文件路径
```

例：在一台新机器上运行命令行代理
```bash
# 准备好代理的配置文件~/.Qdotfiles/ss/ss.json
# 从内网下载qlinux镜像
curl -u 用户名:密码 "http://10.22.78.13/remote.php/files/508源/网络方面/qlinux.tar" --output qlinux.tar
# 加载这个镜像
docker load < qlinux.tar
# 开启 ~~~
cq && dcd && cg
```

### 技巧3 命令行创建文件夹

```bash
# <user> user name in nextcloud
# <pass> password <user>
# <nextcloud root> root folder of nextcloud ex) https://abc.com/nextcloud
# <folder path to create> Path of nextcloud where you want to create folder as
curl -X MKCOL -u <user>:<pass> https://<nextcloud root>/remote.php/dav/files/<user>/<folder path to create>
```

### 技巧4 命令行删除文件夹

```bash
# <user> user name in nextcloud
# <pass> password <user>
# <nextcloud root> root folder of nextcloud ex) https://abc.com/nextcloud
# <folder path to delete> Path of nextcloud which you want to delete folder
curl -X DELETE -u <user>:<pass> https://<nextcloud root>/remote.php/dav/files/<user>/<folder path to delete>
```

### 技巧5 递归上传文件夹

> https://help.nextcloud.com/t/use-api-and-curl-to-download-folders/51184/3

Instead of using curl I recommend to use [**cadaver** 100](https://www.systutorials.com/docs/linux/man/1-cadaver/). With this command line tool you should be able to automate your WebDAV activities better.
To get it working you first need to create a `~/.netrc` file and add at least the following lien:

```
machine MYSERVER login YOUR-LOGIN password YOUR-PASSWORD
```

Second, you create a command script, e.g. `cadaver.rc` to tell the program what it should do, like:

```
open https://MYSERVER/nextcloud/remote.php/webdav/REMOTE-PATH
lcd /YOUR-LOCAL-PATH
mget *txt
quit
```

Finally you call the command as follows: `cadaver -r cadaver.rc`

THAT’S IT!



## 参考

[1] : https://www.youtube.com/watch?v=dmsW7sKxWVU


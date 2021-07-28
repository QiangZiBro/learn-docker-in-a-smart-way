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

## 参考
[1] : https://www.youtube.com/watch?v=dmsW7sKxWVU


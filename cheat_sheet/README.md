## 增
## 镜像导出文件

```bash
docker save image_name > path/to/image.tar
```
## 从镜像文件加载

```bash
docker load < image.tar
```


> Note
>
> - `docker save images_name`将一个镜像导出为文件，再使用docker load,命令将文件导入为一个镜像，会保存该镜像的的所有历史记录。比docker export 命令导出的文件大，很好理解，因为会保存镜像的所有历史记录。
> - `docker export container_id`将一个容器导出为文件，再使用docker import，命令将容器导入成为一个新的镜像，但是相比docker save命令，容器文件会丢失所有元数据和历史记录，仅保存容器当时的状态，相当于虚拟机快照。
>



## 删
- docker一键停止删除所有容器和镜像<font color=red>（谨慎使用或者不要使用！）</font>
```bash
docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -aq)
```
- docker删除为none的镜像[参考]([https://forums.docker.com/t/how-to-remove-none-images-after-building/7050/16](https://forums.docker.com/t/how-to-remove-none-images-after-building/7050/16))
```bash
docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }') #停止容器
docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }') #删除容器
docker rmi $(docker images | grep "none" | awk '{print $3}') #删除镜像
```


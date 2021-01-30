# 异常详情
    root@baldwin:/home/baldwin# apt-get update
    ......
    忽略:16 http://ppa.launchpad.net/webupd8team/java/ubuntu eoan InRelease
    忽略:17 http://ppa.launchpad.net/wine/wine-builds/ubuntu eoan InRelease
    错误:18 http://ppa.launchpad.net/deadsnakes/ppa/ubuntu eoan Release
    404  Not Found [IP: 91.189.95.83 80]
    错误:19 http://ppa.launchpad.net/hzwhuang/ss-qt5/ubuntu eoan Release
    ......
    正在读取软件包列表... 完成
    E: 仓库 “http://ppa.launchpad.net/deadsnakes/ppa/ubuntu eoan Release” 没有 Release 文件。
    N: 无法安全地用该源进行更新，所以默认禁用该源。
    N: 参见 apt-secure(8) 手册以了解仓库创建和用户配置方面的细节。
    E: 仓库 “http://ppa.launchpad.net/hzwhuang/ss-qt5/ubuntu eoan Release” 没有 Release 文件。
    N: 无法安全地用该源进行更新，所以默认禁用该源。
    N: 参见 apt-secure(8) 手册以了解仓库创建和用户配置方面的细节。
    ......

# 异常分析
## 异常等级
这个异常对于apt的影响不大，他仅仅是针对某个源。
## 异常原因
我们直接从字面意思上来看，结合**404  Not Found [IP: 91.189.95.83 80]**和**仓库 “http://ppa.launchpad.net/deadsnakes/ppa/ubuntu eoan Release” 没有 Release 文件**，我们推测应该是这个源链接下架了或者其他原因导致我们这个链接已经不可用，那解决办法就是删掉这个源地址或者改变这个地址，这个源我现在也不用了，所以选择删掉。
# 解决办法
刚才说了，我打算直接删掉这些不可用的源链接，在Ubantu中，apt源文件保存在**/etc/apt/sources.list.d** 文件夹下，我们来到ll一下这个文件夹，发现了很多个源文件，找一下文件名与报错中有关联的文件删除掉，**如果不是很了解这些源文件，我建议不要直接删除，可以把他更名为.bak文件备份**

    root@baldwin:/home/baldwin# ll /etc/apt/sources.list.d/
    总用量 80
    drwxr-xr-x 2 root root 4096 4月  18 13:04 ./
    drwxr-xr-x 7 root root 4096 4月  18 13:02 ../
    -rw-r--r-- 1 root root  128 4月  18 13:20 deadsnakes-ubuntu-ppa-eoan.list
    -rw-r--r-- 1 root root  128 4月  18 13:20 deadsnakes-ubuntu-ppa-eoan.list.save
    -rw-r--r-- 1 root root  189 4月  18 13:20 google-chrome.list
    ......

**删除掉**

    root@baldwin:/etc/apt/sources.list.d# rm ./deadsnakes-ubuntu-ppa-eoan.list
    root@baldwin:/etc/apt/sources.list.d# rm ./deadsnakes-ubuntu-ppa-eoan.list.save 
    root@baldwin:/etc/apt/sources.list.d# rm ./hzwhuang-ubuntu-ss-qt5-eoan.list
    ......

**update**

    root@baldwin:/etc/apt/sources.list.d# apt-get update
    命中:1 http://archive.ubuntukylin.com:10006/ubuntukylin bionic InRelease
    忽略:2 http://dl.google.com/linux/chrome/deb stable InRelease                                                                                                           
    命中:3 http://mirrors.aliyun.com/ubuntu xenial InRelease                                                                                                               
    ......             
    正在读取软件包列表... 完成

不再报错

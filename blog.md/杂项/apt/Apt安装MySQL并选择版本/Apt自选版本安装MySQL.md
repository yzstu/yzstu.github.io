# 1. 背景
前几天发了一篇关于[Deepin安装Docker+DockerMySQL5.7](https://blog.csdn.net/shouchenchuan5253/article/details/105671928)的文章，然后我在docker外就没有安装MySQL，一开始直接用DockerMySQL还挺爽的，然后我就把我的一些测试数据导了进去（花了我三个小时），然后就一直在用这个来工作。

然而！！！今天忽然DockerMySQL无法登录获取数据了，果然还是不靠谱。没办法就再在本机上安装一个MySQL。作为一个懒人，我当然是倾向于直接使用APT安装，方便又快捷，岂不美哉？去网上搜了关键字“apt暗转MySQL5.7”，虽然题目是安装5.7.但是内容其实都是直接“apt-get install mysql”的，说实话我又想吐槽，这种教程估计又坑害了许多新人，也不知道大家都是抄袭谁的。技术人不应该去求真务实么？这种教程到底作者有没有去自己试一遍呢？

没办法，最后只能去看一遍官方文档，然后自己做一遍，现在写下来供大家参考。

# 2. 环境
Deepin 20 + 安装MySQL5.7
# 3. 下载官方软件仓库

    地址：http://dev.mysql.com/downloads/repo/apt/

访问这个地址去下载官方仓库文件，如果是无UI的服务器可以使用wget命令，后面的网址记得换一下，我写文章的时间是2020-4-28,不保证你看到这篇文章的时候链接还有效

    wget https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb

# 4. 安装

## 4.1. dpkg
在你deb文件的文件夹下使用dpkg命令安装deb包

    sudo dpkg -i mysql-apt-config_0.8.15-1_all.deb

<img align="center" src=images/MySQLConfig.png>

## 4.2. 选择MySQL版本
注意看上面的图，是不是有一个红框？上下键可以移动光标，光标在那里的是时候按Enter键进入就可以选择MySQL版本了

<img align="center" src=images/MySQL5.7Config.png>

我们这里选择的是MySQL5.7,你可以按照自己的需求去选择。

## 4.3. 库安装完成

选择完版本之后按enter又可以退回到第一个界面了，这时候我们选择的旧已经是5.7版本了，剩下的两个也是按照自己需求来选择，我就直接是默认值了，最后光标到OK上，按下enter键，等待安装完成。

结果：

    Warning: apt-key should not be used in scripts (called from postinst maintainerscript of the package mysql-apt-config)
    OK

出现了ok就说明安装成功了。

## 4.4. 更新apt仓库

命令：

    sudo apt-get update

结果：

    baldwin@baldwin:~/Downloads$ sudo apt-get update
    命中:1 http://mirrors.aliyun.com/deepin lion InRelease
    命中:2 https://community-packages.deepin.com/deepin apricot InRelease                                                                                 
    命中:4 https://cdn-package-store6.deepin.com/appstore eagle InRelease                                                                                 
    命中:3 http://uos.deepin.cn/printer eagle InRelease                                                                    
    命中:5 http://repo.mysql.com/apt/debian jessie InRelease                                                              
    获取:6 http://repo.mysql.com/apt/debian jessie/mysql-5.7 Sources [949 B]   
    获取:7 http://repo.mysql.com/apt/debian jessie/mysql-5.7 amd64 Packages [3,384 B]                
    获取:8 http://repo.mysql.com/apt/debian jessie/mysql-5.7 i386 Packages [3,369 B]       
    命中:9 https://mirrors.ustc.edu.cn/docker-ce/linux/debian stretch InRelease             
    已下载 7,702 B，耗时 6秒 (1,336 B/s)
    正在读取软件包列表... 完成

看一下，我们MySQL5.7的相关组件已经可以安装了。

## 4.5. 安装MySQL5.7

命令：
    sudo apt-get install mysql-server 

等待安装完成，安装过程会让你输入一个root密码，输入并牢记

结果：

    ......
    2020-04-28T14:48:20.705160Z 0 [Warning] Gtid table is not ready to be used. Table 'mysql.gtid_executed' cannot be opened.
    2020-04-28T14:48:21.791007Z 0 [Warning] CA certificate ca.pem is self signed.
    2020-04-28T14:48:22.062270Z 1 [Warning] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
    Created symlink /etc/systemd/system/multi-user.target.wants/mysql.service → /lib/systemd/system/mysql.service.
    正在设置 mysql-server (5.7.30-1debian8) ...
    正在处理用于 systemd (241.5+c1-1+eagle) 的触发器 ...
    正在处理用于 man-db (2.8.5-2) 的触发器 ...
    正在处理用于 libc-bin (2.28.7-1+deepin) 的触发器 ...

## 4.6. 启动数据库
安装已经完成了，现在来启动一下试试
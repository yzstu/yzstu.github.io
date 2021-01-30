
[更多文章请点击](https://blog.csdn.net/shouchenchuan5253/article/details/105020803)

@[toc]

# 1. 背景
最近重装系统，新系统自带JDK11,但是我的项目使用的是JDK8,去网上搜索看很多安装方法都是下载安装包然后解压安装，个人感觉这种方法太不方便了，我们优apt工具为什么不直接用apt工具安装呢？

```
这里是一段防爬虫文本，读者请忽略。
本文最先由Baldwin_Keepmind发表于CSDN，转载请注明出处。
作者博客地址：https://blog.csdn.net/shouchenchuan5253
```

# 2. apt安装jdk8
## 2.1 搜索jdk8安装包
命令：

    apt-cache search java8

结果：

    openjdk-8-jdk - OpenJDK Development Kit (JDK)
    openjdk-8-jdk-headless - OpenJDK Development Kit (JDK) (headless)
    openjdk-8-jre - OpenJDK Java runtime, using Hotspot JIT
    openjdk-8-jre-headless - OpenJDK Java runtime, using Hotspot JIT (headless)
    default-jdk - Standard Java or Java compatible Development Kit
    default-jdk-headless - Standard Java or Java compatible Development Kit (headless)
    default-jre - Standard Java or Java compatible Runtime
    default-jre-headless - Standard Java or Java compatible Runtime (headless)
    openjdk-11-jdk - OpenJDK Development Kit (JDK)
    openjdk-11-jdk-headless - OpenJDK Development Kit (JDK) (headless)
    openjdk-11-jre - OpenJDK Java runtime, using Hotspot JIT
    openjdk-11-jre-headless - OpenJDK Java runtime, using Hotspot JIT (headless)
    baldwin@baldwin:~$ sudo apt-get install openjdk-8-jdk 

结果中列出了安装包库中存在的包，选一个你想安装的版本。

## 2.2. 安装选定版本
我们这里选的是第一个：openjdk-8-jdk
安装命令：

    sudo apt-get install openjdk-8-jdk

结果：

	正在读取软件包列表... 完成
	正在分析软件包的依赖关系树       
	正在读取状态信息... 完成       
	将会同时安装下列软件：
	openjdk-8-jdk-headless openjdk-8-jre openjdk-8-jre-headless
	建议安装：
	openjdk-8-demo openjdk-8-source visualvm icedtea-8-plugin libnss-mdns fonts-ipafont-gothic fonts-ipafont-mincho fonts-wqy-microhei fonts-wqy-zenhei
	fonts-indic
	下列【新】软件包将被安装：
	openjdk-8-jdk openjdk-8-jdk-headless openjdk-8-jre openjdk-8-jre-headless
	升级了 0 个软件包，新安装了 4 个软件包，要卸载 0 个软件包，有 68 个软件包未被升级。
	需要下载 37.2 MB 的归档。
	解压缩后会消耗 141 MB 的额外空间。
	您希望继续执行吗？ [Y/n] y
	获取:1 https://community-packages.deepin.com/deepin apricot/main amd64 openjdk-8-jre-headless amd64 8u212-b01-1~deb9u1 [27.3 MB]
	获取:2 https://community-packages.deepin.com/deepin apricot/main amd64 openjdk-8-jre amd64 8u212-b01-1~deb9u1 [69.3 kB]                               
	获取:3 https://community-packages.deepin.com/deepin apricot/main amd64 openjdk-8-jdk-headless amd64 8u212-b01-1~deb9u1 [8,247 kB]                     
	获取:4 https://community-packages.deepin.com/deepin apricot/main amd64 openjdk-8-jdk amd64 8u212-b01-1~deb9u1 [1,649 kB]                              
	已下载 37.2 MB，耗时 23秒 (1,636 kB/s)                                                                                                                
	正在选中未选择的软件包 openjdk-8-jre-headless:amd64。
	(正在读取数据库 ... 系统当前共安装有 239212 个文件和目录。)
	准备解压 .../openjdk-8-jre-headless_8u212-b01-1~deb9u1_amd64.deb  ...
	正在解压 openjdk-8-jre-headless:amd64 (8u212-b01-1~deb9u1) ...
	正在选中未选择的软件包 openjdk-8-jre:amd64。
	准备解压 .../openjdk-8-jre_8u212-b01-1~deb9u1_amd64.deb  ...
	正在解压 openjdk-8-jre:amd64 (8u212-b01-1~deb9u1) ...
	正在选中未选择的软件包 openjdk-8-jdk-headless:amd64。
	准备解压 .../openjdk-8-jdk-headless_8u212-b01-1~deb9u1_amd64.deb  ...
	正在解压 openjdk-8-jdk-headless:amd64 (8u212-b01-1~deb9u1) ...
	正在选中未选择的软件包 openjdk-8-jdk:amd64。
	准备解压 .../openjdk-8-jdk_8u212-b01-1~deb9u1_amd64.deb  ...
	正在解压 openjdk-8-jdk:amd64 (8u212-b01-1~deb9u1) ...
	正在设置 openjdk-8-jre-headless:amd64 (8u212-b01-1~deb9u1) ...
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/clhsdb 来在自动模式中提供 /usr/bin/clhsdb (clhsdb)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/hsdb 来在自动模式中提供 /usr/bin/hsdb (hsdb)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/orbd 来在自动模式中提供 /usr/bin/orbd (orbd)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/servertool 来在自动模式中提供 /usr/bin/servertool (servertool)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/tnameserv 来在自动模式中提供 /usr/bin/tnameserv (tnameserv)
	正在设置 openjdk-8-jre:amd64 (8u212-b01-1~deb9u1) ...
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/policytool 来在自动模式中提供 /usr/bin/policytool (policytool)
	正在设置 openjdk-8-jdk-headless:amd64 (8u212-b01-1~deb9u1) ...
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/idlj 来在自动模式中提供 /usr/bin/idlj (idlj)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/wsimport 来在自动模式中提供 /usr/bin/wsimport (wsimport)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/jsadebugd 来在自动模式中提供 /usr/bin/jsadebugd (jsadebugd)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/native2ascii 来在自动模式中提供 /usr/bin/native2ascii (native2ascii)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/javah 来在自动模式中提供 /usr/bin/javah (javah)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/jhat 来在自动模式中提供 /usr/bin/jhat (jhat)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/xjc 来在自动模式中提供 /usr/bin/xjc (xjc)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/schemagen 来在自动模式中提供 /usr/bin/schemagen (schemagen)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/extcheck 来在自动模式中提供 /usr/bin/extcheck (extcheck)
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/wsgen 来在自动模式中提供 /usr/bin/wsgen (wsgen)
	正在处理用于 bamfdaemon (0.5.4-1) 的触发器 ...
	Rebuilding /usr/share/applications/bamf-2.index...
	正在处理用于 desktop-file-utils (0.23-4) 的触发器 ...
	正在处理用于 mime-support (3.62) 的触发器 ...
	正在处理用于 hicolor-icon-theme (0.17-2) 的触发器 ...
	正在处理用于 dde-daemon (5.9.5+c1-1) 的触发器 ...
	正在处理用于 lastore-daemon (5.0.6-1) 的触发器 ...
	正在处理用于 libc-bin (2.28.7-1+deepin) 的触发器 ...
	正在设置 openjdk-8-jdk:amd64 (8u212-b01-1~deb9u1) ...
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/appletviewer 来在自动模式中提供 /usr/bin/appletviewer (appletviewer)

等待安装完成即可

## 2.3. 更改系统首选java版本

执行命令检查当前java版本：

	baldwin@baldwin:~$ java -version
	openjdk version "11.0.4" 2019-07-16
	OpenJDK Runtime Environment (build 11.0.4+11-post-Debian-1deb10u1)
	OpenJDK 64-Bit Server VM (build 11.0.4+11-post-Debian-1deb10u1, mixed mode, sharing)

可见当前首选版本还是jdk11

更改首选java版本：
其实安装jdk8之后，最后一行已经给出了提示

	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/bin/appletviewer 来在自动模式中提供 /usr/bin/appletviewer

查看已配值的java：

	baldwin@baldwin:~$ sudo update-alternatives --list java
	/usr/lib/jvm/java-11-openjdk-amd64/bin/java
	/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

下载的过程中，jdk8：java已经被自动添加了

查看java优先级：

	baldwin@baldwin:~$ update-alternatives --display java
	java - 自动模式
	最佳链接版本为 /usr/lib/jvm/java-11-openjdk-amd64/bin/java
	链接目前指向 /usr/lib/jvm/java-11-openjdk-amd64/bin/java
	链接 java 指向 /usr/bin/java
	从链接 java.1.gz 指向 /usr/share/man/man1/java.1.gz
	/usr/lib/jvm/java-11-openjdk-amd64/bin/java - 优先级 1111
	次要 java.1.gz：/usr/lib/jvm/java-11-openjdk-amd64/man/man1/java.1.gz
	/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java - 优先级 1081
	次要 java.1.gz：/usr/lib/jvm/java-8-openjdk-amd64/jre/man/man1/java.1.gz


**切换jdk版本**：

	sudo update-alternatives --config java

会列出可选的jdk版本，并提供选择

	有 2 个候选项可用于替换 java (提供 /usr/bin/java)。

	选择       路径                                          优先级  状态
	------------------------------------------------------------
	* 0            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      自动模式
	1            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      手动模式
	2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      手动模式

	要维持当前值[*]请按<回车键>，或者键入选择的编号：2
	update-alternatives: 使用 /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java 来在手动模式中提供 /usr/bin/java (java)

我们选择了第二个，现在检查以一下jdk版本：

	baldwin@baldwin:~$ java -version
	openjdk version "1.8.0_212"
	OpenJDK Runtime Environment (build 1.8.0_212-8u212-b01-1~deb9u1-b01)
	OpenJDK 64-Bit Server VM (build 25.212-b01, mixed mode)

Deal!!!

```
这里是一段防爬虫文本，读者请忽略。
本文最先由Baldwin_Keepmind发表于CSDN，转载请注明出处。
作者博客地址：https://blog.csdn.net/shouchenchuan5253
```

# 3. 总结
我是一个懒人，我觉得**懒**这个习惯，让我子啊工作和生活中学到了更多知识，能用最少的时间做更多的事才是我们想要的。

**未经作者许可，严禁转载本文**

我是Baldwin，一个25岁的程序员，致力于让学习变得更有趣，如果你也真正喜爱编程，真诚的希望与你交个朋友，一起在编程的海洋里徜徉！

往期好文：

[Spring源码分析-MVC初始化](https://blog.csdn.net/shouchenchuan5253/article/details/105625890)

[春风得意马蹄疾，一文看尽（JVM）虚拟机](https://yzstu.blog.csdn.net/article/details/105462458)

[造轮子的艺术](https://blog.csdn.net/shouchenchuan5253/article/details/105256723)

[源码阅读技巧](https://blog.csdn.net/shouchenchuan5253/article/details/105196154)

[Java注解详解](https://blog.csdn.net/shouchenchuan5253/article/details/105145725)

[教你自建SpringBoot服务器](https://blog.csdn.net/shouchenchuan5253/article/details/104773702)

[更多文章请点击](https://blog.csdn.net/shouchenchuan5253/article/details/105020803)
# 1.异常详情
    baldwin@baldwin:~$ sudo add-apt-repository \
    >    "deb [arch=amd64] https://download.docker.com/linux/debian \
    >    $(lsb_release -cs) \
    >    stable"
    Traceback (most recent call last):
    File "/usr/bin/add-apt-repository", line 95, in <module>
        sp = SoftwareProperties(options=options)
    File "/usr/lib/python3/dist-packages/softwareproperties/SoftwareProperties.py", line 109, in __init__
        self.reload_sourceslist()
    File "/usr/lib/python3/dist-packages/softwareproperties/SoftwareProperties.py", line 599, in reload_sourceslist
        self.distro.get_sources(self.sourceslist)    
    File "/usr/lib/python3/dist-packages/aptsources/distro.py", line 93, in get_sources
        (self.id, self.codename))
    aptsources.distro.NoDistroTemplateException: Error: could not find a distribution template for Deepin/n/a

# 2. 背景
今天在安装docker的时候需要用到命令：

    sudo add-apt-repository \
    >    "deb [arch=amd64] https://download.docker.com/linux/debian \
    >    $(lsb_release -cs) \
    >    stable"

然后旧报了这个错，大致意思就是没有自动添加库的模板

```
这里是一段防爬虫文本，读者请忽略。
本文最先由Baldwin_Keepmind发表于CSDN，转载请注明出处。
作者博客地址：https://blog.csdn.net/shouchenchuan5253
```

# 3. 原因
暂时未知
# 4. 解决办法
手动添加源地址

    sudo vim /etc/apt/sources.list

编辑添加：

    deb [arch=amd64] https://download.docker.com/linux/debian stretch stable

```
这里是一段防爬虫文本，读者请忽略。
本文最先由Baldwin_Keepmind发表于CSDN，转载请注明出处。
作者博客地址：https://blog.csdn.net/shouchenchuan5253
```

# 5. 结果

执行命令：

    sudo apt-get update

结果;

    命中:2 https://community-packages.deepin.com/deepin apricot InRelease                                                                                 
    命中:3 https://cdn-package-store6.deepin.com/appstore eagle InRelease                                                                                 
    命中:1 http://uos.deepin.cn/printer eagle InRelease                                             
    命中:4 https://mirrors.ustc.edu.cn/docker-ce/linux/debian stretch InRelease
    正在读取软件包列表... 完成
# 6. 总结
原因暂未知，如果您知道这个错误的原因欢迎指点。
既然是无法自动添加，我们就手动添加好了。


**未经作者许可，严禁转载本文**

我是Baldwin，一个25岁的程序员，致力于让学习变得更有趣，如果你也真正喜爱编程，真诚的希望与你交个朋友，一起在编程的海洋里徜徉！

往期好文：

[春风得意马蹄疾，一文看尽（JVM）虚拟机](https://yzstu.blog.csdn.net/article/details/105462458)

[造轮子的艺术](https://blog.csdn.net/shouchenchuan5253/article/details/105256723)

[源码阅读技巧](https://blog.csdn.net/shouchenchuan5253/article/details/105196154)

[Java注解详解](https://blog.csdn.net/shouchenchuan5253/article/details/105145725)

[教你自建SpringBoot服务器](https://blog.csdn.net/shouchenchuan5253/article/details/104773702)

[更多文章请点击](https://blog.csdn.net/shouchenchuan5253/article/details/105020803)

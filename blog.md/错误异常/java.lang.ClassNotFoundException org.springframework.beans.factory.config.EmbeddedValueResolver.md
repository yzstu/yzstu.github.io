# 1. 问题背景

今天准备写一篇博客，需要用到一个SSM项目示例，于是从github上pull了一个，在运行测试的时候，所有的环境已经准备好了，但是运行的时候报了这样一个错误。

# 2. 问题原因

首先，Google大法。

我去网上查了下，大致的原因就是两个：

> 1.Spring-beans包未导入
>
> 2.Spring-beans包与其他包的版本不一致

# 3. 解决办法

查看了一下我的项目代码，排除第一种原因。

查看pom文件：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.liuyanzhao</groupId>
    <artifactId>ForestBlog</artifactId>
    <packaging>war</packaging>
    <version>1.0.0-SNAPSHOT</version>
    <name>ForestBlog Maven Webapp</name>
    <url>http://maven.apache.org</url>
    <dependencies>

       。。。。。。
        <!--spring aop编程支持-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aop</artifactId>
            <version>4.2.0.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aspects</artifactId>
            <version>4.2.0.RELEASE</version>
        </dependency>
        
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.2.5.RELEASE</version>
        </dependency>
		。。。。。。


</project>

```

可以看到，是spring-context包的版本与其他spring组件的版本不一致，修改版本为：4.2.0.RELEASE

重新运行，问题解决
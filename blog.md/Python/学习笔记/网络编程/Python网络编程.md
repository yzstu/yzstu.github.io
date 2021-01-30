# 1. 相关
## 1.1. 网络编程
网络编程从大的方面说就是对信息的发送到接收，中间传输为物理线路的作用。

网络编程最主要的工作就是在发送端把信息通过规定好的协议进行组装包，在接收端按照规定好的协议把包进行解析，从而提取出对应的信息，达到通信的目的。中间最主要的就是数据包的组装，数据包的过滤，数据包的捕获，数据包的分析，当然最后再做一些处理，代码、开发工具、数据库、服务器架设和网页设计这5部分你都要接触。
## 1.2. Socker
Socket又称"套接字"，应用程序通常通过"套接字"向网络发出请求或者应答网络请求，使主机间或者一台计算机上的进程间可以通讯。

## 1.3. Python网络服务

Python 提供了两个级别访问的网络服务。：

    低级别的网络服务支持基本的 Socket，它提供了标准的 BSD Sockets API，可以访问底层操作系统Socket接口的全部方法。
    高级别的网络服务模块 SocketServer， 它提供了服务器中心类，可以简化网络服务器的开发。

# 2. Python创建socker
通式：

    socket.socket([family[, type[, proto]]])

参数解释：

    family: 套接字家族可以使AF_UNIX或者AF_INET
    type: 套接字类型可以根据是面向连接的还是非连接分为SOCK_STREAM或SOCK_DGRAM
    protocol: 一般不填默认为0

# 3. Socket 对象(内建)方法

## 3.1.服务器端套接字

    s.bind()：绑定地址（host,port）到套接字， 在AF_INET下,以元组（host,port）的形式表示地址。
    s.listen()：开始TCP监听。backlog指定在拒绝连接之前，操作系统可以挂起的最大连接数量。该值至少为1，大部分应用程序设为5就可以了。
    s.accept()：被动接受TCP客户端连接,(阻塞式)等待连接的到来
## 3.2. 客户端套接字
    s.connect()：主动初始化TCP服务器连接，。一般address的格式为元组（hostname,port），如果连接出错，返回socket.error错误。
    s.connect_ex()：connect()函数的扩展版本,出错时返回出错码,而不是抛出异常
## 3.3. 公共用途的套接字函数
    s.recv()：接收TCP数据，数据以字符串形式返回，bufsize指定要接收的最大数据量。flag提供有关消息的其他信息，通常可以忽略。
    s.send()：发送TCP数据，将string中的数据发送到连接的套接字。返回值是要发送的字节数量，该数量可能小于string的字节大小。
    s.sendall()：完整发送TCP数据，完整发送TCP数据。将string中的数据发送到连接的套接字，但在返回之前会尝试发送所有数据。成功返回None，失败则抛出异常。
    s.recvfrom()：接收UDP数据，与recv()类似，但返回值是（data,address）。其中data是包含接收数据的字符串，address是发送数据的套接字地址。
    s.sendto()：发送UDP数据，将数据发送到套接字，address是形式为（ipaddr，port）的元组，指定远程地址。返回值是发送的字节数。
    s.close()：关闭套接字
    s.getpeername()：返回连接套接字的远程地址。返回值通常是元组（ipaddr,port）。
    s.getsockname()：返回套接字自己的地址。通常是一个元组(ipaddr,port)
    s.setsockopt(level,optname,value)：设置给定套接字选项的值。
    s.getsockopt(level,optname[.buflen])：返回套接字选项的值。
    s.settimeout(timeout)：设置套接字操作的超时期，timeout是一个浮点数，单位是秒。值为None表示没有超时期。一般，超时期应该在刚创建套接字时设置，因为它们可能用于连接的操作（如connect()）
    s.gettimeout()：返回当前超时期的值，单位是秒，如果没有设置超时期，则返回None。
    s.fileno()：返回套接字的文件描述符。
    s.setblocking(flag)：如果flag为0，则将套接字设为非阻塞模式，否则将套接字设为阻塞模式（默认值）。非阻塞模式下，如果调用recv()没有发现任何数据，或send()调用无法立即发送数据，那么将引起socket.error异常。
    s.makefile()：创建一个与该套接字相关连的文件

# 4. Python-socker简单实例
## 4.1. 简单服务端与客户端
### 4.1.1. 创建服务端
通过上面的方法，我们先来创建一个简单的客户端，这个服务端的功能就是不断的去接收连接，如果有客户端连接，就打印客户端的地址，如果客户端发送的有数据，就把数据打印出来

    # -*-coding:utf-8-*-
    import socket

    # 创建Socker对象
    pythonSocketServer = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 获取本机host
    host = socket.gethostname()

    # 设置端口
    port = 8099

    # 绑定服务器的地址和端口
    pythonSocketServer.bind((host, port))

    # 开启监听并设置最大连接数(最小值为1)
    pythonSocketServer.listen(10)

    # 不断的发送数据
    while True:
        # 建立客户端连接
        clientSocket, addr = pythonSocketServer.accept()
        if clientSocket is not None:
            print('Hello:', str(addr))
            # 接收数据
            msg = clientSocket.recv(1024)
            # 如果数据不为空，就打印出来
            if msg is not None:
                print(msg.decode('utf-8'))

            # 记得关闭连接
            clientSocket.close()

### 4.1.2. 创建客户端

客户端的功能是连接服务端，并且发送一段数据

    import socket

    clientSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 实际应用中的时候，需要把这个地址换为服务段的实际地址
    # ‘baldwin’是我服务端的映射名
    host = 'baldwin'
    port = 8099

    # 客户端建立连接
    clientSocket.connect((host, port))

    msg = 'Hello SocketServer!!!'

    clientSocket.send(msg.encode('utf-8'))

    clientSocket.close()

    print(msg)

### 4.1.3. 运行
**一定要先运行服务端再运行客户端**

    1.运行服务端，服务端开始接收连接
    2.运行客户端，连接成功并且发送数据

### 4.1.4. 结果

#### 客户端
    /usr/bin/python3.7 /home/baldwin/PycharmProjects/PyDemo/sockertest/client/PythonClient.py
    Hello SocketServer!!!

    Process finished with exit code 0
#### 服务端

    /usr/bin/python3.7 /home/baldwin/PycharmProjects/PyDemo/sockertest/server/PythonServer.py
    Hello: ('127.0.0.1', 43208)
    Hello SocketServer!!!
    Hello: ('127.0.0.1', 46372)
    Hello SocketServer!!!

我运行了两次客户端，所以这里显示了两条数据。

服务端并没有退出程序，仍然在等待连接。

## 4.2. Python-Socket与Java-Socket之间通讯
这里用Python提供服务端，Java提供客户端，Python客户端仍然使用上面那个。

### 4.2.1. Java-Socket客户端
相比于Python，写Java客户端我快要吐了

    package cn.yzstu;

    import java.io.IOException;
    import java.io.OutputStream;
    import java.io.PrintWriter;
    import java.net.Socket;

    /**
    * @author baldwin
    */
    public class Main {

        public static void main(String[] args) {

            try {
                // 创建客户端
                Socket socketClient = new Socket("baldwin",8099);
                //获取输出流，向服务器端发送信息
                //字节输出流
                OutputStream os = socketClient.getOutputStream();
                //将输出流包装成打印流
                PrintWriter pw =new PrintWriter(os);
                pw.write("Hello PythonSocket!!!");
                pw.flush();
                socketClient.shutdownOutput();
                //关闭资源
                pw.close();
                os.close();
                socketClient.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

### 4.2.2. 运行
**一定要先运行服务端再运行客户端**

    1.运行服务端，服务端开始接收连接
    2.运行客户端，连接成功并且发送数据

### 4.2.3. 结果
我们回到Python服务端看一下

    /usr/bin/python3.7 /home/baldwin/PycharmProjects/PyDemo/sockertest/server/PythonServer.py
    Hello: ('127.0.0.1', 32852)
    Hello PythonSocket!!!

自己看，不再累述。

# 5. Python中网络编程的重要模块

    协议	功能用处	端口号	Python 模块
    HTTP	网页访问	80	httplib, urllib, xmlrpclib
    NNTP	阅读和张贴新闻文章，俗称为"帖子"	119	nntplib
    FTP	文件传输	20	ftplib, urllib
    SMTP	发送邮件	25	smtplib
    POP3	接收邮件	110	poplib
    IMAP4	获取邮件	143	imaplib
    Telnet	命令行	23	telnetlib
    Gopher	信息查找	70	gopherlib, urllib

# 6. 总结

    1. 先运行服务端，再运行客户端
    2. 看起来Python的Socket操作比Java方便很多

**部分资料来自菜鸟教程**

往期好文：

[用Python每天给女神发一句手机短信情话](https://blog.csdn.net/shouchenchuan5253/article/details/105753596)

[MySQL优化之explain](https://blog.csdn.net/shouchenchuan5253/article/details/105722148)

[Spring源码分析-MVC初始化](https://blog.csdn.net/shouchenchuan5253/article/details/105625890)

[春风得意马蹄疾，一文看尽（JVM）虚拟机](https://yzstu.blog.csdn.net/article/details/105462458)

[造轮子的艺术](https://blog.csdn.net/shouchenchuan5253/article/details/105256723)

[源码阅读技巧](https://blog.csdn.net/shouchenchuan5253/article/details/105196154)

[Java注解详解](https://blog.csdn.net/shouchenchuan5253/article/details/105145725)

[教你自建SpringBoot服务器](https://blog.csdn.net/shouchenchuan5253/article/details/104773702)

[更多文章请点击](https://blog.csdn.net/shouchenchuan5253/article/details/105020803)

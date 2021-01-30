[更多Pythton学习系列内容请点击我](https://yzstu.blog.csdn.net/article/details/105020803)

*本文基于Python3.7*
# 1. 相关
什么是**异常**？异常就是“不正常”。
我们的程序的执行过程中发生了一个不正常的事件，这个事件影响了程序的正常运行，此时就是发生了程序异常。
与在Java中一样的，Python中的异常也是一个对象，当程序发生异常时，程序会抛出响应的异常对象，我们需要去捕获这个异常并解决他，防止异常导致程序停止。
```
这里是一段防爬虫文本，读者请忽略。
本文最先由Baldwin_Keepmind发表于CSDN，转载请注明出处。
作者博客地址：https://blog.csdn.net/shouchenchuan5253
```
# 2.Python异常
[Python官网异常描述](https://docs.python.org/3.7/library/exceptions.html#BaseException)
## 2.1. Python异常相关

官网对于Python内置异常的描述：

    In Python, all exceptions must be instances of a class that derives from BaseException. 
    In a try statement with an except clause that mentions a particular class, that clause also handles any exception classes derived from that class (but not exception classes from which it is derived).
    The built-in exception classes can be subclassed to define new exceptions; programmers are encouraged to derive new exceptions from the Exception class or one of its subclasses, and not from BaseException. 

    在Python内置异常中，所有的异常都应是BaseException的派生类。
    在一个try-except（类似java中的try-catch）代码块中，except后会声明一种异常，声明的这种异常能处理所有该异常的子类异常（但是不包括他的父类异常）。
    内部异常类可以被继承来定义新的异常类，并且建议程序员来通过继承Exception而不是BaseException来定义一个新的异常类。
短短三句话，说明了Python异常的定义、处理办法和自定义异常。我们下面也会从异常处理和自定义异常两方面来讲解。

## 2.2.Python内置异常结构
首先我们来看一下Python内置异常类的结构，可见**Exception其实也是BaseException的一个子类**，而Exception是常规异常的基类，我们的自定义异常将会继承这个类。

    BaseException  # 所有异常的基类
    +-- SystemExit  # 解释器请求退出
    +-- KeyboardInterrupt  # 用户中断执行(通常是输入^C)
    +-- GeneratorExit  # 生成器(generator)发生异常来通知退出
    +-- Exception  # 常规异常的基类
        +-- StopIteration  # 迭代器没有更多的值
        +-- StopAsyncIteration  # 必须通过异步迭代器对象的__anext__()方法引发以停止迭代
        +-- ArithmeticError  # 各种算术错误引发的内置异常的基类
        |    +-- FloatingPointError  # 浮点计算错误
        |    +-- OverflowError  # 数值运算结果太大无法表示
        |    +-- ZeroDivisionError  # 除(或取模)零 (所有数据类型)
        +-- AssertionError  # 当assert语句失败时引发
        +-- AttributeError  # 属性引用或赋值失败
        +-- BufferError  # 无法执行与缓冲区相关的操作时引发
        +-- EOFError  # 当input()函数在没有读取任何数据的情况下达到文件结束条件(EOF)时引发
        +-- ImportError  # 导入模块/对象失败
        |    +-- ModuleNotFoundError  # 无法找到模块或在在sys.modules中找到None
        +-- LookupError  # 映射或序列上使用的键或索引无效时引发的异常的基类
        |    +-- IndexError  # 序列中没有此索引(index)
        |    +-- KeyError  # 映射中没有这个键
        +-- MemoryError  # 内存溢出错误(对于Python 解释器不是致命的)
        +-- NameError  # 未声明/初始化对象 (没有属性)
        |    +-- UnboundLocalError  # 访问未初始化的本地变量
        +-- OSError  # 操作系统错误，EnvironmentError，IOError，WindowsError，socket.error，select.error和mmap.error已合并到OSError中，构造函数可能返回子类
        |    +-- BlockingIOError  # 操作将阻塞对象(e.g. socket)设置为非阻塞操作
        |    +-- ChildProcessError  # 在子进程上的操作失败
        |    +-- ConnectionError  # 与连接相关的异常的基类
        |    |    +-- BrokenPipeError  # 另一端关闭时尝试写入管道或试图在已关闭写入的套接字上写入
        |    |    +-- ConnectionAbortedError  # 连接尝试被对等方中止
        |    |    +-- ConnectionRefusedError  # 连接尝试被对等方拒绝
        |    |    +-- ConnectionResetError    # 连接由对等方重置
        |    +-- FileExistsError  # 创建已存在的文件或目录
        |    +-- FileNotFoundError  # 请求不存在的文件或目录
        |    +-- InterruptedError  # 系统调用被输入信号中断
        |    +-- IsADirectoryError  # 在目录上请求文件操作(例如 os.remove())
        |    +-- NotADirectoryError  # 在不是目录的事物上请求目录操作(例如 os.listdir())
        |    +-- PermissionError  # 尝试在没有足够访问权限的情况下运行操作
        |    +-- ProcessLookupError  # 给定进程不存在
        |    +-- TimeoutError  # 系统函数在系统级别超时
        +-- ReferenceError  # weakref.proxy()函数创建的弱引用试图访问已经垃圾回收了的对象
        +-- RuntimeError  # 在检测到不属于任何其他类别的错误时触发
        |    +-- NotImplementedError  # 在用户定义的基类中，抽象方法要求派生类重写该方法或者正在开发的类指示仍然需要添加实际实现
        |    +-- RecursionError  # 解释器检测到超出最大递归深度
        +-- SyntaxError  # Python 语法错误
        |    +-- IndentationError  # 缩进错误
        |         +-- TabError  # Tab和空格混用
        +-- SystemError  # 解释器发现内部错误
        +-- TypeError  # 操作或函数应用于不适当类型的对象
        +-- ValueError  # 操作或函数接收到具有正确类型但值不合适的参数
        |    +-- UnicodeError  # 发生与Unicode相关的编码或解码错误
        |         +-- UnicodeDecodeError  # Unicode解码错误
        |         +-- UnicodeEncodeError  # Unicode编码错误
        |         +-- UnicodeTranslateError  # Unicode转码错误
        +-- Warning  # 警告的基类
            +-- DeprecationWarning  # 有关已弃用功能的警告的基类
            +-- PendingDeprecationWarning  # 有关不推荐使用功能的警告的基类
            +-- RuntimeWarning  # 有关可疑的运行时行为的警告的基类
            +-- SyntaxWarning  # 关于可疑语法警告的基类
            +-- UserWarning  # 用户代码生成警告的基类
            +-- FutureWarning  # 有关已弃用功能的警告的基类
            +-- ImportWarning  # 关于模块导入时可能出错的警告的基类
            +-- UnicodeWarning  # 与Unicode相关的警告的基类
            +-- BytesWarning  # 与bytes和bytearray相关的警告的基类
            +-- ResourceWarning  # 与资源使用相关的警告的基类。被默认警告过滤器忽略。

```
这里是一段防爬虫文本，读者请忽略。
本文最先由Baldwin_Keepmind发表于CSDN，转载请注明出处。
作者博客地址：https://blog.csdn.net/shouchenchuan5253
```
# 3. Python处理异常
在前面我们已经说过了要用try-except来处理异常，这里我们就来对比一下处理与不处理异常的不同之处。
## 3.1.不处理异常的程序
**运行以下代码**

    i = 1
    m = 0

    while i < 10:
        print("i=",i)
        print(i / m)
        i += 1
**结果输出**

    /root/PycharmProjects/PyDemo/venv/bin/python /root/PycharmProjects/PyDemo/exception/__init__.py
    i= 1
    Traceback (most recent call last):
    File "/root/PycharmProjects/PyDemo/exception/__init__.py", line 6, in <module>
        print(i / m)
    ZeroDivisionError: division by zero

    Process finished with exit code 1
结果显示，我们的控制台直接输出异常并且中断了程序，这种情况在程序运行时是非常糟糕的，他导致我们之后的代码都无法运行。
## 3.2. 处理异常的程序
**运行以下代码**

    i = 1
    m = 0

    while i < 3:
        print("i=", i)
        try:
            print(i / m)
        except ZeroDivisionError:
            print("除数不能为0")
        i += 1

**结果输出**

    /root/PycharmProjects/PyDemo/venv/bin/python /root/PycharmProjects/PyDemo/exception/__init__.py
    i= 1
    除数不能为0
    i= 2
    除数不能为0

    Process finished with exit code 0
这里我们用try-except将可能发生异常的代码包围起来，在运行的时候虽然发生了异常，但是我们有处理异常的代码，而且程序能够继续运行，这在程序设计中是非常重要的。
## 3.3. 异常处理扩展
除了最基本的try-except代码块来处理异常之外，Python也提供了更多的更能，如else、finally等
### 3.3.1. else的用法
else与except是同等级的，主要是**处理没有捕获到异常的情况**。

**else使用通式**

    try:
        正常的操作
    ......................
    except:
        发生异常，执行这块代码
    ......................
    else:
        如果没有异常执行这块代码

**代码**
    i = 10
    m = 0

    while m < 3:
        print("i=", i)
        try:
            print(i / m)
        except ZeroDivisionError:
            print("除数不能为0")
        else:
            print("运算正常，未捕获到异常")
        m += 1
**运行结果**

    /root/PycharmProjects/PyDemo/venv/bin/python /root/PycharmProjects/PyDemo/exception/__init__.py
    i= 10
    除数不能为0
    i= 10
    10.0
    运算正常，未捕获到异常
    i= 10
    5.0
    运算正常，未捕获到异常

    Process finished with exit code 0

在这段代码中，当没有捕获到异常时就执行else下的代码，捕获到异常时执行except下的代码。
### 3.3.2 finally的用法

**finally下的代码，无论异常是否发生都会执行**

**finally使用通式**

    try:
        正常的操作
    ......................
    except:
        发生异常，执行这块代码
    ......................
    else:
        如果没有异常执行这块代码
    finally:
        退出try时总会执行

**代码**

    i = 10
    m = 0

    while m < 3:
        print("i=", i)
        try:
            print(i / m)
        except ZeroDivisionError:
            print("除数不能为0")
        else:
            print("运算正常，未捕获到异常")
        finally:
            print("第", m + 1, "次循环")
            m += 1

**结果**

    /root/PycharmProjects/PyDemo/venv/bin/python /root/PycharmProjects/PyDemo/exception/__init__.py
    i= 10
    除数不能为0
    第 1 次循环
    i= 10
    10.0
    运算正常，未捕获到异常
    第 2 次循环
    i= 10
    5.0
    运算正常，未捕获到异常
    第 3 次循环

    Process finished with exit code 0
从结果中我们即可看出，无论是捕获到异常时执行except下代码，还是未捕获到异常执行else下代码时，finally下的代码都被执行了。
finally的在实际应用中是很重要的，比如我们在操作数据库的时候，无论你的操作是否成功，关闭数据库连接都是必须的，这个时候就可以把关闭连接的程序放在finally下，确保操作结束后，数据库连接被关闭。
## 3.4. try执行原理
当开始一个try语句后，python就在当前程序的上下文中作标记，这样当异常出现时就可以回到这里，try子句先执行，接下来会发生什么依赖于执行时是否出现异常。

    如果当try后的语句执行时发生异常，python就跳回到try并执行第一个匹配该异常的except子句，异常处理完毕，控制流就通过整个try语句（除非在处理异常时又引发新的异常）。
    如果在try后的语句里发生了异常，却没有匹配的except子句，异常将被递交到上层的try，或者到程序的最上层（这样将结束程序，并打印默认的出错信息）。
    如果在try子句执行时没有发生异常，python将执行else语句后的语句（如果有else的话），然后控制流通过整个try语句。 
    如果最后设置有finally操作，那么最后执行finally下的程序。

```
这里是一段防爬虫文本，读者请忽略。
本文最先由Baldwin_Keepmind发表于CSDN，转载请注明出处。
作者博客地址：https://blog.csdn.net/shouchenchuan5253
```
# 4. 主动抛出异常
在编程过程中，有时候虽然代码没有异常，但是因为设计中有要求，我们也可以主动抛出异常，类似Java中的**throw**，Python中用**raise**来主动抛出异常，我们自定义的异常往往需要主动抛出。
**raise使用通式**

    raise [Exception [, args [, traceback]]]

**代码**

    i = 10
    m = 0


    def calculate(q, p):
        if m == 0:
            raise Exception("m不能等于0哦")
        print(q / p)


    while m < 3:
        try:
            calculate(i, m)
        except Exception as e:
            print(e)
        m += 1

**结果**

    /root/PycharmProjects/PyDemo/venv/bin/python /root/PycharmProjects/PyDemo/exception/__init__.py
    m不能等于0哦
    10.0
    5.0

    Process finished with exit code 0

在代码中，我们规定：当除数等于0的时候要抛出一个异常，异常信息是“m不能等于0哦”，然后在执行的时候，如果捕获到异常就把异常信息打印出来。
```
这里是一段防爬虫文本，读者请忽略。
本文最先由Baldwin_Keepmind发表于CSDN，转载请注明出处。
作者博客地址：https://blog.csdn.net/shouchenchuan5253
```
# 5.Python自定义异常
[Python官网自定义异常描述](https://docs.python.org/3.7/tutorial/errors.html#tut-userexceptions)

    Programs may name their own exceptions by creating a new exception class (see Classes for more about Python classes). Exceptions should typically be derived from the Exception class, either directly or indirectly.
    程序员可以通过创建新的异常类来命名它们自己的异常。异常通常应该直接或间接地从 Exception 类派生。
    
OK，通过官方的文档，我们可以清楚地看出来自定义异常的方法：继承Exception，那么下面我们就来自己定义一个异常。

**自定义异常类**

**自定义异常异常应该是典型的继承自Exception类，通过直接或间接的方式。**

一下是直接通过Exception类创建了一个自定义异常，

    class CantBeZero(Exception):
        def __init__(self, err="自定义异常提醒您，除数不能为0哦！！！"):
            Exception.__init__(self, err)

**代码**
在try语句块中，用户自定义的异常后执行except块语句，变量 e 是用于创建CantBeZero类的实例。

    i = 10
    m = 0


    def calculate(q, p):
        if m == 0:
            raise CantBeZero
        print(q / p)


    while m < 3:
        try:
            calculate(i, m)
        except CantBeZero as e:
            print(e)
        m += 1

**结果**

    /root/PycharmProjects/PyDemo/venv/bin/python /root/PycharmProjects/PyDemo/exception/__init__.py
    自定义异常提醒您，除数不能为0哦！！！
    10.0
    5.0

    Process finished with exit code 0

我们在除数等于0的时候直接抛出了异常，并且被程序捕获到，然后执行了except下的程序。
```
这里是一段防爬虫文本，读者请忽略。
本文最先由Baldwin_Keepmind发表于CSDN，转载请注明出处。
作者博客地址：https://blog.csdn.net/shouchenchuan5253
```
# 6. 总结
异常处理用于处理程序错误之外，还有许多应用的地方。如关闭资源、平台兼容、模块导入等，异常的捕获与处理在程序设计中是非常重要的，我们在前面已经提到，未被捕获处理的异常可能会直接导致程序的停止，这对于生产来说是毁灭性的打击。

我是Baldwin，一个25岁的程序员，致力于让学习变得更有趣，如果你也真正喜爱编程，真诚的希望与你交个朋友，一起在编程的海洋里徜徉！

往期好文：

[春风得意马蹄疾，一文看尽（JVM）虚拟机](https://yzstu.blog.csdn.net/article/details/105462458)

[造轮子的艺术](https://blog.csdn.net/shouchenchuan5253/article/details/105256723)

[源码阅读技巧](https://blog.csdn.net/shouchenchuan5253/article/details/105196154)

[Java注解详解](https://blog.csdn.net/shouchenchuan5253/article/details/105145725)

[教你自建SpringBoot服务器](https://blog.csdn.net/shouchenchuan5253/article/details/104773702)

[更多文章请点击](https://blog.csdn.net/shouchenchuan5253/article/details/105020803)

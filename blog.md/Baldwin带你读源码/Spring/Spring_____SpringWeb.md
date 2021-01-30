# 1.前言
致敬！

谨以此文献给迷茫中的你和我

此文基于Spring-4.3.18、JDK8、Idea、Maven3

此文内容适合于刚出大学的实习生、对源码不甚解的程序员、有心阅读源码的初学者等阅读。

如果您在阅读源码方面没有基础，非常推荐您先阅读我的另一篇文章:[你背了几道面试题就敢说熟悉Java源码？对不起，我们不招连源码都不会看的人](https://blog.csdn.net/shouchenchuan5253/article/details/105196154)

如果您找不到源码资源，请先观看另一篇文章：[快找到源码资源](https://yzstu.blog.csdn.net/article/details/105608283)

作者==萌新，如有错误欢迎指正。
**若您在阅读本系列文章后仍对源码感到迷茫，请您联系作者，作者将退还订阅所得费用**

# 2. 需要了解
为了方便理解正文内容，我需要你明白几个概念
## 2.1. Servlet规范
作为Java程序员，你都已经接触到Spring了，我这里就默认你了解过Servlet，但是有些内容我必须确保你是知道的，比如Servlet规范。

在Servlet规范中，我们有web容器的概念（支持Web应用运行的容器，如tomcat），每一个在容器中运行的Web应用都有一个ServletContext（我们也可以理解成一个ServletContext代表一个Web应用），在一个容器中往往会存在多个ServletContext（Tomcat中运行多个Web应用）。在Web容器启动时，会进行初始化，初始化的时候会为每一个Web应用创建一个ServletContext，加载web应用中的web.xml，获取web.xml中的配置的Filters，Listener，Servlet等组件的配置并创建对象实例，并将这些实例作为ServletContext的属性保存在其中。项目启动后，当web应用收到客户端请求的时候，先使用应用配置的Fileters进行过滤，然后再交给Servlet区处理这些请求。

## 2.2. Listener监听器机制:ContextLoaderListener
servlet规范当中，使用了Listener监听器机制来**进行web容器相关组件的生命周期管理以及Event事件监听器来实现组件之间的交互**。

我们在这里说一下ServletContextListener监听器。web容器在创建和初始化ServletContext的时候会伴随产生一个一个ServletContextEvent事件。

**ServletContextEvent**

    package javax.servlet;


        /** 
        * 这是一个事件类，用来通知web Context的改变
        * @see ServletContextListener
        * @since	v 2.3
        */

    public class ServletContextEvent extends java.util.EventObject { 

        /** 构造函数
        *
        * @param source - the ServletContext that is sending the event.
        */
        public ServletContextEvent(ServletContext source) {
        super(source);
        }
        
        /**
        * Return the ServletContext that changed.
        *
        * @return the ServletContext that sent the event.
        */
        public ServletContext getServletContext () { 
        return (ServletContext) super.getSource();
        }
        
    }

ServletContextEvent一个最重要的作用就是带了ServletContext，然后Event作为参数传入web.xml中所配置的监听器。

**ServletContextListener**

所有的容器初始化监听器都必须要直接或间接的实现ServletContextListener接口，它里面规定了监听器所要具备的功能。

    /**
    * Implementations of this interface receive notifications about changes to the
    * servlet context of the web application they are part of. To receive
    * notification events, the implementation class must be configured in the
    * deployment descriptor for the web application.
    *
    * @see ServletContextEvent
    * @since v 2.3
    */
    public interface ServletContextListener extends EventListener {

        /**
        ** 这个容器正在初始化的通知.
        * 所有的ServletContextListeners在Filter和Servlet之前会被通知到Context的初始化。在这个时候容器是不能处理请求的，所以可以在这个时候去加载我们的组件，spring相关的bean就是这里所说的底层处理请求的组件，如数据库连接池，数据库事务管理器等。
        * @param sce Information about the ServletContext that was initialized
        */
        public void contextInitialized(ServletContextEvent sce);

        /**
        ** Notification that the servlet context is about to be shut down. All
        * servlets and filters have been destroy()ed before any
        * ServletContextListeners are notified of context destruction.
        * @param sce Information about the ServletContext that was destroyed
        */
        public void contextDestroyed(ServletContextEvent sce);
    }

**ContextLoaderListener**

这是Spring-Web中的一个ServletContextListener实现类，

# 2.开始

<div align=center><img src ="./image/spring.png"/></div> 

我知道你订阅这篇文章的时候，对于Spring是无从下手，那么现在最重要的事情就是告诉你：**从哪里开始阅读Spring**，如果你对于Spring有一定了解，那么你一定知道，Spring是一个IOC容器或者说是一个bean的容器，那么你可能自己会从Spring-bean开始阅读，但是现在要说的是，这个想法是错误的，因为程序咋运行的时候，其实不是从Spring-bean开始的，如果你从这里开始阅读，毫无疑问，你会一头雾水，然后放弃。

那么我们应该从哪里开始呢？

对于源码阅读，我已开始的建议就是，**跟着程序运行的步骤一步步阅读**。

## 2.1 寻找入口
我们在前面讲到过Servlet规范，我们的Spring应用其实就是个web应用，最明显的就是，在搭建Spring应用时也需要去进行web.xml配置，我们现在来看一下一个已经配置好的web.xml文件。

    <?xml version="1.0" encoding="UTF-8"?>
    <web-app id="WebApp_ID" version="3.0"
            xmlns="http://java.sun.com/xml/ns/javaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd">

        <context-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:applicationContext.xml</param-value>
        </context-param>
        <listener>
            <listener-class>org.springframework.web.util.IntrospectorCleanupListener</listener-class>
        </listener>

        <listener>
            <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
        </listener>

        <!--当前台JSP页面和JAVA代码中使用了不同的字符集进行编码的时，进行 utf-8编码 -->
        <filter>
            <filter-name>CharacterEncodingFilter</filter-name>
            <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
            <init-param>
                <param-name>encoding</param-name>
                <param-value>UTF-8</param-value>
            </init-param>
            <init-param>
                <param-name>forceEncoding</param-name>
                <param-value>true</param-value>
            </init-param>
        </filter>
        <filter-mapping>
            <filter-name>CharacterEncodingFilter</filter-name>
            <url-pattern>/*</url-pattern>
        </filter-mapping>

        <filter>
            <description>登录验证</description>
            <filter-name>LoginFilter</filter-name>
            <filter-class>payment.server.controller.sys.LoginFilter</filter-class>
            <init-param>
                <param-name>ignoreUrl</param-name>
                <param-value>/sys/login.action;/sys/dologin.action;/sys/login_dialog.action;/login_dialog.jsp</param-value>
            </init-param>
        </filter>
        <filter-mapping>
            <filter-name>LoginFilter</filter-name>
            <url-pattern>/sys/*</url-pattern>
            <url-pattern>/pages/*</url-pattern>
            <url-pattern>/index.jsp</url-pattern>
            <dispatcher>REQUEST</dispatcher>
        </filter-mapping>


        <servlet>
            <servlet-name>dispatchServlet</servlet-name>
            <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
            <init-param>
                <param-name>contextConfigLocation</param-name>
                <param-value>classpath:spring-mvc.xml</param-value>
            </init-param>
            <load-on-startup>1</load-on-startup>
        </servlet>
        <servlet-mapping>
            <servlet-name>dispatchServlet</servlet-name>
            <url-pattern>*.action</url-pattern>
        </servlet-mapping>

        <servlet>
            <servlet-name>verifyCodeServlet</servlet-name>
            <servlet-class>payment.server.service.VerifyCodeServlet</servlet-class>
            <load-on-startup>2</load-on-startup>
        </servlet>
        <servlet-mapping>
            <servlet-name>verifyCodeServlet</servlet-name>
            <url-pattern>/verify_code.jpg</url-pattern>
        </servlet-mapping>
    </web-app>
在这个web.xml中配置了1个context-param、4个filter和2个servlet，
title: JS时间操作
date: 2015/09/19
layout: post
tags: note
---
做一下时间操作相关的笔记，方便以后查找。
## JS获取当前时间戳 ##

### 第一种方法 ###
```
var timestamp = Date.parse(new Date());
结果：1280977330000
```
<!--more-->
### 第二种方法 ###

```
var timestamp = (new Date()).valueOf();
结果：1280977330748
```

### 第三种方法 ###

```
var timestamp=new Date().getTime()；
结果：1280977330748
```


第一种：获取的时间戳是把毫秒改成000显示，

第二种和第三种是获取了当前毫秒的时间戳。

## 时间相关操作 ##

```javascript
var myDate = new Date();
myDate.getYear();        //获取当前年份(2位)
myDate.getFullYear();    //获取完整的年份(4位,1970-????)
myDate.getMonth();       //获取当前月份(0-11,0代表1月)
myDate.getDate();        //获取当前日(1-31)
myDate.getDay();         //获取当前星期X(0-6,0代表星期天)
myDate.getTime();        //获取当前时间(从1970.1.1开始的毫秒数)
myDate.getHours();       //获取当前小时数(0-23)
myDate.getMinutes();     //获取当前分钟数(0-59)
myDate.getSeconds();     //获取当前秒数(0-59)
myDate.getMilliseconds();    //获取当前毫秒数(0-999)
myDate.toLocaleDateString();     //获取当前日期
var mytime=myDate.toLocaleTimeString();     //获取当前时间
myDate.toLocaleString( );        //获取日期与时间
```



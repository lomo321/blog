title: JS字符串与数组操作
layout: post
date: 2015/09/23
tags: note
---

话说这些真是看一遍忘一遍啊，归根到底还是用得少。做一下笔记，免得下次用又去找资料了。

[字符串基本操作:](#字符串基本操作)
* [split](#split)、
* [slice/substring](#slice/substring)、
* [substr](#substr)、
* [concat](#concat)、
* [indexOf/lastIndexOf](#indexOf/lastIndexOf)、
* [charAt/charCodeAt](#charAt/charCodeAt)、
* [search/match/replace](#search/match/replace )、
* [toLowerCase/toUpperCase](#toLowerCase/toUpperCase)

[字符串操作实用函数:](#字符串操作实用函数)
* [trim](#trim)、
* [计算字符串长度](#计算字符串长度)

[数组基本操作:](#数组基本操作)
* [join](#join)、
* [reverse/sort](#reverse/sort)、
* [slice](#slice)、
* [splice](#splice)、
* [concat](#concat)

<!--more-->
## 字符串基本操作##

### split ###

感觉`split`是我用得最多的一个api。可以将字符串以输入的参数字符分隔，然后返回一个数组。

```javascript
"abcd".split()
//["abcd"]

"abcd".split("")
//["a", "b", "c", "d"]

"abcd".split("b")
//["a","cd"]
```

### slice/substring ###
截取字符串。接受两个参数，第一个是起始位位置，第二个是结束位+1。两者区别在于传入负值参数的时候，`slice`是会从末尾开始数，`substring`则不会。

```javascript
"abcdef".slice()
//"abcdef"

"abcdef".slice(1)
//"bcdef"

"abcdef".slice(1,3)
//"bc"

//以上操作 substring具有相同结果

"abcdef".slice(-1)
//"f"
"abcde".substring(-1)
//"abcde"

"abcdef".slice(1,-1)
//"bcde"
"abcde".substring(1,-1)
//"a"
```

### substr ###
返回字符串的一个子串，传入参数是起始位置和长度

```javascript
"abcde".substr(1,2)
//"bc"

"abcde".substr(1)
//"bcde"

"abcde".substr(1,10)
//"bcde"

"abcde".substr(1,-1)
//""

"abcde".substr(1,0)
//""

"abcde".substr(-1,3)
//"e"

"abcde".substr(-2,3)
//"de"
```



### concat ###
拼接字符串。

```javascript
"abc".concat("def")
//"abcdef"
```

### indexOf/lastIndexOf ###
返回一个字符在字符串中第一次出现的索引。

```javascript
"ababa".indexOf("a")
//0

"ababa".lastIndexOf("a")
//4
```

### charAt/charCodeAt###
返回索引处的字符 / unicode编码

```javascript
"abcde".charAt("2")
//"c"

"abcde".charAt()
//"a"

"abcde".charCodeAt(2)
//99
```

### search/match/replace
这三个都涉及到正则表达式，所以放在一起讨论。`search`返回第一次匹配的索引值,`replace`找到匹配的位置并替换,`match`则以数组形式返回匹配的字串。

```javascript
"abcdef".search(/ab/)
//0
"abcdef".search(/cd/)
//2
"abcdef".search(/ba/)
//-1
"abababcdef".search(/ab/)
//0

"abababcdef".replace(/ab/,"hh")
//"hhababcdef"

"abababcdef".replace(/ab/g,"hh")
//"hhhhhhcdef"

"abababcdef".match(/ab/)
//["ab"]

"abababcdef".match(/ab/g)
//["ab", "ab", "ab"]
```
### toLowerCase/toUpperCase ###

```javascript
"abababcdef".toUpperCase()
//"ABABABCDEF"
```

## 字符串操作实用函数 ##

### trim ###
去除字符串前后的空格

```javascript
String.prototype.Trim = function(){
	return this.replace(/(^\s*)|(\s*$)/g, "");
}
```

### 计算字符串长度 ###

```javascript
String.prototype.LengthW = function(){
	return this.replace(/[^\x00-\xff]/g,"**").length;
}

"abc".LengthW()
//3

"bcd哈哈哈".LengthW()
//9

//ascii编码不在\x00-\xff范围内，即超出了一个字节。
```

## 数组基本操作 ##


### join ###
返回字符串，这个字符串将数组的每一个元素值连接在一起，用参数连接

```javascript
["abc",{}].join('k')
//"abck[object Object]"

["abc","dd"].join('k')
//"abckdd"
```

### reverse/sort ###
前者将数组反转，返回新数组指针
```javascript
["abc","dd"].reverse()
//["dd", "abc"]

var a = ["abc","dd"];
a.reverse();
a;
//["dd", "abc"]
```

### slice ###
参数为start与end，返回一个新数组，原数组不变

```javascript
var a = ["abc","dd","cc","gh"];
a.slice(1)
//["dd", "cc", "gh"]

a.slice(1,2)
//["dd"]

a.slice(1,3)
//["dd", "cc"]

a.slice(1,-1)
//["dd", "cc"]

a;
//["abc", "dd", "cc", "gh"]
```

### splice ###
原数组会发生改变

1. 删除-用于删除元素，两个参数，第一个参数（要删除第一项的位置），第二个参数（要删除的项数）
2. 插入-向数组指定位置插入任意项元素。三个参数，第一个参数（其实位置），第二个参数（0），第三个参数（插入的项）
3. 替换-向数组指定位置插入任意项元素，同时删除任意数量的项，三个参数。第一个参数（起始位置），第二个参数（删除的项数），第三个参数（插入任意数量的项）
```javascript
var lang = ["php","java","javascript"];
//删除
var removed = lang.splice(1,1);
lang //["php","javascript" ]
removed; //["java"] ,返回删除的项
//插入
var insert = lang.splice(0,0,"asp"); //从第0个位置开始插入
insert; //返回空数组
lang; //["asp","php","javascript"]
//替换
var replace = lang.splice(1,1,"c#","ruby"); //删除一项，插入两项
lang; //["asp","c#","ruby"]
replace; //["php"]
```

### concat ###
拼接数组，返回新数组，原数组不变

```javascript
var a = ["abc","dd","cc","gh"];
var b = ["abc"];
var c = "jj";
var d = {};
a.concat(b,c,d);
//["abc", "dd", "cc", "gh", "abc", "jj", {}]

a;
//["abc", "dd", "cc", "gh"]
```
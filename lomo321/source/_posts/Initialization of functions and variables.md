title: 函数与变量的初始化
date: 2015/09/16
tags: JS
layout: post
---
原文链接：[Initialization of functions and variables](http://javascript.info/tutorial/initialization)

[顶层变量实例化](#顶层变量实例化)
[函数里的变量](#函数里的变量)
[区块没有作用域](#区块没有作用域)

在JS里，变量和函数的机制和别的大部分语言有很大区别。首先必须要了解它是如何运作的。

>JS中，所有的局部变量和函数都是一个特殊内部对象的属性，这个特殊的对象是LexicalEnvironment。

对于浏览器而言，顶层的LexicalEnvironment就是window。它也被称作全局对象。

<!--more-->

## 顶层变量实例化##

在代码将要被执行前，会有一个预处理阶段，称之为`变量实例化`。

1. 首先，编译器会读取代码中以`function name{...}`这种形式的函数声明。每一次声明，都会创建一个函数放到`window`对象里。

	以下的代码作为例子。

	```javascript
var a = 5;
function f(arg) {
	alert('f:'+arg)
	}
var g = function(arg) {
	alert('g:'+arg)
}
```
	在这个阶段，浏览器找到`function f`，并创建它将它保存为`window.f`:

	```javascript
	// 1. 函数会在代码执行前被声明。
	//	因此，代码执行之前就有 window = {f:function}
	var a = 5

	function f(arg) { alert('f:'+arg) } // FunctionDeclaration

	var g = function(arg) { alert('g:'+arg) }
	```
	这会产生一个副作用，`f`可以在声明前被调用

	```
	f();
	function f() {alert('ok')}
	```
2. 接着，编译器会扫查`var`声明并且创建为window的属性。但在这个阶段并不会赋值，所有变量都是`undefined`.

	```javascript
	// 1. 函数会在代码执行前被声明。
	//	因此，代码执行之前就有 window = {f:function}
	// 2. 变量名会添加为window的属性
	// window = {f:function, a:undefined,g:undefined}
	var a = 5 //var

	function f(arg) { alert('f:'+arg) } // FunctionDeclaration

	var g = function(arg) { alert('g:'+arg) } //var
	```
	`g`是的函数表达式，解析器并不会理会。它只会创建变量但不会赋值给它们。

	小结：
	>1. 函数声明使函数可以随时执行。
	>2. 变量初始化时都是undefined。
	>3. 代码执行时才会赋值。

3. 然后，代码开始执行。
	到一个变量或函数被调用时，解析器会将它从window对象里取出：

	```
	alert("a" in window) // true, because window.a exists
	alert(a) // undefined, because assignment happens below
	alert(f) // function, because it is Function Declaration
	alert(g) // undefined, because assignment happens below

	var a = 5;

	function f() {}
	var g = function {}
	```

4. 赋值之后，`a`的值为`5`,`g`指向一个函数。以下代码，`alerts`移到后面，注意差异

	```
	var a = 5;
	var g = function() {}

	alert(a) // 5
	alert(g) // function
	```

	假如变量没有以`var`方式声明，它就不会在初始化阶段被声明。解析器会忽视它。

	```
	alert("b" in window) // false, there is no window.b
	alert(b) // error, b is not defined

	b = 5
	```

	但假如先赋值，`b`会成为window的属性。

	```
	b = 5
	alert("b" in window) // true, there is window.b = 5
	```

## 函数里的变量 ##

函数被调用时，一个新的`LexicalEnvironment`会被创建,它里面包含了参数，变量，和匿名函数声明。

这个对象里的变量只能在内部操作（读/写）。与`window`不同的地方是，函数内部的`LexicalEnvironment`并不能直接从外部访问。

```
function sayHi(name) {
  var phrase = "Hi, " + name
  alert(phrase)
}

sayHi('John')
```

 1. 当解析器准备好开始执行函数的代码，第一行代码开始执行之前，`LexicalEnvironment`会被创建，里面包含了参数，局部变量和匿名函数。

 	```
function sayHi(name) {
// LexicalEnvironment = { name: 'John', phrase: undefined }
  var phrase = "Hi, " + name
  alert(phrase)
}

	sayHi('John')
 	```

 2. 然后代码开始执行，最后会执行赋值。
 	 变量的赋值意味着`LexicalEnvironment`里对应的属性会获得一个新的值。
 	 所以，`phrase = "Hi, "+name`改变了`LexicalEnvironment`:

 	 ```
function sayHi(name) {
// LexicalEnvironment = { name: 'John', phrase: undefined }
  var phrase = "Hi, " + name
// LexicalEnvironment = { name: 'John', phrase: 'Hi, John'}
  alert(phrase)
}

	sayHi('John')
 	 ```

 3. 执行到最后，`LexicalEnvironment`通常会释放没有被使用的变量。但实际情况并不是一定是这样的
 	>### Specification peculiarities ###

 	>If we look into the recent ECMA-262 specification, there are actually two objects.

	>The first is a VariableEnvironment object, which is actually populated by variables and functions, declared by FunctionDeclaration, and then becomes immutable.

	>The second is a LexicalEnvironment object, which is almost same as VariableEnvironment, but it is actually used during the execution.

	>A more formal description can be found in the ECMA-262 standard, sections 10.2-10.5 and 13.

	>It is also noted that in JavaScript implementations, these two objects can be merged into one. So, we evade irrelevant details and use the term LexicalEnvironment everywhere.


## 区块没有作用域 ##

以下两段代码是没有区别的

```
var i = 1;
{
	i = 5;
}
```

```
 i = 1;
{
	var i = 5;
}
```

两个例子中所有`var`声明都在代码执行前进行。

```
for(var i = 0; i<5; i++) {}

alert(i) // 5, variable survives and keeps value
```
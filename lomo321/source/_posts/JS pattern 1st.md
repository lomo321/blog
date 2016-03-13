title: JS模式：对象
layout: post
date: 2015/09/20
tags: JS
---
最近在看JS设计模式，顺便回顾一下基础知识，做一下归纳总结。


[1 理解对象](#理解对象)
* [1.1数据属性](#数据属性)
* [1.2访问器属性](#访问器属性)
* [1.3定义属性](#定义属性)
* [1.4读取属性](#读取属性)

[2 创建对象](#创建对象)
* [2.1构造函数模式](#构造函数模式)
* [2.2原型模式](#原型模式)
* [2.3其他对象创建模式](#其他对象创建模式)

[3 更高级的玩法](#更高级的玩法)

<!--more-->

## 理解对象 ##

理解对象，并不是教你怎样体谅你的男/女朋友。看完这篇文章你对JS的对象的理解会更深入，然而你自己的对象依旧会责怪你不体谅，解决这个问题最直接的办法，就是反问一句`为什么你也不体谅一下我？`

ECMA-262把对象定义为`无序属性的集合，其属性可以包含基本值、对象或函数`。我们可以将对象想象成散列表：名值对，值可以是数据或函数。

JS的对象有2种属性：`数据属性`和`访问器属性`。


### 数据属性###

数据属性有4个特征：

*  [[Configurable]]：能否delete，能否修改属性的特征，能否将数据属性改为访问器属性。默认为true
*  [[Enumerable]]：能否通过for-in循环，默认为true。
*  [[Writable]]：可否修改属性的值，默认为true。
*  [[Value]]：包含了数据属性的数据值，从这里读写。默认为undefined。

### 访问器属性 ###

访问器属性不包含数据值，包含了一对`get`,`set`函数。

访问器属性同样有4个特征：

* [[Configurable]]：同上。
* [[Enumerable]]：同上。
* [[Get]]：读取属性时调用的函数。默认为undefined。
* [[Set]]：写入属性时调用的函数。默认为undefined。

### 定义属性 ###
以上两种属性，都可以使用`Object.defineProperty()`这个方法定义。

```javascript
var person = {};

Object.defineProperty(person, "name", {
	writable: false,
	value: "Lomo"
})
person.name;//"Lomo"

Object.defineProperty(person,"weight", {
	get: function(){
		return "120kg";
	}
	set: function(newValue) {
		if(newValue < 110) {
			this.age = 18;
		}
	}
})
person.weight //"120kg"
person.age //"undefined"
person.weight = 105;
person.weight //"120kg"
person.age //18
```

我们也可以使用`Object.defineProperties`定义多个属性。

```javascript
Object.defineProperties(objectName, {
	propertyName:{
		attribute: xxx,
		//...
	}
})
```

### 读取属性 ###

可以使用`Object.getOwnPropertyDescriptor(objectName, "propertyName")`方法获取属性的特征。该方法返回一个对象。


## 创建对象 ##
### 构造函数模式 ###

使用对象字面量，可以用于创建单个对象。假如要创建多个具有相同属性的对象实例，可以使用构造函数。

```javascript
function Person(name) {
	this.name = name;
}
var person1 = new Person("Lomo");
var person2 = new Person("mo");
```
要创建`Person`实例，必须使用new操作符。构造函数被调用时实际上经历了以下4个步骤：

1. 创建一个新对象
2. 将构造函数的作用域赋给新对象（this也指向了这个对象）
3. 执行构造函数中的代码
4. 返回新对象

使用`new`操作符创建对象时，构造函数总是返回一个对象。默认情况下返回的是this所引用的对象。但是，可以根据需要返回其他任意对象。

```javascript
var Oj = function() {
	this.name = "this is it";
	var that = {};
	that.name = "that is it";
	return that;
};

var o = new Oj();
o.name //"that is it"
```
可以看到，构造函数可以自由地返回任意对象，只要它是一个对象。因此利用这个特性，可以创建无new构造函数。

```javascript
function  Person(name) {
	var that = {};
	that.name = name;
	return that;
}
或
function Person(name) {
	return {
		name: name
	}
}
//
//使用这种方式有一个问题，它会丢失原型链接。
//可以这样改进
function Person(name) {
	if(!(this instanceof Person)){
		return new Person();
	}
	this.name = name;
}
```

### 原型模式 ###
构造函数的缺点是，每个方法都要在每个实例上重新创建一遍。这个问题可以通过原型模式来解决。

我们创建的每一个函数都有一个`prototype`属性，这个属性是一个指针，指向一个对象，这个对象的用途是包含可以以由特定类型的所有实例共享的属性和方法。默认情况下，这个原型对象会自动获得一个`constructor`属性，这个属性包含一个指向原构造函数的指针。

当调用构造函数创建新实例后，该实例的内部将包含一个指针，指向构造函数的原型对象。（在ff、safari、Chrome中有`__proto__`属性，其他浏览器中这个属性对脚本不可见）我们可以通过`isPrototypeOf()`方法来确定对象之间是否存在这种关系。

当为对象实例添加属性时，这个属性就会屏蔽原型对象中的同名属性；换句话说，添加这个属性只会阻止我们访问原型中的那个属性，但不会修改那个属性。我们可以通过`delete`删除该属性来重新访问原型中的属性。

```javascript
function Person(name) {
	this.name = name;
}
Person.prototype.name = "Lomo";
Person.prototype.age = "24";
Person.prototype.sayName = function() {
	alert(this.name);
};

var person1 = new Person();
var person2 = new Person("mo");
person1.sayName();//undefined
person2.sayName();//"mo"
//屏蔽了原型上的属性

delete person1.name;
person1.sayName();//"Lomo"
//delete后可以访问原型的属性

Person.prototype.isPrototypeOf(person1);//true

alert("name" in person1);//true
alert("age" in person1);//true

person1.hasOwnProperty("name");//true
person1.hasOwnProperty("age");//false

//可以通过这种方式判断属性是实例中的还是原型中的
```

原型模式也有缺点的。原型中的属性是被很多实例共享的，如果是引用类型的属性，假如其中一个对象对其进行了修改，那么这个改变也会反映到其他实例上。

### 其他对象创建模式 ###

* 组合模式
组合使用构造函数模式与原型模式。构造函数用于定义实例属性，原型模式用于定义方法和共享的属性。

* 动态原型模式
它把所有信息封装在构造函数，通过再构造函数中初始化原型，又保持了同时使用构造函数和原型的优点。

	```javascript
function Person(name, age ,job){
	this.name = name;
	this.age = age;
	this.job = job;
	if(typeof this.sayName != "function") {
		Person.prototype.sayName = function() {
			alert(this.name);
		}
	}
}
```

* 寄生构造函数模式
基本思想就是创建一个函数，该函数的做用事封装创建对象的代码，然后返回新创建的对象。

	```javascript
function Person(name, age, job){
	var o = new Object();
	o.name = name;
	o.age = age;
	o.job = job;
	o.sayName = function() {
		alert(this.name);
	}
	return o;
}
```

* 稳妥构造函数模式
类似于寄生构造函数模式，区别在于：新创建对象的实例方法不引用`this`、不使用`new`操作符调用构造函数。这种模式创建的对象中，除了使用`sayName()`方法之外，没有其他办法访问`name`的值.

	```javascript
function Person(name, age, job) {
	var o = new Object();
	//这里添加私有属性和方法
	o.sayName = function(){
		alert(name);//注意这里没有this
	}
	return o;
}
var lomo = Person("lomo",24,"student");
lomo.sayName();//"lomo"
lomo.name = "mo";
lomo.sayName();//"lomo"
lomo.name //"mo"
```

## 更高级的玩法 ##
###  命名空间模式 ###
JS中并没有内置命名空间，我们可以去实现它。创建一个全局对象，然后将所有功能添加到改对象中，这样就不会污染全局。

```javascript
//使用这种方式建立命名空间。
var MYAPP = MYAPP || {};
```
在添加一个属性最好检查它是否已经存在。

```javascript
MYAPP.namespace = function (ns_string) {
	var parts = ns_string.split('.'),
		parent = MYAPP,
		i;
	if(parts[0]==="MYAPP"){
		parts = parts.slice(1);
	}
	for(i=0; i<parts.length; i+=1) {
		if(typeof parent[parts[i]] === "undefined") {
			parent[parts[i]] = {};
		}
		parent = parent[parent[i]];
	}
	return parent;
}

MYAPP.namespace('MYAPP.module1.module2');//返回MYAPP.module1.module2
```

### 声明依赖关系 ###
在函数或者模块顶部声明代码所依赖的模块有以下优点：

* 清晰明了
* 解析局部变量速度比全局变量，能优化性能。
* 减少代码量

```javascript
var myFunction = function() {
	//依赖
	var e = MYAPP.util.Event,
		d = MYAPP.util.Dom;

	//...
};
```

### 私有属性和方法 ###

JS没有特殊的语法表示私有属性和方法。我们可以使用闭包来实现。

```javascript
function Gadget() {
	//私有成员
	var name = 'ipod';
	//共有成员
	this.getName = function() {
		return name;
	};
}
var toy = new Gadget();
toy.name;//undefined
toy.getName();//ipod
//需要注意的是不要传递保持私有性的数组和对象的引用
//每次调用构造函数的时候这些私有属性都会被重复创建
//是原型具有私有属性

Gadget.prototype = (function(){
	var owner = 'lomo';
	return {
		getBrowser:function() {
			return browser;
		}
	}
}())
//揭示模式可以将私有方法暴露成为公有方法
var myapp;
(function(){
	function a(){
		//...
	}
	function b(){
		//...
	}
	myarray = {
		a: a,
		b: b
	}
}())
```

### 模块模式 ###
模块模式就是以上几种模式的组合。强烈建议用这种方式组织代码。

```javascript
MYAPP.namespace('MYAPP.util.array');
MYAPP.util.array = (function(){
	//依赖
	var uobj = MYAPP.util.obj;

	//私有属性
	var name = "lomo";

	//私有方法
	function a(){
		//...
	}

	//公有API
	return {
		inArray:function(){
			//...
		},
		a: a,
		name:name
	}
}())

//我们也可以将全局变量导入到模块中
MYAPP.util.array = (function(app, global){
	//引用全局对象
}(MYAPP,this))
```
### 沙箱模式 ###
命名空间模式有两个缺点：对单个全局变量的依赖变成对应用程序的全局变量依赖、点分割需要更长的解析时间(如`MYAPP.util.array`)。
命名空间模式，有一个全局对象；沙箱模式，则是由一个全局构造函数`Sandbox()`。
该模式具有两个新特性：

* 可以不用new操作符
* Sandbox()可以接受参数，参数指定了所需要的模块名。回调函数中的box参数为新建的实例自身。

```javascript
	Sandbox(['ajax', 'event'], function(box){
		//...
		Sandbox(['dom'],function(box){
			//另一个沙箱化的box对象
		})
	})
```


```javascript
	Sandbox.modules = {
		//模块
		dom: function(box){
			box.getElement = function(){};
			//...
		}
	}

	Sandbox(){
	//将参数转换成数组
		var args = Array.prototype.slice.call(arguments);
	//最后一个参数是回调函数
		calback = args.pop();
		modules = (args[0] && typeof args[0] === "string")?args:args[0],
		i;
	//无new操作符也可正常运行
		if(!(this instanceof Sandbox)) {
			return new Sandbox(modules, callback);
		}

	//需要添加的this属性
		this.a = 1;
		//...

	//向this对象添加模块
		if(!modules || modules === '*') {
			modules = [];
			for(i in Sandbox.modules) {
				if(Sandbox.modules.hasOwnProperty(i)){
					modules.push(i)
				}
			}
		}
	//初始化需要的模块
		for(i = 0; i<modules.length; i++){
			Sandbox.modules[modules[i]](this);
		}

	//callbakc
		callback(this);
	}

	//可以添加原型属性
	Sandbox.prototype = {
		//...
	}
```

### 静态成员 ###

* 公有静态成员
从一个实例到另一个实例不会改变的属性和方法。构造函数也是对象，可以拥有属性，向函数中添加属性即可。

	```javascript
var Gadget = function(price) {
	this.price = price;
}

//静态方法
Gadget.isShiny = function() {
	var msg = "you bet";

	if(this instanceof Gadget) {
		msg = "it costs " + this.price;
	}
	return msg;
}

Gadget.prototype.isShiny = function() {
	return Gadget.isShiny.call(this);
}


//静态调用
Gadget.isShiny();

//非静态调用
var a = new Gadget('100');
a.isShiny();// ‘it costs 100’
```

* 私有静态成员
同一构造函数创建的实例共享该成员，构造函数外部不可访问该成员

	```javascript
var Gadget = (function(){
	var counter = 0,
		NewGadget;
	//新的构造函数
	NewGadget = function() {
		counter += 1;
	}
	NewGadget.prototype.getLastId = function() {
		return counter;
	}
	return NewGadget;
}())
```


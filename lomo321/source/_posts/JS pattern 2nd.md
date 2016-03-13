title: JS模式：继承
date: 2015/09/29
layout: post
tags: JS
---

上一篇介绍了JS对象的特点以及如何创建对象。这篇谈一下在JS里如何实现继承。

实现继承的主要方式是利用原型链。其基本思想是利用原型让一个引用类型继承另一个引用类型的属性和方法。每个构造函数都有一个原型对象，原型对象都包含一个指向构造函数的指针，而实例都包含一个指向原型对象的内部指针。我们让原型对象等于另一个类的实例，此时原型对象将包含一个指向另一个原型的指针，假如另一个原型又是另一个类型的实例，如此层层递进，构成了实例与原型的链条。这就是原型链。

* [默认方式](#默认方式)
* [借用构造函数](#借用构造函数)
* [组合继承](#组合继承)
* [共享原型](#共享原型)
* [临时构造函数](#临时构造函数)
* [原型式继承](#原型式继承)
* [寄生式继承](#寄生式继承)
* [寄生组合式继承](#寄生组合式继承)

<!--more-->

## 默认方式 ##
最常用的一种默认方法是使用`Parent()`构造函数创建一个对象，并将该对象赋值给`Child()`的原型。

```javascript
function Parent(){
	this.name = "Lomo";
}
Parent.prototype.getParentName = function(){
	return this.name;
}

function Child(){
	this.childName = "Arbor";
}
//实现继承
Child.prototype = new Parent();
Child.prototype.getChildName = function(){
	return this.childName;
}

var instance = new Child();

alert(instance instanceof Object);//true
alert(instance instanceof Parent);//true
alert(instance instanceof Child);//true

alert(Object.prototype.isPrototypeOf(instance));//true
alert(Parent.prototype.isPrototypeOf(instance));//true
alert(Child.prototype.isPrototypeOf(instance));//true
```

这种方法是有缺点的。

1. 引用类型的原型属性会被所有实例共享，而这正是为什么要在构造函数中而不再原型对象中定义属性的原因。在通过原型来实现继承时，原型实际上会变成另一个类型的实例，于是实例属性也顺理成章变成原型属性了。
2. 在创建子类的实例时，无法向父类的构造函数传递参数。

## 借用构造函数 ##

这种技术思想很简单，即在子类构造函数内部调用父类构造函数。

```javascript
function Father(){
	this.tags = ['handsome','smart'];
}
function Mother(){
	this.attribute = ['beauty','thin'];
}
Father.prototype.say = function(){
	alert("My son is Arbor.");
}
function Son(){
	Father.apply(this,arguments);
	Mother.apply(this,arguments);//可以实现多重继承
}

var arbor = new Son();
arbor.say();//报错 say is undefined
```

借用构造函数的优点是可以父类传递参数，并且不会存在子类意外覆盖父对象属性的风险，但缺点就是无法继承父类原型的任何东西。


## 组合继承 ##

顾名思义，这个方法就将以上两种方式结合到一起。

```javascript
function Father(name){
	this.name = name || 'Lomo';
}

Father.prototype.say = function(){
	alert("My father is lomo.");
}

function Son(){
	Father.apply(this,arguments);
}
Son.prototype = new Father();

var arbor = new Son("arbor");
arbor.say()//"My father is lomo."
arbor.name //"arbor"
```

## 共享原型 ##

本模式的经验法则在于：可复用成员应该放在原型中而不是放在构造函数中。将子类的原型设置为与父类相同即可。

```javarscript
Son.prototype = Father.prototype;
```

## 临时构造函数 ##

```javascript
var F = funtion(){};
F.prototype = Father.prototype;
Son.prototype = new F();
Son.prototype.constructor = Son;//重置构造函数指针
```

## 原型式继承 ##
这种方法并没有严格意义上的构造函数。核心思想是借助原型基于已有对象创建新对象。作为参数传入`object`函数的`o`对象会成为所有实例的原型，因此，引用类型的属性也会被共享。

```javascript
function object(o) {
	function F(){};
	F.prototype = o;
	return new F();
}

ES5中有专门的方法
Object,create(o[, newPoperties]);
```

## 寄生式继承 ##
寄生式继承是与原型式继承紧密相关的一种思路。创建一个仅用于封装继承过程的函数，该函数在内部以某种方式增强对象。

```javascript
function createAnother(o){
	var clone = object(o);
	clone.say = function(){
		alert("hi");
	}
	return clone;
}
```

## 寄生组合式继承 ##
使用组合式继承，父构造函数会产生两组相同的属性，一组存在于子类的原型中，一组存在于子类实例中。寄生组合式继承可以解决这个问题。

```javascript
function inheritPrototype(Son,Father){
	var prototype = object(Father.prototype);
	prototype.constructor = Son;
	Son.prototype = prototype;
}
```

第一步是创建超类型原型的一个副本。
第二步是为创建的副本添加constructor属性，从而弥补因重写原型而失去的默认的constructor属性。
最后一步，将新创建的对象（即副本）赋值给子类型的原型，这样，我们就可以用调inheritPrototype()函数的语句，去替换前面例子中为子类原型赋值的语句了。

这个例子的高效率体现在它之调用了一次SuperType构造函数，并且因此避免了在SubType.prototype上面创建不你要的、多余的属性。
与此同时，原型链还能保持不变；因此，还能够正常使用instanceof和isPrototypeOf(),开发人员普遍认为寄生组合式继承是引用类型最理想的继承范式。
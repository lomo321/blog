title: 7 Essential JavaScript Functions
layout: post
---
看到同事`天空男-斯盖勒`的博客中[《七个必备的js函数》](http://www.skylerzhang.com/js/2015/06/14/7-Essential-JavaScript-Functions/)这篇文章，满怀希望地点进去了。毫无意外地感到了失望，他只翻译了一个函数。作为好同事的我，决定把剩下的六个也翻译了。
原文链接[《7 Essential JavaScript Functions》](http://davidwalsh.name/essential-javascript-functions)
# debounce(去抖) #
***


什么是`debounce`？
举个例子，设置一个时间t毫秒，在触发事件后的t毫秒内，假如事件没有再次被触发，则执行回调函数；若再次触发，则重新计时。


`debouce`函数是提升事件驱动性能方面的佼佼者。如果没有把去抖函数使用在`scroll`,`resize`,`key`等事件中，你的程序可能会出现错误。下面这个debounce函数 可以使你的代码更加高效：



```javascript
function debounce(func, wait, immediate) {
	var timeout;
	return function() {
		var context = this, args = arguments;
		var later = function() {
			timeout = null;
			if (!immediate) func.apply(context, args);
		};
		var callNow = immediate && !timeout;
		clearTimeout(timeout);
		timeout = setTimeout(later, wait);
		if (callNow) func.apply(context, args);
	};
};
var myEfficientFn = debounce(function() {
	//your code
}, 250);
window.addEventListener('resize', myEfficientFn);
```

<!--more-->





# throttle #
***
最后补充一个节流函数。在使用`mousemove`，`resize`或者`scroll`这类事件的时候，事件会不断地被触发，回调函数多次被执行。而`throttle`函数可以控制执行频率。这里给一个简单的实现方式（详细见[throttle与debounce](http://www.cnblogs.com/fsjohnhuang/p/4147810.html)）：

```javascript
var throttle = function(delay, action){
  var last = 0;
  return function(){
    var curr = +new Date();
    if (curr - last > delay)
      action.apply(this, arguments);
    last = curr;
  };
};
```



# poll #
***
使用上文提到的去抖函数，有时候你并不能为你所需的某个状态触发一个回调（譬如你希望某个div元素宽度达到100px时触发一个回调），因为这个事件有可能不存在。这时你需要每隔一段时间就检测一次状态，看看是否满足条件触发回调。



```javascript
function poll(fn, callback, errback, timeout, interval) {
    var endTime = Number(new Date()) + (timeout || 2000);
    interval = interval || 100;

    (function p() {
            // 如果条件满足
            if(fn()) {
                callback();
            }
            // 假如不满足，设置间隔时间
            else if (Number(new Date()) < endTime) {
                setTimeout(p, interval);
            }
            // 超时则报错
            else {
                errback(new Error('timed out for ' + fn + ': ' + arguments));
            }
    })();
}
// Usage:  ensure element is visible
poll(
    function() {
        return document.getElementById('lightbox').offsetWidth > 0;
    },
    function() {
        // Done, success callback
    },
    function() {
        // Error, failure callback
    }
);
```




# once #
***


很多情况下，你希望函数只能执行一次，类似你使用`onload`事件的方式。以下的代码实现了这个功能。



```javascript
function once(fn, context) {
	var result;

	return function() {
		if(fn) {
			result = fn.apply(context || this, arguments);
			fn = null;
		}

		return result;
	};
}

// Usage
var canOnlyFireOnce = once(function() {
	console.log('Fired!');
});

canOnlyFireOnce(); // "Fired!"
canOnlyFireOnce(); // nada
```
`once`确保了函数只执行一次，从而可以避免重复初始化。



# getAbsoluteUrl #
***


这是一个获取绝对地址的小技巧：



```javascript
var getAbsoluteUrl = (function() {
	var a;

	return function(url) {
		if(!a) a = document.createElement('a');
		a.href = url;

		return a.href;
	};
})();
// Usage
getAbsoluteUrl('/something'); // http://davidwalsh.name/something

```



# isNative #
***
有时候你声明的函数名可能跟原生的函数名重复了，那如何才能知道一个函数是否为原生的。这段简单的代码可以给你答案：

```javascript
(function() {
  // Used to resolve the internal [[Class]] of values
  var toString = Object.prototype.toString;

  // Used to resolve the decompiled source of functions
  var fnToString = Function.prototype.toString;

  // Used to detect host constructors (Safari > 4; really typed array specific)
  var reHostCtor = /^\[object .+?Constructor\]$/;

  // Compile a regexp using a common native method as a template.
  // We chose `Object#toString` because there's a good chance it is not being mucked with.
  var reNative = RegExp('^' +
    // Coerce `Object#toString` to a string
    String(toString)
    // Escape any special regexp characters
    .replace(/[.*+?^${}()|[\]\/\\]/g, '\\$&')
    // Replace mentions of `toString` with `.*?` to keep the template generic.
    // Replace thing like `for ...` to support environments like Rhino which add extra info
    // such as method arity.
    .replace(/toString|(function).*?(?=\\\()| for .+?(?=\\\])/g, '$1.*?') + '$'
  );

  function isNative(value) {
    var type = typeof value;
    return type == 'function'
      // Use `Function#toString` to bypass the value's own `toString` method
      // and avoid being faked out.
      ? reNative.test(fnToString.call(value))
      // Fallback to a host object check because some environments will represent
      // things like typed arrays as DOM methods which may not conform to the
      // normal native pattern.
      : (value && type == 'object' && reHostCtor.test(toString.call(value))) || false;
  }

  // export however you want
  module.exports = isNative;
}());

// Usage
isNative(alert); // true
isNative(myCustomFunction); // false
```
这段代码虽然不好看，但是很实用！



# insertRule #
***
大家都知道我们可以从选择器中获取节点列表并且修改它们的样式，但我们有更高效的方法吗（像css一样）？

```javascript
var sheet = (function() {
	// Create the <style> tag
	var style = document.createElement('style');

	// Add a media (and/or media query) here if you'd like!
	// style.setAttribute('media', 'screen')
	// style.setAttribute('media', 'only screen and (max-width : 1024px)')

	// WebKit hack :(
	style.appendChild(document.createTextNode(''));

	// Add the <style> element to the page
	document.head.appendChild(style);

	return style.sheet;
})();

// Usage
sheet.insertRule("header { float: left; opacity: 0.8; }", 1);
```



# matchesSelector #
***
讲解这个函数之前先补充一点相关知识：matchesSelector用来匹配dom元素是否匹配某css selector。
譬如

```javascript
<div id="wraper" class="item"></div>
<script>
    wraper.mozMatchesSelector('div') // true 标签选择器
    wraper.mozMatchesSelector('#wraper') // true id选择器
    wraper.mozMatchesSelector('.item') // true 类选择器
</script>
```

目前除IE6-IE8，Firefox/Chrome/Safari/Opera/IE 的最新版本均已实现，但方法都带上了各自的前缀:

```
Chrome/Safari: webkitMatchesSelector
FireFox: mozMatchesSelector
IE9+: msMatchesSelector

```

回到正题，`matchesSelector`解决了兼容性问题并提供了接口。

```javascript
function matchesSelector(el, selector) {
	var p = Element.prototype;
	var f = p.matches || p.webkitMatchesSelector || p.mozMatchesSelector || p.msMatchesSelector || function(s) {
		return [].indexOf.call(document.querySelectorAll(s), this) !== -1;
	};
	return f.call(el, selector);
}

// Usage
matchesSelector(document.getElementById('myDiv'), 'div.someSelector[some-attribute=true]')

```
***


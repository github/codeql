(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof _dereq_=="function"&&_dereq_;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof _dereq_=="function"&&_dereq_;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
var b = _dereq_('./b'),
    c = _dereq_('./c'),
    d = _dereq_('./d');
b.sayHello();
},{"./b":2,"./c":3,"./d":4}],2:[function(_dereq_,module,exports){
exports.sayHello = function() {
  console.log("Hello, world!");
}
},{}],3:[function(_dereq_,module,exports){
var __webpack_require__ = false;
var imp = 'b';
_dereq_('.' + imp);
},{}],4:[function(_dereq_,module,exports){
// nothing
},{}]},{},[1]);

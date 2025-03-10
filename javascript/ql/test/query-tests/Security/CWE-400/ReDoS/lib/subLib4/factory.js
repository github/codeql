(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
	typeof define === 'function' && define.amd ? define('some-lib', ['exports'], factory) :
	(global = global || self, factory(global.JSData = {}));
  }(this, (function (exports) { 'use strict';

  exports.foo = function (name) { // $ Source[js/polynomial-redos]
	/f*g/.test(name); // $ Alert[js/polynomial-redos] Sink[js/polynomial-redos]
  }
})));
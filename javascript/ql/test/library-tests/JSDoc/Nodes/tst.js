// Tests adapted from https://github.com/google/closure-compiler/wiki/Annotating-JavaScript-for-the-Closure-Compiler,
// which is part of the documentation for the Google Closure compiler, which is licensed under the Apache License 2.0;
// see file COPYING.

/** @const */ var MY_BEER = 'stout';

/**
 * My namespace's favorite kind of beer.
 * @const
 * @type {string}
 */
mynamespace.MY_BEER = 'stout';

/** @const */ MyClass.MY_BEER = 'stout';

/**
 * A rectangle.
 * @constructor
 */
function GM_Rect() {
}

/** @define {boolean} */
var ENABLE_DEBUG = true;

/** @define {boolean} */
goog.userAgent.ASSUME_IE = false;

/**
 * Determines whether a node is a field.
 * @return {boolean} True if the contents of
 *     the element are editable, but the element
 *     itself is not.
 * @deprecated Use isField().
 */
BN_EditUtil.isTopEditableField = function(node) {
};

/**
 * @constructor
 * @dict
 */
function Foo() {}
var obj1 = new Foo();
obj1['x'] = 123;
obj1.x = 234;  // warning

var obj2 = /** @dict */ { 'x': 321 };
obj2.x = 123;  // warning

/**
 * Enum for tri-state values.
 * @enum {number}
 */
project.TriState = {
  TRUE: 1,
  FALSE: -1,
  MAYBE: 0
};

/** @export */
foo.MyPublicClass.prototype.myPublicMethod = function() {
};

/**
 * Immutable empty node list.
 * @constructor
 * @extends {goog.ds.BasicNodeList}
 */
goog.ds.EmptyNodeList = function() {
};

/**
 * A class that cannot be extended.
 * @final
 * @constructor
 */
sloth.MyFinalClass = function() { }

/**
 * A method that cannot be overridden.
 * @final
 */
sloth.MyFinalClass.prototype.method = function() { };

/**
 * A shape.
 * @interface
 */
function Shape() {};
Shape.prototype.draw = function() {};

/**
 * @constructor
 * @implements {Shape}
 */
function Square() {};
Square.prototype.draw = function() {
};

/**
 * @override
 * @inheritDoc */
project.SubClass.prototype.toString = function() {
};

/**
 * A polygon.
 * @interface
 * @extends {Shape}
 */
function Polygon() {};
Polygon.prototype.getSides = function() {};

goog.object.extend(
        Button.prototype,
        /** @lends {Button.prototype} */ ({
          isButton: function() { return true; }
        }));

/**
 * @preserve Copyright 2009 SomeThirdParty.
 * Here is the full license text and copyright
 * notice for this file. Note that the notice can span several
 * lines and is only terminated by the closing star and slash:
 */

/** @nosideeffects */
function noSideEffectsFn1() { return 42; }

/**
 * Returns the window object the foreign document resides in.
 *
 * @return {Object} The window object of the peer.
 * @package
 */
goog.net.xpc.CrossPageChannel.prototype.getPeerWindowObject = function() {
};

/**
 * Queries a Baz for items.
 * @param {number} groupNum Subgroup id to query.
 * @param {string|number|null} term An itemName,
 *     or itemId, or null to search everything.
 */
goog.Baz.prototype.query = function(groupNum, term) {
};

function foo(/** number */ a, /** number */ b) {
  return a - b + 1;
}

/**
 * Handlers that are listening to this logger.
 * @type {Function[]}
 * @private
 */
this.handlers_ = [1,2,3];

/**
 * Sets the component's root element to the given element.
 * Considered protected and final.
 * @param {Element} element Root element for the component.
 * @protected
 */
goog.ui.Component.prototype.setElementInternal = function(element) {
};

/**
 * Returns the ID of the last item.
 * @return {string} The hex ID.
 */
goog.Baz.prototype.getLastId = function() {
  return id;
};

function /** number */ foo(x) { return x - 1; }

/**
 * @constructor
 * @struct
 */
function Foo(x) {
  this.x = x;
}
var obj1 = new Foo(123);
var someVar = obj1.x;  // OK
obj1.x = "qwerty";  // OK
obj1['x'] = "asdf";  // warning
obj1.y = 5;  // warning

var obj2 = /** @struct */ { x: 321 };
obj2['x'] = 123;  // warning

chat.RosterWidget.extern('getRosterElement',
        /**
         * Returns the roster widget element.
         * @this {Widget}
         * @return {Element}
         */
        function() {
          return this.getComponent().getElement();
        });

/**
 * @throws {DOMException}
 */
DOMApplicationCache.prototype.swapCache = function() { };

/**
 * The message hex ID.
 * @type {string}
 */
var hexId = hexId;

/** @typedef {(string|number)} */
goog.NumberLike;

/** @param {goog.NumberLike} x A number or a string. */
goog.readNumber = function(x) {
}

/** @type {{myNum: number, myObject}} */
var o;

/** @type {number?} */
var x;

/** @type {!Object} */
var y;

/**
 * @param {function(string, boolean)} p1
 * @param {function(): number} p2
 * @param {function(this:goog.ui.Menu, string)} p3
 * @param {function(new:goog.ui.Menu, string)} p4
 * @param {function(string, ...[number]): number} p5
 * @param {...number} var_args p6
 * @param {number=} opt_argument p7
 * @param {function(?string=, number=)} p8
 * @param {*} p9
 * @param {?} p10
 */
var f;

/**
 * @constructor
 * @template T
 */
var Foo = function() { this.value = null; };

/** @return {T} */
Foo.prototype.get = function() { return this.value; };

/** @param {T} t */
Foo.prototype.set = function(t) { this.value = t; };

/** @type {!Foo.<string>} */ var foo = new Foo();
var foo = /** @type {!Foo.<string>} */ (new Foo());

/**
 * @param {T} t
 * @constructor
 * @template T
 */
Bar = function(t) { };
var bar = new Bar("hello"); // bar is a Bar.<string>

/**
 * @constructor
 * @template Key, Val
 */
var MyMap = function() { };

/** @type {MyMap.<string, number>} */ var map; // Key = string, Val = number.

/**
 * @constructor
 */
X = function() { };

/**
 * @extends {X}
 * @constructor
 */
Y = function() { };

/** @type {Foo.<X>} */ var fooX;
/** @type {Foo.<Y>} */ var fooY;

fooX = fooY; // Error
fooY = fooX; // Error

/** @param {Foo.<Y>} fooY */
takesFooY = function(fooY) { };

takesFooY(fooY); // OK.
takesFooY(fooX); // Error

/**
 * @constructor
 * @template T
 */
A = function() { };

/** @param {T} t */
A.prototype.method = function(t) { };

/**
 * @constructor
 * @extends {A.<string>}
 */
B = function() { };

/**
 * @constructor
 * @template U
 * @extends {A.<U>}
 */
C = function() { };

/**
 * @interface
 * @template T
 */
Foo = function() {};

/** @return {T} */
Foo.prototype.get = function() {};

/**
 * @constructor
 * @implements {Foo.<string>}
 * @implements {Foo.<number>}
 */
FooImpl = function() { }; // Error - implements the same interface twice

/**
 * @param {T} a
 * @return {T}
 * @template T
 */
identity = function(a) { return a; };

/** @type {string} */ var msg = identity("hello") + identity("world"); // OK
/** @type {number} */ var sum = identity(2) + identity(2); // OK
/** @type {number} */ var sum = identity(2) + identity("2"); // Type mismatch

/** @type {string|undefined} */ var string_or_undef;

/**
 * @param x [int] an integer
 */
function f(x) {}

/**
 * @param {Array.<number>} array - the array to sort
 * @param {function(x:!number, y:!number):number} fn - the comparator function
 */
function sort(array, fn) {}

var literalWithMethods = {
  /**
   * @param {T1} p
   */
  classicMethod: function(p) {},
  
  /**
   * @param {T2} p
   */
  fancyMethod(p) {}
};

class C {
  /**
   * @param {T3} p
   */
  constructor(p) {}

  /**
   * @param {T4} p
   */
  classMethod(p) {}
}

/**
 * @param {Array.<
 *    number>} x
 */
function multiline(x) {}

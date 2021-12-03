// Adapted from the Google Closure externs; original copyright header included below.
/*
 * Copyright 2008 The Closure Compiler Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @constructor
 * @param {*=} opt_value
 * @return {!Object}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object
 */
function Object(opt_value) {}

/**
 * The constructor of the current object.
 * @type {Function}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/constructor
 */
Object.prototype.constructor = function() {};

/**
 * Binds an object's property to a function to be called when that property is
 * looked up.
 * Mozilla-only.
 *
 * @param {string} sprop
 * @param {Function} fun
 * @modifies {this}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/defineGetter
 */
Object.prototype.__defineGetter__ = function(sprop, fun) {};

/**
 * Binds an object's property to a function to be called when an attempt is made
 * to set that property.
 * Mozilla-only.
 *
 * @param {string} sprop
 * @param {Function} fun
 * @modifies {this}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/defineSetter
 */
Object.prototype.__defineSetter__ = function(sprop, fun) {};

/**
 * Returns whether the object has a property with the specified name.
 *
 * @param {*} propertyName Implicitly cast to a string.
 * @return {boolean}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/hasOwnProperty
 */
Object.prototype.hasOwnProperty = function(propertyName) {};

/**
 * Returns whether an object exists in another object's prototype chain.
 *
 * @param {Object} other
 * @return {boolean}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/isPrototypeOf
 */
Object.prototype.isPrototypeOf = function(other) {};

/**
 * Return the function bound as a getter to the specified property.
 * Mozilla-only.
 *
 * @param {string} sprop a string containing the name of the property whose
 * getter should be returned
 * @return {Function}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/lookupGetter
 */
Object.prototype.__lookupGetter__ = function(sprop) {};

/**
 * Return the function bound as a setter to the specified property.
 * Mozilla-only.
 *
 * @param {string} sprop a string containing the name of the property whose
 *     setter should be returned.
 * @return {Function}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/lookupSetter
 */
Object.prototype.__lookupSetter__ = function(sprop) {};

/**
 * Executes a function when a non-existent method is called on an object.
 * Mozilla-only.
 *
 * @param {Function} fun
 * @return {*}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/noSuchMethod
 */
Object.prototype.__noSuchMethod__ = function(fun) {};

/**
 * Points to an object's context.  For top-level objects, this is the e.g. window.
 * Mozilla-only.
 *
 * @type {Object}
 * @deprecated
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/parent
 */
Object.prototype.__parent__;

/**
 * Points to the object which was used as prototype when the object was instantiated.
 * Mozilla-only.
 *
 * Will be null on Object.prototype.
 *
 * @type {Object}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/proto
 */
Object.prototype.__proto__;

/**
 * Determine whether the specified property in an object can be enumerated by a
 * for..in loop, with the exception of properties inherited through the
 * prototype chain.
 *
 * @param {string} propertyName
 * @return {boolean}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/propertyIsEnumerable
 */
Object.prototype.propertyIsEnumerable = function(propertyName) {};

/**
 * Returns a localized string representing the object.
 * @return {string}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/toLocaleString
 */
Object.prototype.toLocaleString = function() {};

/**
 * Returns a string representing the source code of the object.
 * Mozilla-only.
 * @return {string}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/toSource
 */
Object.prototype.toSource = function() {};

/**
 * Returns a string representing the object.
 * @this {*}
 * @return {string}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/toString
 */
Object.prototype.toString = function() {};

/**
 * Removes a watchpoint set with the {@see Object.prototype.watch} method.
 * Mozilla-only.
 * @param {string} prop The name of a property of the object.
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/unwatch
 */
Object.prototype.unwatch = function(prop) {};

/**
 * Returns the object's {@code this} value.
 * @return {*}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/valueOf
 */
Object.prototype.valueOf = function() {};

/**
 * Sets a watchpoint method.
 * Mozilla-only.
 * @param {string} prop The name of a property of the object.
 * @param {Function} handler A function to call.
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Object/watch
 */
Object.prototype.watch = function(prop, handler) {};


/**
 * @constructor
 * @param {...*} var_args
 * @nosideeffects
 * @throws {Error}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Function
 */
function Function(var_args) {}

/**
 * @param {...*} var_args
 * @return {*}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Function/call
 */
Function.prototype.call = function(var_args) {};

/**
 * @param {...*} var_args
 * @return {*}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Function/apply
 */
Function.prototype.apply = function(var_args) {};

Function.prototype.arguments;

/**
 * @type {number}
 * @deprecated
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Function/arity
 */
Function.prototype.arity;

/**
 * Nonstandard; Mozilla and JScript only.
 * @type {Function}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Function/caller
 */
Function.prototype.caller;

/**
 * Nonstandard.
 * @type {?}
 * @see http://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/displayName
 */
Function.prototype.displayName;

/**
 * Expected number of arguments.
 * @type {number}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Function/length
 */
Function.prototype.length;

/**
 * @type {string}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Function/name
 */
Function.prototype.name;

/**
 * @this {Function}
 * @return {string}
 * @nosideeffects
 * @override
 */
Function.prototype.toString = function() {};


/**
 * @constructor
 * @param {...*} var_args
 * @return {!Array.<?>}
 * @nosideeffects
 * @template T
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array
 */
function Array(var_args) {}

// Functions:

/**
 * Returns a new array comprised of this array joined with other array(s)
 * and/or value(s).
 *
 * @param {...*} var_args
 * @return {!Array.<?>}
 * @this {*}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/concat
 */
Array.prototype.concat = function(var_args) {};

/**
 * Joins all elements of an array into a string.
 *
 * @param {*=} opt_separator Specifies a string to separate each element of the
 *     array. The separator is converted to a string if necessary. If omitted,
 *     the array elements are separated with a comma.
 * @return {string}
 * @this {{length: number}|string}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/join
 */
Array.prototype.join = function(opt_separator) {};

/**
 * Removes the last element from an array and returns that element.
 *
 * @return {T}
 * @this {{length: number}|Array.<T>}
 * @modifies {this}
 * @template T
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/pop
 */
Array.prototype.pop = function() {};

/**
 * Mutates an array by appending the given elements and returning the new
 * length of the array.
 *
 * @param {...T} var_args
 * @return {number} The new length of the array.
 * @this {{length: number}|Array.<T>}
 * @template T
 * @modifies {this}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/push
 */
Array.prototype.push = function(var_args) {};

/**
 * Transposes the elements of an array in place: the first array element becomes the
 * last and the last becomes the first.
 *
 * @this {{length: number}}
 * @modifies {this}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/reverse
 */
Array.prototype.reverse = function() {};

/**
 * Removes the first element from an array and returns that element. This
 * method changes the length of the array.
 *
 * @this {{length: number}|Array.<T>}
 * @modifies {this}
 * @return {T}
 * @template T
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/shift
 */
Array.prototype.shift = function() {};

/**
 * Extracts a section of an array and returns a new array.
 *
 * @param {*=} opt_begin Zero-based index at which to begin extraction.  A
 *     non-number type will be auto-cast by the browser to a number.
 * @param {*=} opt_end Zero-based index at which to end extraction.  slice
 *     extracts up to but not including end.
 * @return {!Array.<T>}
 * @this {{length: number}|Array.<T>|string}
 * @template T
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/slice
 */
Array.prototype.slice = function(opt_begin, opt_end) {};

/**
 * Sorts the elements of an array in place.
 *
 * @param {function(T,T):number=} opt_compareFunction Specifies a function that
 *     defines the sort order.
 * @this {{length: number}|Array.<T>}
 * @template T
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/sort
 */
Array.prototype.sort = function(opt_compareFunction) {};

/**
 * Changes the content of an array, adding new elements while removing old
 * elements.
 *
 * @param {*=} opt_index Index at which to start changing the array. If negative,
 *     will begin that many elements from the end.  A non-number type will be
 *     auto-cast by the browser to a number.
 * @param {*=} opt_howMany An integer indicating the number of old array elements
 *     to remove.
 * @param {...T} var_args
 * @return {!Array.<T>}
 * @this {{length: number}|Array.<T>}
 * @modifies {this}
 * @template T
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/splice
 */
Array.prototype.splice = function(opt_index, opt_howMany, var_args) {};

/**
 * @return {string}
 * @this {Object}
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/toSource
 */
Array.prototype.toSource;

/**
 * @this {Array.<?>}
 * @return {string}
 * @nosideeffects
 * @override
 */
Array.prototype.toString = function() {};

/**
 * Adds one or more elements to the beginning of an array and returns the new
 * length of the array.
 *
 * @param {...*} var_args
 * @return {number} The new length of the array
 * @this {{length: number}}
 * @modifies {this}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/unshift
 */
Array.prototype.unshift = function(var_args) {};

/**
 * Apply a function simultaneously against two values of the array (from
 * left-to-right) as to reduce it to a single value.
 *
 * @param {?function(?, T, number, !Array.<T>) : R} callback
 * @param {*=} opt_initialValue
 * @return {R}
 * @this {{length: number}|Array.<T>|string}
 * @template T,R
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/reduce
 */
Array.prototype.reduce = function(callback, opt_initialValue) {};

/**
 * Apply a function simultaneously against two values of the array (from
 * right-to-left) as to reduce it to a single value.
 *
 * @param {?function(?, T, number, !Array.<T>) : R} callback
 * @param {*=} opt_initialValue
 * @return {R}
 * @this {{length: number}|Array.<T>|string}
 * @template T,R
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/reduceRight
 */
Array.prototype.reduceRight = function(callback, opt_initialValue) {};

/**
 * Available in ECMAScript 5, Mozilla 1.6+.
 * @param {?function(this:S, T, number, !Array.<T>): ?} callback
 * @param {S=} opt_thisobj
 * @return {boolean}
 * @this {{length: number}|Array.<T>|string}
 * @template T,S
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/every
 */
Array.prototype.every = function(callback, opt_thisobj) {};

/**
 * Available in ECMAScript 5, Mozilla 1.6+.
 * @param {?function(this:S, T, number, !Array.<T>): ?} callback
 * @param {S=} opt_thisobj
 * @return {!Array.<T>}
 * @this {{length: number}|Array.<T>|string}
 * @template T,S
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/filter
 */
Array.prototype.filter = function(callback, opt_thisobj) {};

/**
 * Available in ECMAScript 5, Mozilla 1.6+.
 * @param {?function(this:S, T, number, !Array.<T>): ?} callback
 * @param {S=} opt_thisobj
 * @this {{length: number}|Array.<T>|string}
 * @template T,S
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/forEach
 */
Array.prototype.forEach = function(callback, opt_thisobj) {};

/**
 * Available in ECMAScript 5, Mozilla 1.6+.
 * @param {T} obj
 * @param {number=} opt_fromIndex
 * @return {number}
 * @this {{length: number}|Array.<T>|string}
 * @nosideeffects
 * @template T
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/indexOf
 */
Array.prototype.indexOf = function(obj, opt_fromIndex) {};

/**
 * Available in ECMAScript 5, Mozilla 1.6+.
 * @param {T} obj
 * @param {number=} opt_fromIndex
 * @return {number}
 * @this {{length: number}|Array.<T>|string}
 * @nosideeffects
 * @template T
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/lastIndexOf
 */
Array.prototype.lastIndexOf = function(obj, opt_fromIndex) {};

/**
 * Available in ECMAScript 5, Mozilla 1.6+.
 * @param {?function(this:S, T, number, !Array.<T>): R} callback
 * @param {S=} opt_thisobj
 * @return {!Array.<R>}
 * @this {{length: number}|Array.<T>|string}
 * @template T,S,R
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/map
 */
Array.prototype.map = function(callback, opt_thisobj) {};

/**
 * Available in ECMAScript 5, Mozilla 1.6+.
 * @param {?function(this:S, T, number, !Array.<T>): ?} callback
 * @param {S=} opt_thisobj
 * @return {boolean}
 * @this {{length: number}|Array.<T>|string}
 * @template T,S
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/some
 */
Array.prototype.some = function(callback, opt_thisobj) {};

/**
 * @type {number}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/index
 */
Array.prototype.index;

/**
 * @type {?string}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/input
 */
Array.prototype.input;

/**
 * @type {number}
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/length
 */
Array.prototype.length;

/**
 * @param {{length: number}|Array.<T>} arr
 * @param {?function(this:S, T, number, ?) : ?} callback
 * @param {S=} opt_context
 * @return {boolean}
 * @template T,S
 */
Array.every = function(arr, callback, opt_context) {};

/**
 * @param {{length: number}|Array.<T>} arr
 * @param {?function(this:S, T, number, ?) : ?} callback
 * @param {S=} opt_context
 * @return {!Array.<T>}
 * @template T,S
 */
Array.filter = function(arr, callback, opt_context) {};

/**
 * @param {{length: number}|Array.<T>} arr
 * @param {?function(this:S, T, number, ?) : ?} callback
 * @param {S=} opt_context
 * @template T,S
 */
Array.forEach = function(arr, callback, opt_context) {};

/**
 * Mozilla 1.6+ only.
 * @param {{length: number}|Array.<T>} arr
 * @param {T} obj
 * @param {number=} opt_fromIndex
 * @return {number}
 * @template T
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/indexOf
 */
Array.indexOf = function(arr, obj, opt_fromIndex) {};

/**
 * Mozilla 1.6+ only.
 * @param {{length: number}|Array.<T>} arr
 * @param {T} obj
 * @param {number=} opt_fromIndex
 * @return {number}
 * @template T
 * @nosideeffects
 * @see http://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/lastIndexOf
 */
Array.lastIndexOf = function(arr, obj, opt_fromIndex) {};

/**
 * @param {{length: number}|Array.<T>} arr
 * @param {?function(this:S, T, number, !Array.<T>): R} callback
 * @param {S=} opt_context
 * @return {!Array.<R>}
 * @template T,S,R
 */
Array.map = function(arr, callback, opt_context) {};

/**
 * @param {{length: number}|Array.<T>} arr
 * @param {?function(this:S, T, number, ?) : ?} callback
 * @param {S=} opt_context
 * @return {boolean}
 * @template T,S
 */
Array.some = function(arr, callback, opt_context) {};

/**
 * Introduced in 1.8.5.
 * @param {*} arr
 * @return {boolean}
 * @see http://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/isArray
 */
Array.isArray = function(arr) {};

/** @externs */

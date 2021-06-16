/*
 * Copyright 2014 The Closure Compiler Authors
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
 * @fileoverview Definitions for ECMAScript 6 and later.
 * @see https://tc39.github.io/ecma262/
 * @see https://www.khronos.org/registry/typedarray/specs/latest/
 * @externs
 */



/**
 * @constructor
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Generator
 * @implements {IteratorIterable<VALUE>}
 * @template VALUE
 */
function Generator() {}

/**
 * @param {?=} opt_value
 * @return {!IIterableResult<VALUE>}
 * @override
 */
Generator.prototype.next = function(opt_value) {};

/**
 * @param {VALUE} value
 * @return {!IIterableResult<VALUE>}
 */
Generator.prototype.return = function(value) {};

/**
 * @param {?} exception
 * @return {!IIterableResult<VALUE>}
 */
Generator.prototype.throw = function(exception) {};


// TODO(johnlenz): Array and Arguments should be Iterable.



/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.log10 = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.log2 = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.log1p = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.expm1 = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.cosh = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.sinh = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.tanh = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.acosh = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.asinh = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.atanh = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.trunc = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.sign = function(value) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 */
Math.cbrt = function(value) {};

/**
 * @param {number} value1
 * @param {...number} var_args
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/hypot
 */
Math.hypot = function(value1, var_args) {};

/**
 * @param {number} value1
 * @param {number} value2
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/imul
 */
Math.imul = function(value1, value2) {};

/**
 * @param {number} value
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/clz32
 */
Math.clz32 = function(value) {};


/**
 * @param {*} a
 * @param {*} b
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is
 */
Object.is;


/**
 * Returns a language-sensitive string representation of this number.
 * @param {(string|!Array<string>)=} opt_locales
 * @param {Object=} opt_options
 * @return {string}
 * @nosideeffects
 * @see https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number/toLocaleString
 * @see http://www.ecma-international.org/ecma-402/1.0/#sec-13.2.1
 * @override
 */
Number.prototype.toLocaleString = function(opt_locales, opt_options) {};


/**
 * Repeats the string the given number of times.
 *
 * @param {number} count The number of times the string is repeated.
 * @this {String|string}
 * @return {string}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/repeat
 */
String.prototype.repeat = function(count) {};

/**
 * @constructor
 * @extends {Array<string>}
 * @see https://262.ecma-international.org/6.0/#sec-gettemplateobject
 */
var ITemplateArray = function() {};

/**
 * @type {!Array<string>}
 */
ITemplateArray.prototype.raw;

/**
 * @param {!ITemplateArray} template
 * @param {...*} var_args Substitution values.
 * @return {string}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/raw
 */
String.raw = function(template, var_args) {};


/**
 * @param {number} codePoint
 * @param {...number} var_args Additional codepoints
 * @return {string}
 */
String.fromCodePoint = function(codePoint, var_args) {};


/**
 * @param {number} index
 * @return {number}
 * @nosideeffects
 */
String.prototype.codePointAt = function(index) {};


/**
 * @param {string=} opt_form
 * @return {string}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize
 */
String.prototype.normalize = function(opt_form) {};


/**
 * @param {string} searchString
 * @param {number=} opt_position
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/startsWith
 */
String.prototype.startsWith = function(searchString, opt_position) {};

/**
 * @param {string} searchString
 * @param {number=} opt_position
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/endsWith
 */
String.prototype.endsWith = function(searchString, opt_position) {};

/**
 * @param {string} searchString
 * @param {number=} opt_position
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/includes
 */
String.prototype.includes = function(searchString, opt_position) {};


/**
 * @see http://dev.w3.org/html5/postmsg/
 * @interface
 */
function Transferable() {}

/**
 * @param {number} length The length in bytes
 * @constructor
 * @noalias
 * @throws {Error}
 * @implements {Transferable}
 */
function ArrayBuffer(length) {}

/** @type {number} */
ArrayBuffer.prototype.byteLength;

/**
 * @param {number} begin
 * @param {number=} opt_end
 * @return {!ArrayBuffer}
 * @nosideeffects
 */
ArrayBuffer.prototype.slice = function(begin, opt_end) {};

/**
 * @param {*} arg
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer/isView
 */
ArrayBuffer.isView = function(arg) {};


/**
 * @constructor
 * @noalias
 */
function ArrayBufferView() {}

/** @type {!ArrayBuffer} */
ArrayBufferView.prototype.buffer;

/** @type {number} */
ArrayBufferView.prototype.byteOffset;

/** @type {number} */
ArrayBufferView.prototype.byteLength;


/**
 * @typedef {!ArrayBuffer|!ArrayBufferView}
 */
var BufferSource;


/**
 * @constructor
 * @implements {IArrayLike<number>}
 * @implements {Iterable<number>}
 * @extends {ArrayBufferView}
 */
function TypedArray() {};

/** @const {number} */
TypedArray.prototype.BYTES_PER_ELEMENT;

/**
 * @param {number} target
 * @param {number} start
 * @param {number=} opt_end
 * @return {THIS}
 * @this {THIS}
 * @template THIS
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/copyWithin
 */
TypedArray.prototype.copyWithin = function(target, start, opt_end) {};

/**
 * @return {!IteratorIterable<!Array<number>>}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/entries
 */
TypedArray.prototype.entries = function() {};

/**
 * @param {function(this:S, number, number, !TypedArray) : ?} callback
 * @param {S=} opt_thisArg
 * @return {boolean}
 * @template S
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/every
 */
TypedArray.prototype.every = function(callback, opt_thisArg) {};

/**
 * @param {number} value
 * @param {number=} opt_begin
 * @param {number=} opt_end
 * @return {THIS}
 * @this {THIS}
 * @template THIS
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/fill
 */
TypedArray.prototype.fill = function(value, opt_begin, opt_end) {};

/**
 * @param {function(this:S, number, number, !TypedArray) : boolean} callback
 * @param {S=} opt_thisArg
 * @return {THIS}
 * @this {THIS}
 * @template THIS,S
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/filter
 */
TypedArray.prototype.filter = function(callback, opt_thisArg) {};

/**
 * @param {function(this:S, number, number, !TypedArray) : boolean} callback
 * @param {S=} opt_thisArg
 * @return {(number|undefined)}
 * @template S
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/find
 */
TypedArray.prototype.find = function(callback, opt_thisArg) {};

/**
 * @param {function(this:S, number, number, !TypedArray) : boolean} callback
 * @param {S=} opt_thisArg
 * @return {number}
 * @template S
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/findIndex
 */
TypedArray.prototype.findIndex = function(callback, opt_thisArg) {};

/**
 * @param {function(this:S, number, number, !TypedArray) : ?} callback
 * @param {S=} opt_thisArg
 * @return {undefined}
 * @template S
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/forEach
 */
TypedArray.prototype.forEach = function(callback, opt_thisArg) {};

/**
 * @param {number} searchElement
 * @param {number=} opt_fromIndex
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/includes
 */
TypedArray.prototype.includes = function(searchElement, opt_fromIndex) {};

/**
 * @param {number} searchElement
 * @param {number=} opt_fromIndex
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/indexOf
 */
TypedArray.prototype.indexOf = function(searchElement, opt_fromIndex) {};

/**
 * @param {string=} opt_separator
 * @return {string}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/join
 */
TypedArray.prototype.join = function(opt_separator) {};

/**
 * @return {!IteratorIterable<number>}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/keys
 */
TypedArray.prototype.keys = function() {};

/**
 * @param {number} searchElement
 * @param {number=} opt_fromIndex
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/lastIndexOf
 */
TypedArray.prototype.lastIndexOf = function(searchElement, opt_fromIndex) {};

/** @type {number} */
TypedArray.prototype.length;

/**
 * @param {function(this:S, number, number, !TypedArray) : number} callback
 * @param {S=} opt_thisArg
 * @return {THIS}
 * @this {THIS}
 * @template THIS,S
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/map
 */
TypedArray.prototype.map = function(callback, opt_thisArg) {};

/**
 * @param {function((number|INIT|RET), number, number, !TypedArray) : RET} callback
 * @param {INIT=} opt_initialValue
 * @return {RET}
 * @template INIT,RET
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/reduce
 */
TypedArray.prototype.reduce = function(callback, opt_initialValue) {};

/**
 * @param {function((number|INIT|RET), number, number, !TypedArray) : RET} callback
 * @param {INIT=} opt_initialValue
 * @return {RET}
 * @template INIT,RET
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/reduceRight
 */
TypedArray.prototype.reduceRight = function(callback, opt_initialValue) {};

/**
 * @return {THIS}
 * @this {THIS}
 * @template THIS
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/reverse
 */
TypedArray.prototype.reverse = function() {};

/**
 * @param {!ArrayBufferView|!Array<number>} array
 * @param {number=} opt_offset
 * @return {undefined}
 * @throws {!RangeError}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/set
 */
TypedArray.prototype.set = function(array, opt_offset) {};

/**
 * @param {number=} opt_begin
 * @param {number=} opt_end
 * @return {THIS}
 * @this {THIS}
 * @template THIS
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/slice
 */
TypedArray.prototype.slice = function(opt_begin, opt_end) {};

/**
 * @param {function(this:S, number, number, !TypedArray) : boolean} callback
 * @param {S=} opt_thisArg
 * @return {boolean}
 * @template S
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/some
 */
TypedArray.prototype.some = function(callback, opt_thisArg) {};

/**
 * @param {(function(number, number) : number)=} opt_compareFunction
 * @return {THIS}
 * @this {THIS}
 * @template THIS
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/sort
 */
TypedArray.prototype.sort = function(opt_compareFunction) {};

/**
 * @param {number} begin
 * @param {number=} opt_end
 * @return {THIS}
 * @this {THIS}
 * @template THIS
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/subarray
 */
TypedArray.prototype.subarray = function(begin, opt_end) {};

/**
 * @return {!IteratorIterable<number>}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/values
 */
TypedArray.prototype.values = function() {};

/**
 * @return {string}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/toLocaleString
 * @override
 */
TypedArray.prototype.toLocaleString = function() {};

/**
 * @return {string}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/toString
 * @override
 */
TypedArray.prototype.toString = function() {};

/** @override */
TypedArray.prototype[Symbol.iterator] = function() {};

/**
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer} length or array
 *     or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @noalias
 * @throws {Error}
 * @modifies {arguments} If the user passes a backing array, then indexed
 *     accesses will modify the backing array. JSCompiler does not model
 *     this well. In other words, if you have:
 *     <code>
 *     var x = new ArrayBuffer(1);
 *     var y = new Int8Array(x);
 *     y[0] = 2;
 *     </code>
 *     JSCompiler will not recognize that the last assignment modifies x.
 *     We workaround this by marking all these arrays as @modifies {arguments},
 *     to introduce the possibility that x aliases y.
 */
function Int8Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Int8Array.BYTES_PER_ELEMENT;

/**
 * @param {!Array<number>} source
 * @param {function(this:S, number): number=} opt_mapFn
 * @param {S=} opt_this
 * @template S
 * @return {!Int8Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
Int8Array.from = function(source, opt_mapFn, opt_this) {};

/**
 * @param {...number} var_args
 * @return {!Int8Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
Int8Array.of = function(var_args) {};


/**
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer} length or array
 *     or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @noalias
 * @throws {Error}
 * @modifies {arguments}
 */
function Uint8Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Uint8Array.BYTES_PER_ELEMENT;

/**
 * @param {!Array<number>} source
 * @param {function(this:S, number): number=} opt_mapFn
 * @param {S=} opt_this
 * @template S
 * @return {!Uint8Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
Uint8Array.from = function(source, opt_mapFn, opt_this) {};

/**
 * @param {...number} var_args
 * @return {!Uint8Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
Uint8Array.of = function(var_args) {};


/**
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer} length or array
 *     or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @noalias
 * @throws {Error}
 * @modifies {arguments}
 */
function Uint8ClampedArray(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Uint8ClampedArray.BYTES_PER_ELEMENT;

/**
 * @param {!Array<number>} source
 * @param {function(this:S, number): number=} opt_mapFn
 * @param {S=} opt_this
 * @template S
 * @return {!Uint8ClampedArray}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
Uint8ClampedArray.from = function(source, opt_mapFn, opt_this) {};

/**
 * @param {...number} var_args
 * @return {!Uint8ClampedArray}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
Uint8ClampedArray.of = function(var_args) {};


/**
 * @typedef {Uint8ClampedArray}
 * @deprecated CanvasPixelArray has been replaced by Uint8ClampedArray
 *     in the latest spec.
 * @see http://www.w3.org/TR/2dcontext/#imagedata
 */
var CanvasPixelArray;


/**
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer} length or array
 *     or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @noalias
 * @throws {Error}
 * @modifies {arguments}
 */
function Int16Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Int16Array.BYTES_PER_ELEMENT;

/**
 * @param {!Array<number>} source
 * @param {function(this:S, number): number=} opt_mapFn
 * @param {S=} opt_this
 * @template S
 * @return {!Int16Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
Int16Array.from = function(source, opt_mapFn, opt_this) {};

/**
 * @param {...number} var_args
 * @return {!Int16Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
Int16Array.of = function(var_args) {};


/**
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer} length or array
 *     or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @noalias
 * @throws {Error}
 * @modifies {arguments}
 */
function Uint16Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Uint16Array.BYTES_PER_ELEMENT;

/**
 * @param {!Array<number>} source
 * @param {function(this:S, number): number=} opt_mapFn
 * @param {S=} opt_this
 * @template S
 * @return {!Uint16Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
Uint16Array.from = function(source, opt_mapFn, opt_this) {};

/**
 * @param {...number} var_args
 * @return {!Uint16Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
Uint16Array.of = function(var_args) {};


/**
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer} length or array
 *     or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @noalias
 * @throws {Error}
 * @modifies {arguments}
 */
function Int32Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Int32Array.BYTES_PER_ELEMENT;

/**
 * @param {!Array<number>} source
 * @param {function(this:S, number): number=} opt_mapFn
 * @param {S=} opt_this
 * @template S
 * @return {!Int32Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
Int32Array.from = function(source, opt_mapFn, opt_this) {};

/**
 * @param {...number} var_args
 * @return {!Int32Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
Int32Array.of = function(var_args) {};


/**
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer} length or array
 *     or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @noalias
 * @throws {Error}
 * @modifies {arguments}
 */
function Uint32Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Uint32Array.BYTES_PER_ELEMENT;

/**
 * @param {!Array<number>} source
 * @param {function(this:S, number): number=} opt_mapFn
 * @param {S=} opt_this
 * @template S
 * @return {!Uint32Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
Uint32Array.from = function(source, opt_mapFn, opt_this) {};

/**
 * @param {...number} var_args
 * @return {!Uint32Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
Uint32Array.of = function(var_args) {};


/**
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer} length or array
 *     or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @noalias
 * @throws {Error}
 * @modifies {arguments}
 */
function Float32Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Float32Array.BYTES_PER_ELEMENT;

/**
 * @param {!Array<number>} source
 * @param {function(this:S, number): number=} opt_mapFn
 * @param {S=} opt_this
 * @template S
 * @return {!Float32Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
Float32Array.from = function(source, opt_mapFn, opt_this) {};

/**
 * @param {...number} var_args
 * @return {!Float32Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
Float32Array.of = function(var_args) {};


/**
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer} length or array
 *     or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @noalias
 * @throws {Error}
 * @modifies {arguments}
 */
function Float64Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Float64Array.BYTES_PER_ELEMENT;

/**
 * @param {!Array<number>} source
 * @param {function(this:S, number): number=} opt_mapFn
 * @param {S=} opt_this
 * @template S
 * @return {!Float64Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
Float64Array.from = function(source, opt_mapFn, opt_this) {};

/**
 * @param {...number} var_args
 * @return {!Float64Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
Float64Array.of = function(var_args) {};


/**
 * @param {ArrayBuffer} buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_byteLength
 * @constructor
 * @extends {ArrayBufferView}
 * @noalias
 * @throws {Error}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Typed_arrays/DataView
 */
function DataView(buffer, opt_byteOffset, opt_byteLength) {}

/**
 * @param {number} byteOffset
 * @return {number}
 * @throws {Error}
 */
DataView.prototype.getInt8 = function(byteOffset) {};

/**
 * @param {number} byteOffset
 * @return {number}
 * @throws {Error}
 */
DataView.prototype.getUint8 = function(byteOffset) {};

/**
 * @param {number} byteOffset
 * @param {boolean=} opt_littleEndian
 * @return {number}
 * @throws {Error}
 */
DataView.prototype.getInt16 = function(byteOffset, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {boolean=} opt_littleEndian
 * @return {number}
 * @throws {Error}
 */
DataView.prototype.getUint16 = function(byteOffset, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {boolean=} opt_littleEndian
 * @return {number}
 * @throws {Error}
 */
DataView.prototype.getInt32 = function(byteOffset, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {boolean=} opt_littleEndian
 * @return {number}
 * @throws {Error}
 */
DataView.prototype.getUint32 = function(byteOffset, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {boolean=} opt_littleEndian
 * @return {number}
 * @throws {Error}
 */
DataView.prototype.getFloat32 = function(byteOffset, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {boolean=} opt_littleEndian
 * @return {number}
 * @throws {Error}
 */
DataView.prototype.getFloat64 = function(byteOffset, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {number} value
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setInt8 = function(byteOffset, value) {};

/**
 * @param {number} byteOffset
 * @param {number} value
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setUint8 = function(byteOffset, value) {};

/**
 * @param {number} byteOffset
 * @param {number} value
 * @param {boolean=} opt_littleEndian
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setInt16 = function(byteOffset, value, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {number} value
 * @param {boolean=} opt_littleEndian
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setUint16 = function(byteOffset, value, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {number} value
 * @param {boolean=} opt_littleEndian
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setInt32 = function(byteOffset, value, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {number} value
 * @param {boolean=} opt_littleEndian
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setUint32 = function(byteOffset, value, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {number} value
 * @param {boolean=} opt_littleEndian
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setFloat32 = function(
    byteOffset, value, opt_littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {number} value
 * @param {boolean=} opt_littleEndian
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setFloat64 = function(
    byteOffset, value, opt_littleEndian) {};


/**
 * @see https://github.com/promises-aplus/promises-spec
 * @typedef {{then: ?}}
 */
var Thenable;


/**
 * This is not an official DOM interface. It is used to add generic typing
 * and respective type inference where available.
 * {@see goog.Thenable} inherits from this making all promises
 * interoperate.
 * @interface
 * @template TYPE
 */
function IThenable() {}


/**
 * @param {?(function(TYPE):VALUE)=} opt_onFulfilled
 * @param {?(function(*): *)=} opt_onRejected
 * @return {RESULT}
 * @template VALUE
 *
 * When a Promise (or thenable) is returned from the fulfilled callback,
 * the result is the payload of that promise, not the promise itself.
 *
 * @template RESULT := type('IThenable',
 *     cond(isUnknown(VALUE), unknown(),
 *       mapunion(VALUE, (V) =>
 *         cond(isTemplatized(V) && sub(rawTypeOf(V), 'IThenable'),
 *           templateTypeOf(V, 0),
 *           cond(sub(V, 'Thenable'),
 *              unknown(),
 *              V)))))
 * =:
 */
IThenable.prototype.then = function(opt_onFulfilled, opt_onRejected) {};


/**
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
 * @param {function(
 *             function((TYPE|IThenable<TYPE>|Thenable|null)=),
 *             function(*=))} resolver
 * @constructor
 * @implements {IThenable<TYPE>}
 * @template TYPE
 */
function Promise(resolver) {}


/**
 * @param {VALUE=} opt_value
 * @return {RESULT}
 * @template VALUE
 * @template RESULT := type('Promise',
 *     cond(isUnknown(VALUE), unknown(),
 *       mapunion(VALUE, (V) =>
 *         cond(isTemplatized(V) && sub(rawTypeOf(V), 'IThenable'),
 *           templateTypeOf(V, 0),
 *           cond(sub(V, 'Thenable'),
 *              unknown(),
 *              V)))))
 * =:
 */
Promise.resolve = function(opt_value) {};


/**
 * @param {*=} opt_error
 * @return {!Promise<?>}
 */
Promise.reject = function(opt_error) {};


/**
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
 * @param {!Iterable<VALUE>} iterable
 * @return {!Promise<!Array<RESULT>>}
 * @template VALUE
 * @template RESULT := mapunion(VALUE, (V) =>
 *     cond(isUnknown(V),
 *         unknown(),
 *         cond(isTemplatized(V) && sub(rawTypeOf(V), 'IThenable'),
 *             templateTypeOf(V, 0),
 *             cond(sub(V, 'Thenable'), unknown(), V))))
 * =:
 */
Promise.all = function(iterable) {};


/**
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
 * @param {!Iterable<VALUE>} iterable
 * @return {!Promise<RESULT>}
 * @template VALUE
 * @template RESULT := mapunion(VALUE, (V) =>
 *     cond(isUnknown(V),
 *         unknown(),
 *         cond(isTemplatized(V) && sub(rawTypeOf(V), 'IThenable'),
 *             templateTypeOf(V, 0),
 *             cond(sub(V, 'Thenable'), unknown(), V))))
 * =:
 */
Promise.race = function(iterable) {};


/**
 * @param {?(function(this:void, TYPE):VALUE)=} opt_onFulfilled
 * @param {?(function(this:void, *): *)=} opt_onRejected
 * @return {RESULT}
 * @template VALUE
 *
 * When a Promise (or thenable) is returned from the fulfilled callback,
 * the result is the payload of that promise, not the promise itself.
 *
 * @template RESULT := type('Promise',
 *     cond(isUnknown(VALUE), unknown(),
 *       mapunion(VALUE, (V) =>
 *         cond(isTemplatized(V) && sub(rawTypeOf(V), 'IThenable'),
 *           templateTypeOf(V, 0),
 *           cond(sub(V, 'Thenable'),
 *              unknown(),
 *              V)))))
 * =:
 * @override
 */
Promise.prototype.then = function(opt_onFulfilled, opt_onRejected) {};


/**
 * @param {function(*): RESULT} onRejected
 * @return {!Promise<RESULT>}
 * @template RESULT
 */
Promise.prototype.catch = function(onRejected) {};


/**
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/of
 * @param {...T} var_args
 * @return {!Array<T>}
 * @template T
 */
Array.of = function(var_args) {};


/**
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/from
 * @param {string|!IArrayLike<T>|!Iterable<T>} arrayLike
 * @param {function(this:S, (string|T), number): R=} opt_mapFn
 * @param {S=} opt_this
 * @return {!Array<R>}
 * @template T,S,R
 */
Array.from = function(arrayLike, opt_mapFn, opt_this) {};


/** @return {!IteratorIterable<number>} */
Array.prototype.keys;


/**
 * @return {!IteratorIterable<!Array<number|T>>} Iterator of [key, value] pairs.
 */
Array.prototype.entries;


/**
 * @param {!function(this:S, T, number, !Array<T>): boolean} predicate
 * @param {S=} opt_this
 * @return {T|undefined}
 * @this {IArrayLike<T>|string}
 * @template T,S
 * @see https://262.ecma-international.org/6.0/#sec-array.prototype.find
 */
Array.prototype.find = function(predicate, opt_this) {};


/**
 * @param {!function(this:S, T, number, !Array<T>): boolean} predicate
 * @param {S=} opt_this
 * @return {number}
 * @this {IArrayLike<T>|string}
 * @template T,S
 * @see https://262.ecma-international.org/6.0/#sec-array.prototype.findindex
 */
Array.prototype.findIndex = function(predicate, opt_this) {};


/**
 * @param {T} value
 * @param {number=} opt_begin
 * @param {number=} opt_end
 * @return {!IArrayLike<T>}
 * @this {!IArrayLike<T>|string}
 * @template T
 * @see https://262.ecma-international.org/6.0/#sec-array.prototype.fill
 */
Array.prototype.fill = function(value, opt_begin, opt_end) {};


/**
 * @param {number} target
 * @param {number} start
 * @param {number=} opt_end
 * @see https://262.ecma-international.org/6.0/#sec-array.prototype.copywithin
 * @template T
 * @return {!IArrayLike<T>}
 */
Array.prototype.copyWithin = function(target, start, opt_end) {};


/**
 * @param {T} searchElement
 * @param {number=} opt_fromIndex
 * @return {boolean}
 * @this {!IArrayLike<T>|string}
 * @template T
 * @see https://tc39.github.io/ecma262/#sec-array.prototype.includes
 */
Array.prototype.includes = function(searchElement, opt_fromIndex) {};


/**
 * @param {!Object} obj
 * @return {!Array<symbol>}
 * @see https://262.ecma-international.org/6.0/#sec-object.getownpropertysymbols
 */
Object.getOwnPropertySymbols = function(obj) {};


/**
 * @param {!Object} obj
 * @param {?} proto
 * @return {!Object}
 * @see https://262.ecma-international.org/6.0/#sec-object.setprototypeof
 */
Object.setPrototypeOf = function(obj, proto) {};


/**
 * @const {number}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/EPSILON
 */
Number.EPSILON;

/**
 * @const {number}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MIN_SAFE_INTEGER
 */
Number.MIN_SAFE_INTEGER;

/**
 * @const {number}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
 */
Number.MAX_SAFE_INTEGER;



/**
 * Parse an integer. Use of {@code parseInt} without {@code base} is strictly
 * banned in Google. If you really want to parse octal or hex based on the
 * leader, then pass {@code undefined} as the base.
 *
 * @param {string} string
 * @param {number|undefined} radix
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/parseInt
 */
Number.parseInt = function(string, radix) {};

/**
 * @param {string} string
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/parseFloat
 */
Number.parseFloat = function(string) {};

/**
 * @param {number} value
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isNaN
 */
Number.isNaN = function(value) {};

/**
 * @param {number} value
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isFinite
 */
Number.isFinite = function(value) {};

/**
 * @param {number} value
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isInteger
 */
Number.isInteger = function(value) {};

/**
 * @param {number} value
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isSafeInteger
 */
Number.isSafeInteger = function(value) {};



/**
 * @param {!Object} target
 * @param {...Object} var_args
 * @return {!Object}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/assign
 */
Object.assign = function(target, var_args) {};

/**
 * TODO(dbeam): find a better place for ES2017 externs like this one.
 * @param {!Object<T>} obj
 * @return {!Array<T>} values
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/values
 * @throws {Error}
 * @template T
 */
Object.values = function(obj) {};

/**
 * @param {!Object<T>} obj
 * @return {!Array<!Array<(string|T)>>} entries
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/entries
 * @throws {Error}
 * @template T
 */
Object.entries = function(obj) {};



/**
 * @const
 * @see http://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect
 */
var Reflect = {};

/**
 * @param {function(this: THIS, ...?): RESULT} target
 * @param {THIS} thisArg
 * @param {!Array} argList
 * @return {RESULT}
 * @template THIS, RESULT
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/apply
 */
Reflect.apply = function(target, thisArg, argList) {};

/**
 * @param {function(new: ?, ...?)} target
 * @param {!Array} argList
 * @param {function(new: TARGET, ...?)=} opt_newTarget
 * @return {TARGET}
 * @template TARGET
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/construct
 */
Reflect.construct = function(target, argList, opt_newTarget) {};

/**
 * @param {!Object} target
 * @param {string} propertyKey
 * @param {!Object} attributes
 * @return {boolean}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/defineProperty
 */
Reflect.defineProperty = function(target, propertyKey, attributes) {};

/**
 * @param {!Object} target
 * @param {string} propertyKey
 * @return {boolean}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/deleteProperty
 */
Reflect.deleteProperty = function(target, propertyKey) {};

/**
 * @param {!Object} target
 * @param {string} propertyKey
 * @param {!Object=} opt_receiver
 * @return {*}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/get
 */
Reflect.get = function(target, propertyKey, opt_receiver) {};

/**
 * @param {!Object} target
 * @param {string} propertyKey
 * @return {?ObjectPropertyDescriptor}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/getOwnPropertyDescriptor
 */
Reflect.getOwnPropertyDescriptor = function(target, propertyKey) {};

/**
 * @param {!Object} target
 * @return {?Object}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/getPrototypeOf
 */
Reflect.getPrototypeOf = function(target) {};

/**
 * @param {!Object} target
 * @param {string} propertyKey
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/has
 */
Reflect.has = function(target, propertyKey) {};

/**
 * @param {!Object} target
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/isExtensible
 */
Reflect.isExtensible = function(target) {};

/**
 * @param {!Object} target
 * @return {!Array<(string|symbol)>}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/ownKeys
 */
Reflect.ownKeys = function(target) {};

/**
 * @param {!Object} target
 * @return {boolean}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/preventExtensions
 */
Reflect.preventExtensions = function(target) {};

/**
 * @param {!Object} target
 * @param {string} propertyKey
 * @param {*} value
 * @param {!Object=} opt_receiver
 * @return {boolean}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/set
 */
Reflect.set = function(target, propertyKey, value, opt_receiver) {};

/**
 * @param {!Object} target
 * @param {?Object} proto
 * @return {boolean}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/setPrototypeOf
 */
Reflect.setPrototypeOf = function(target, proto) {};

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
 * Some es6 definitions:
 * Symbol, IIterableResult, Iterable, IteratorIterable, Iterator,
 * IteratorIterable moved to es3 file, because some base type requires them, and
 * we want to keep them together. If you add new externs related to those types
 * define them together in the es3 file.
 */

/**
 * TODO(b/142881197): UNUSED_RETURN_T and UNUSED_NEXT_T are not yet used for
 * anything. https://github.com/google/closure-compiler/issues/3489
 * @interface
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Generator
 * @extends {IteratorIterable<VALUE>}
 * @template VALUE, UNUSED_RETURN_T, UNUSED_NEXT_T
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
 * @param {...number} var_args
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/hypot
 */
Math.hypot = function(var_args) {};

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
 * @param {number} value
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/fround
 */
Math.fround = function(value) {};


/**
 * @param {*} a
 * @param {*} b
 * @return {boolean}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is
 */
Object.is = function(a, b) {};


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
 * Returns the wrapped primitive value of this Number object.
 * @return {number}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/valueOf
 * @override
 */
Number.prototype.valueOf = function() {};


/**
 * Pads the end of the string so that it reaches the given length.
 * NOTE: this is an ES2017 (ES8) extern.
 *
 * @param {number} targetLength The target length.
 * @param {string=} opt_padString The string to pad with.
 * @this {String|string}
 * @return {string}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padEnd
 */
String.prototype.padEnd = function(targetLength, opt_padString) {};

/**
 * Pads the start of the string so that it reaches the given length.
 * NOTE: this is an ES2017 (ES8) extern.
 *
 * @param {number} targetLength The target length.
 * @param {string=} opt_padString The string to pad with.
 * @this {String|string}
 * @return {string}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padStart
 */
String.prototype.padStart = function(targetLength, opt_padString) {};

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
 * @see http://www.ecma-international.org/ecma-262/6.0/#sec-gettemplateobject
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
 * @this {String|string}
 * @return {string}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/trimStart
 */
String.prototype.trimStart = function() {};


/**
 * @this {String|string}
 * @return {string}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/trimEnd
 */
String.prototype.trimEnd = function() {};


/**
 * @this {String|string}
 * @param {!RegExp|string} regexp
 * @return {!IteratorIterable<!RegExpResult>}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/matchAll
 */
String.prototype.matchAll = function(regexp) {};


/**
 * @see http://dev.w3.org/html5/postmsg/
 * @interface
 */
function Transferable() {}

/**
 * @param {number} length The length in bytes
 * @constructor
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
 */
function ArrayBufferView() {}

/** @type {!ArrayBuffer} */
ArrayBufferView.prototype.buffer;

/** @type {number} */
ArrayBufferView.prototype.byteOffset;

/** @type {number} */
ArrayBufferView.prototype.byteLength;


/**
 * @param {number} length The length in bytes
 * @constructor
 * @throws {Error}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer
 */
function SharedArrayBuffer(length) {}

/** @type {number} */
SharedArrayBuffer.prototype.byteLength;

/**
 * @param {number} begin
 * @param {number=} opt_end
 * @return {!SharedArrayBuffer}
 * @nosideeffects
 */
SharedArrayBuffer.prototype.slice = function(begin, opt_end) {};


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
 * NOTE: this is an ES2016 (ES7) extern.
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
 * @param {function((number|INIT|RET), number, number, !TypedArray) : RET}
 *     callback
 * @param {INIT=} opt_initialValue
 * @return {RET}
 * @template INIT,RET
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/reduce
 */
TypedArray.prototype.reduce = function(callback, opt_initialValue) {};

/**
 * @param {function((number|INIT|RET), number, number, !TypedArray) : RET}
 *     callback
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
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer|SharedArrayBuffer}
 *     length or array or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
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
 * @param {string|!IArrayLike<number>|!Iterable<number>} source
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
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer|SharedArrayBuffer}
 *     length or array or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function Uint8Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Uint8Array.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<number>|!Iterable<number>} source
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
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer|SharedArrayBuffer}
 *     length or array or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function Uint8ClampedArray(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Uint8ClampedArray.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<number>|!Iterable<number>} source
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
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer|SharedArrayBuffer}
 *     length or array or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function Int16Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Int16Array.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<number>|!Iterable<number>} source
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
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer|SharedArrayBuffer}
 *     length or array or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function Uint16Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Uint16Array.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<number>|!Iterable<number>} source
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
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer|SharedArrayBuffer}
 *     length or array or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function Int32Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Int32Array.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<number>|!Iterable<number>} source
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
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer|SharedArrayBuffer}
 *     length or array or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function Uint32Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Uint32Array.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<number>|!Iterable<number>} source
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
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer|SharedArrayBuffer}
 *     length or array or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function Float32Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Float32Array.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<number>|!Iterable<number>} source
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
 * @param {number|ArrayBufferView|Array<number>|ArrayBuffer|SharedArrayBuffer}
 *     length or array or buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_length
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function Float64Array(length, opt_byteOffset, opt_length) {}

/** @const {number} */
Float64Array.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<number>|!Iterable<number>} source
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
 * @param {number|ArrayBufferView|Array<bigint>|ArrayBuffer|SharedArrayBuffer}
 *     lengthOrArrayOrBuffer
 * @param {number=} byteOffset
 * @param {number=} bufferLength
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function BigInt64Array(lengthOrArrayOrBuffer, byteOffset, bufferLength) {}

/** @const {number} */
BigInt64Array.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<bigint>|!Iterable<bigint>} source
 * @param {function(this:S, bigint): bigint=} mapFn
 * @param {S=} thisArg
 * @template S
 * @return {!BigInt64Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
BigInt64Array.from = function(source, mapFn, thisArg) {};

/**
 * @param {...bigint} var_args
 * @return {!BigInt64Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
BigInt64Array.of = function(var_args) {};


/**
 * @param {number|ArrayBufferView|Array<bigint>|ArrayBuffer|SharedArrayBuffer}
 *     lengthOrArrayOrBuffer
 * @param {number=} byteOffset
 * @param {number=} bufferLength
 * @constructor
 * @extends {TypedArray}
 * @throws {Error}
 * @modifies {arguments}
 */
function BigUint64Array(lengthOrArrayOrBuffer, byteOffset, bufferLength) {}

/** @const {number} */
BigUint64Array.BYTES_PER_ELEMENT;

/**
 * @param {string|!IArrayLike<bigint>|!Iterable<bigint>} source
 * @param {function(this:S, bigint): bigint=} mapFn
 * @param {S=} thisArg
 * @template S
 * @return {!BigUint64Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
 */
BigUint64Array.from = function(source, mapFn, thisArg) {};

/**
 * @param {...bigint} var_args
 * @return {!BigUint64Array}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/of
 */
BigUint64Array.of = function(var_args) {};

/**
 * @param {ArrayBuffer|SharedArrayBuffer} buffer
 * @param {number=} opt_byteOffset
 * @param {number=} opt_byteLength
 * @constructor
 * @extends {ArrayBufferView}
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
 * @param {boolean=} littleEndian
 * @return {bigint}
 * @throws {Error}
 */
DataView.prototype.getBigInt64 = function(byteOffset, littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {boolean=} littleEndian
 * @return {bigint}
 * @throws {Error}
 */
DataView.prototype.getBigUint64 = function(byteOffset, littleEndian) {};

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
 * @param {number} byteOffset
 * @param {bigint} value
 * @param {boolean=} littleEndian
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setBigInt64 = function(byteOffset, value, littleEndian) {};

/**
 * @param {number} byteOffset
 * @param {bigint} value
 * @param {boolean=} littleEndian
 * @throws {Error}
 * @return {undefined}
 */
DataView.prototype.setBigUint64 = function(byteOffset, value, littleEndian) {};


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
 * @struct
 * @template TYPE
 */
function IThenable() {}


/**
 * @param {?(function(TYPE):VALUE)=} opt_onFulfilled
 * @param {?(function(*): *)=} opt_onRejected
 * @return {RESULT}
 * @template VALUE
 *
 * When a `Thenable` is fulfilled or rejected with another `Thenable`, the
 * payload of the second is used as the payload of the first.
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
 * Record type representing a single element of the array value one gets from
 * Promise.allSettled.
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled
 * @record
 * @template VALUE
 */
Promise.AllSettledResultElement = function() {};

/**
 * 'fulfilled' or 'rejected' to indicate the final state of the corresponding
 * Promise.
 * @type {string}
 */
Promise.AllSettledResultElement.prototype.status;

/**
 * Exists only if the status field is 'fulfilled'
 * @type {VALUE|undefined}
 */
Promise.AllSettledResultElement.prototype.value;

/**
 * Exists only if the status field is 'rejected'
 * @type {*|undefined}
 */
Promise.AllSettledResultElement.prototype.reason;

/**
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled
 * @param {!Iterable<VALUE>} iterable
 * @return {!Promise<!Array<!Promise.AllSettledResultElement<RESULT>>>}
 * @template VALUE
 * @template RESULT := mapunion(VALUE, (V) =>
 *     cond(isUnknown(V),
 *         unknown(),
 *         cond(isTemplatized(V) && sub(rawTypeOf(V), 'IThenable'),
 *             templateTypeOf(V, 0),
 *             cond(sub(V, 'Thenable'), unknown(), V))))
 * =:
 */
Promise.allSettled = function(iterable) {};


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
 * When a `Thenable` is fulfilled or rejected with another `Thenable`, the
 * payload of the second is used as the payload of the first.
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
 * @param {function(*):VALUE} onRejected
 * @return {!Promise<TYPE|RESULT>} A Promise of the original type or a possibly
 *     a different type depending on whether the parent promise was rejected.
 *
 * @template VALUE
 *
 * When a `Thenable` is rejected with another `Thenable`, the payload of the
 * second is used as the payload of the first.
 *
 * @template RESULT := cond(
 *     isUnknown(VALUE),
 *     unknown(),
 *     mapunion(VALUE, (V) =>
 *         cond(
 *             isTemplatized(V) && sub(rawTypeOf(V), 'IThenable'),
 *             templateTypeOf(V, 0),
 *             cond(
 *                 sub(V, 'Thenable'),
 *                 unknown(),
 *                 V))))
 * =:
 */
Promise.prototype.catch = function(onRejected) {};


/**
 * @param {function()} callback
 * @return {!Promise<TYPE>}
 */
Promise.prototype.finally = function(callback) {};


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
 * @return {!IteratorIterable<T>}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/values
 */
Array.prototype.values;


/**
 * @return {!IteratorIterable<!Array<number|T>>} Iterator of [key, value] pairs.
 */
Array.prototype.entries;


/**
 * @param {function(this:S, T, number, !Array<T>): boolean} predicateFn
 * @param {S=} opt_this
 * @return {T|undefined}
 * @this {IArrayLike<T>|string}
 * @template T,S
 * @see http://www.ecma-international.org/ecma-262/6.0/#sec-array.prototype.find
 */
Array.prototype.find = function(predicateFn, opt_this) {};


/**
 * @param {function(this:S, T, number, !Array<T>): boolean} predicateFn
 * @param {S=} opt_this
 * @return {number}
 * @this {IArrayLike<T>|string}
 * @template T,S
 * @see http://www.ecma-international.org/ecma-262/6.0/#sec-array.prototype.findindex
 */
Array.prototype.findIndex = function(predicateFn, opt_this) {};


/**
 * @param {T} value
 * @param {number=} opt_begin
 * @param {number=} opt_end
 * @return {!Array<T>}
 * @this {!IArrayLike<T>|string}
 * @template T
 * @see http://www.ecma-international.org/ecma-262/6.0/#sec-array.prototype.fill
 */
Array.prototype.fill = function(value, opt_begin, opt_end) {};


/**
 * @param {number} target
 * @param {number} start
 * @param {number=} opt_end
 * @see http://www.ecma-international.org/ecma-262/6.0/#sec-array.prototype.copywithin
 * @this {!IArrayLike<T>|string}
 * @template T
 * @return {!Array<T>}
 */
Array.prototype.copyWithin = function(target, start, opt_end) {};


/**
 * NOTE: this is an ES2016 (ES7) extern.
 * @param {T} searchElement
 * @param {number=} opt_fromIndex
 * @return {boolean}
 * @this {!IArrayLike<T>|string}
 * @template T
 * @nosideeffects
 * @see https://tc39.github.io/ecma262/#sec-array.prototype.includes
 */
Array.prototype.includes = function(searchElement, opt_fromIndex) {};

/**
 * Generates an array by passing every element of this array to a callback that
 * returns an array of zero or more elements to be added to the result.
 *
 * NOTE: The specified behavior of the method is that the callback can return
 * either an Array, which will be flattened into the result, or a non-array,
 * which will simply be included.
 *
 * However, while defining that in the type information here is possible it's
 * very hard to understand both for humans and automated tools other than
 * closure-compiler that process these files. Also, we think it's best to
 * encourage writing callbacks that just always return an Array for the sake
 * of readability.
 *
 * The polyfill for this method provided by closure-compiler does behave as
 * defined in the specification, though.
 *
 * @param {function(this: THIS, T, number, !IArrayLike<T>): !Array<S>}
 *     callback
 * @param {THIS=} thisArg
 * @return {!Array<S>}
 * @this {!IArrayLike<T>}
 * @template T, THIS, S
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flatMap
 */
Array.prototype.flatMap = function(callback, thisArg) {};

/**
 * @param {number=} depth
 * @return {!Array<S>}
 * @this {!IArrayLike<T>}
 * @template T, S
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flat
 */
Array.prototype.flat = function(depth) {};

/**
 * @param {!Object} obj
 * @return {!Array<symbol>}
 * @see http://www.ecma-international.org/ecma-262/6.0/#sec-object.getownpropertysymbols
 */
Object.getOwnPropertySymbols = function(obj) {};


/**
 * @param {!Object} obj
 * @param {?} proto
 * @return {!Object}
 * @see http://www.ecma-international.org/ecma-262/6.0/#sec-object.setprototypeof
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
 * Parse an integer. Use of `parseInt` without `base` is strictly
 * banned in Google. If you really want to parse octal or hex based on the
 * leader, then pass `undefined` as the base.
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
 * @param {...(Object|null|undefined)} var_args
 * @return {!Object}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/assign
 */
Object.assign = function(target, var_args) {};

/**
 * TODO(dbeam): find a better place for ES2017 externs like this one.
 * NOTE: this is an ES2017 (ES8) extern.
 * @param {!Object<T>} obj
 * @return {!Array<T>} values
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/values
 * @throws {Error}
 * @template T
 */
Object.values = function(obj) {};

/**
 * NOTE: this is an ES2017 (ES8) extern.
 * @param {!Object<T>} obj
 * @return {!Array<!Array<(string|T)>>} entries
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/entries
 * @throws {Error}
 * @template T
 */
Object.entries = function(obj) {};

/**
 * @param {!Iterable<*>} iter
 * @return {!Object}
 * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/fromEntries
 */
Object.fromEntries = function(iter) {};

/**
 * NOTE: this is an ES2017 (ES8) extern.
 * @param {!Object} obj
 * @return {!Object<!ObjectPropertyDescriptor>} descriptors
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptors
 * @throws {Error}
 * @template T
 */
Object.getOwnPropertyDescriptors = function(obj) {};



/**
 * @const
 * @see http://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect
 */
var Reflect = {};

/**
 * @param {function(this: THIS, ...?): RESULT} targetFn
 * @param {THIS} thisArg
 * @param {!Array<?>} argList
 * @return {RESULT}
 * @template THIS, RESULT
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/apply
 */
Reflect.apply = function(targetFn, thisArg, argList) {};

/**
 * @param {function(new: ?, ...?)} targetConstructorFn
 * @param {!Array<?>} argList
 * @param {function(new: TARGET, ...?)=} opt_newTargetConstructorFn
 * @return {TARGET}
 * @template TARGET
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/construct
 */
Reflect.construct = function(
    targetConstructorFn, argList, opt_newTargetConstructorFn) {};

/**
 * @param {!Object} target
 * @param {string} propertyKey
 * @param {!ObjectPropertyDescriptor} attributes
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


/**
 * @const
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics
 */
var Atomics = {};

/**
 * @param {!TypedArray} typedArray
 * @param {number} index
 * @param {number} value
 * @return {number}
 */
Atomics.add = function(typedArray, index, value) {};

/**
 * @param {!TypedArray} typedArray
 * @param {number} index
 * @param {number} value
 * @return {number}
 */
Atomics.and = function(typedArray, index, value) {};

/**
 * @param {!TypedArray} typedArray
 * @param {number} index
 * @param {number} expectedValue
 * @param {number} replacementValue
 * @return {number}
 */
Atomics.compareExchange = function(
    typedArray, index, expectedValue, replacementValue) {};

/**
 * @param {!TypedArray} typedArray
 * @param {number} index
 * @param {number} value
 * @return {number}
 */
Atomics.exchange = function(typedArray, index, value) {};

/**
 * @param {number} size
 * @return {boolean}
 */
Atomics.isLockFree = function(size) {};

/**
 * @param {!TypedArray} typedArray
 * @param {number} index
 * @return {number}
 */
Atomics.load = function(typedArray, index) {};

/**
 * @param {!Int32Array} typedArray
 * @param {number} index
 * @param {number=} count
 * @return {number}
 */
Atomics.notify = function(typedArray, index, count) {};

/**
 * @param {!TypedArray} typedArray
 * @param {number} index
 * @param {number} value
 * @return {number}
 */
Atomics.or = function(typedArray, index, value) {};

/**
 * @param {!TypedArray} typedArray
 * @param {number} index
 * @param {number} value
 * @return {number}
 */
Atomics.store = function(typedArray, index, value) {};

/**
 * @param {!TypedArray} typedArray
 * @param {number} index
 * @param {number} value
 * @return {number}
 */
Atomics.sub = function(typedArray, index, value) {};

/**
 * @param {!Int32Array} typedArray
 * @param {number} index
 * @param {number} value
 * @param {number=} timeout
 * @return {String}
 */
Atomics.wait = function(typedArray, index, value, timeout) {};

/**
 * @param {!Int32Array} typedArray
 * @param {number} index
 * @param {number=} count
 * @return {number}
 */
Atomics.wake = function(typedArray, index, count) {};

/**
 * @param {!TypedArray} typedArray
 * @param {number} index
 * @param {number} value
 * @return {number}
 */
Atomics.xor = function(typedArray, index, value) {};


/**
 * TODO(b/142881197): UNUSED_RETURN_T and UNUSED_NEXT_T are not yet used for
 * anything.
 * https://github.com/google/closure-compiler/issues/3489
 * @interface
 * @template VALUE, UNUSED_RETURN_T, UNUSED_NEXT_T
 * @see https://tc39.github.io/proposal-async-iteration/
 */
function AsyncIterator() {}

/**
 * @param {?=} opt_value
 * @return {!Promise<!IIterableResult<VALUE>>}
 */
AsyncIterator.prototype.next;


/**
 * @interface
 * @template VALUE
 */
function AsyncIterable() {}


/**
 * @return {!AsyncIterator<VALUE, ?, *>}
 */
AsyncIterable.prototype[Symbol.asyncIterator] = function() {};


/**
 * @interface
 * @extends {AsyncIterator<VALUE, ?, *>}
 * @extends {AsyncIterable<VALUE>}
 * @template VALUE
 * @see https://tc39.github.io/proposal-async-iteration/
 */
function AsyncIteratorIterable() {}

/**
 * TODO(b/142881197): UNUSED_RETURN_T and UNUSED_NEXT_T are not yet used for
 * anything. https://github.com/google/closure-compiler/issues/3489
 * @interface
 * @see https://tc39.github.io/proposal-async-iteration/
 * @extends {AsyncIteratorIterable<VALUE>}
 * @template VALUE, UNUSED_RETURN_T, UNUSED_NEXT_T
 */
function AsyncGenerator() {}

/**
 * @param {?=} opt_value
 * @return {!Promise<!IIterableResult<VALUE>>}
 * @override
 */
AsyncGenerator.prototype.next = function(opt_value) {};

/**
 * @param {VALUE} value
 * @return {!Promise<!IIterableResult<VALUE>>}
 */
AsyncGenerator.prototype.return = function(value) {};

/**
 * @param {?} exception
 * @return {!Promise<!IIterableResult<VALUE>>}
 */
AsyncGenerator.prototype.throw = function(exception) {};

/**
 * @constructor
 * @struct
 * @param {TYPE} value
 * @template TYPE
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef
 */
function WeakRef(value) {}

/**
 * @return {TYPE}
 * @nosideeffects
 */
WeakRef.prototype.deref = function() {};

/**
 * @type {!Global}
 */
var globalThis;

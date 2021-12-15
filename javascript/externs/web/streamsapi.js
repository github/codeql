/*
 * Copyright 2015 The Closure Compiler Authors
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
 * @fileoverview Streams API definitions
 *
 * Based on Living Standard — Last Updated 5 August 2016
 * https://streams.spec.whatwg.org/commit-snapshots/34ecaadbcce8df9943d7a2cdb7fca4dc25914df4/
 *
 * @see https://streams.spec.whatwg.org/
 * @externs
 */


/** @typedef {{ value:*, done:boolean }} */
var IteratorResult;


/**
 * @typedef {!CountQueuingStrategy|!ByteLengthQueuingStrategy|{
 *     size: (undefined|function(*): number),
 *     highWaterMark: number
 * }}
 */
var QueuingStrategy;


/**
 * @record
 */
function TransformStream() {};

/** @type {!WritableStream} */
TransformStream.prototype.writable;

/** @type {!ReadableStream} */
TransformStream.prototype.readable;


/**
 * @record
 */
function PipeOptions() {};

/** @type {undefined|boolean} */
PipeOptions.prototype.preventClose;

/** @type {undefined|boolean} */
PipeOptions.prototype.preventAbort;

/** @type {undefined|boolean} */
PipeOptions.prototype.preventCancel;


/**
 * @record
 */
function ReadableStreamSource() {};

/**
 * @type {(undefined|
 *     function((!ReadableByteStreamController|!ReadableStreamDefaultController)):(!IThenable<*>|undefined))}
 */
ReadableStreamSource.prototype.start;

/**
 * @type {(undefined|
 *     function((!ReadableByteStreamController|!ReadableStreamDefaultController)):(!IThenable<*>|undefined))}
 */
ReadableStreamSource.prototype.pull;

/** @type {(undefined|function(*):(!Promise<*>|undefined))} */
ReadableStreamSource.prototype.cancel;

/** @type {(undefined|string)} */
ReadableStreamSource.prototype.type;

/** @type {(undefined|number)} */
ReadableStreamSource.prototype.autoAllocateChunkSize;


/**
 * @param {!ReadableStreamSource=} opt_underlyingSource
 * @param {!QueuingStrategy=} opt_queuingStrategy
 * @constructor
 * @see https://streams.spec.whatwg.org/#rs-class
 */
function ReadableStream(opt_underlyingSource, opt_queuingStrategy) {};

/**
 * @type {boolean}
 * @see https://streams.spec.whatwg.org/#rs-locked
 */
ReadableStream.prototype.locked;

/**
 * @param {*} reason
 * @return {!Promise<void>}
 * @see https://streams.spec.whatwg.org/#rs-cancel
 */
ReadableStream.prototype.cancel = function(reason) {};

/**
 * @param {{ mode:(undefined|string) }=} opt_options
 * @return {(!ReadableStreamDefaultReader|!ReadableStreamBYOBReader)}
 * @see https://streams.spec.whatwg.org/#rs-get-reader
 */
ReadableStream.prototype.getReader = function(opt_options) {};

/**
 * @param {!TransformStream} transform
 * @param {!PipeOptions=} opt_options
 * @return {!ReadableStream}
 * @see https://streams.spec.whatwg.org/#rs-pipe-through
 */
ReadableStream.prototype.pipeThrough = function(transform, opt_options) {};

/**
 * @param {!WritableStream} dest
 * @param {!PipeOptions=} opt_options
 * @return {!Promise<void>}
 * @see https://streams.spec.whatwg.org/#rs-pipe-to
 */
ReadableStream.prototype.pipeTo = function(dest, opt_options) {};

/**
 * @return {!Array<!ReadableStream>}
 * @see https://streams.spec.whatwg.org/#rs-tee
 */
ReadableStream.prototype.tee = function() {};


/**
 * The ReadableStreamDefaultReader constructor is generally not meant to be used directly;
 * instead, a stream’s getReader() method should be used.
 *
 * @interface
 * @see https://streams.spec.whatwg.org/#default-reader-class
 */
function ReadableStreamDefaultReader() {};

/**
 * @type {!Promise<void>}
 * @see https://streams.spec.whatwg.org/#default-reader-closed
 */
ReadableStreamDefaultReader.prototype.closed;

/**
 * @param {*} reason
 * @return {!Promise<*>}
 * @see https://streams.spec.whatwg.org/#default-reader-cancel
 */
ReadableStreamDefaultReader.prototype.cancel = function(reason) {};

/**
 * @return {!Promise<!IteratorResult>}
 * @see https://streams.spec.whatwg.org/#default-reader-read
 */
ReadableStreamDefaultReader.prototype.read = function() {};

/**
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#default-reader-release-lock
 */
ReadableStreamDefaultReader.prototype.releaseLock = function() {};


/**
 * The ReadableStreamBYOBReader constructor is generally not meant to be used
 * directly; instead, a stream’s getReader() method should be used.
 *
 * @interface
 * @see https://streams.spec.whatwg.org/#byob-reader-class
 */
function ReadableStreamBYOBReader() {};

/**
 * @type {!Promise<void>}
 * @see https://streams.spec.whatwg.org/#byob-reader-closed
 */
ReadableStreamBYOBReader.prototype.closed;

/**
 * @param {*} reason
 * @return {!Promise<*>}
 * @see https://streams.spec.whatwg.org/#byob-reader-cancel
 */
ReadableStreamBYOBReader.prototype.cancel = function(reason) {};

/**
 * @param {!ArrayBufferView} view
 * @return {!Promise<!IteratorResult>}
 * @see https://streams.spec.whatwg.org/#byob-reader-read
 */
ReadableStreamBYOBReader.prototype.read = function(view) {};

/**
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#byob-reader-release-lock
 */
ReadableStreamBYOBReader.prototype.releaseLock = function() {};


/**
 * The ReadableStreamDefaultController constructor cannot be used directly;
 * it only works on a ReadableStream that is in the middle of being constructed.
 *
 * @interface
 * @see https://streams.spec.whatwg.org/#rs-default-controller-class
 */
function ReadableStreamDefaultController() {};

/**
 * @type {number}
 * @see https://streams.spec.whatwg.org/#rs-default-controller-desired-size
 */
ReadableStreamDefaultController.prototype.desiredSize;

/**
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#rs-default-controller-close
 */
ReadableStreamDefaultController.prototype.close = function() {};

/**
 * @param {*} chunk
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#rs-default-controller-enqueue
 */
ReadableStreamDefaultController.prototype.enqueue = function(chunk) {};

/**
 * @param {*} err
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#rs-default-controller-error
 */
ReadableStreamDefaultController.prototype.error = function(err) {};


/**
 * The ReadableByteStreamController constructor cannot be used directly;
 * it only works on a ReadableStream that is in the middle of being constructed.
 *
 * @interface
 * @see https://streams.spec.whatwg.org/#rbs-controller-class
 */
function ReadableByteStreamController() {};

/**
 * @type {!ReadableStreamBYOBRequest}
 * @see https://streams.spec.whatwg.org/#rbs-controller-byob-request
 */
ReadableByteStreamController.prototype.byobRequest;

/**
 * @type {number}
 * @see https://streams.spec.whatwg.org/#rbs-controller-desired-size
 */
ReadableByteStreamController.prototype.desiredSize;

/**
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#rbs-controller-close
 */
ReadableByteStreamController.prototype.close = function() {};

/**
 * @param {!ArrayBufferView} chunk
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#rbs-controller-enqueue
 */
ReadableByteStreamController.prototype.enqueue = function(chunk) {};

/**
 * @param {*} err
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#rbs-controller-error
 */
ReadableByteStreamController.prototype.error = function(err) {};


/**
 * @interface
 * @see https://streams.spec.whatwg.org/#rs-byob-request-class
 */
function ReadableStreamBYOBRequest() {};

/**
 * @type {!ArrayBufferView}
 * @see https://streams.spec.whatwg.org/#rs-byob-request-view
 */
ReadableStreamBYOBRequest.prototype.view;

/**
 * @param {number} bytesWritten
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#rs-byob-request-respond
 */
ReadableStreamBYOBRequest.prototype.respond = function(bytesWritten) {};

/**
 * @param {!ArrayBufferView} view
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#rs-byob-request-respond-with-new-view
 */
ReadableStreamBYOBRequest.prototype.respondWithNewView = function(view) {};


/**
 * @record
 */
function WritableStreamSink() {};

/** @type {(undefined|function(!WritableStreamDefaultController):(!IThenable<*>|undefined))}*/
WritableStreamSink.prototype.start;

/** @type {(undefined|function(!WritableStreamDefaultController):(!IThenable<*>|undefined))}*/
WritableStreamSink.prototype.write;

/** @type {(undefined|function():(!IThenable<*>|undefined))} */
WritableStreamSink.prototype.close;

/** @type {(undefined|function(*):(!IThenable<*>|undefined))} */
WritableStreamSink.prototype.abort;


/**
 * @param {!WritableStreamSink=} opt_underlyingSink
 * @param {!QueuingStrategy=} opt_queuingStrategy
 * @constructor
 * @see https://streams.spec.whatwg.org/#ws-class
 */
function WritableStream(opt_underlyingSink, opt_queuingStrategy) {};

/**
 * @type {boolean}
 * @see https://streams.spec.whatwg.org/#ws-locked
 */
WritableStream.prototype.locked;

/**
 * @param {*} reason
 * @return {!Promise<undefined>}
 * @see https://streams.spec.whatwg.org/#ws-abort
 */
WritableStream.prototype.abort = function(reason) {};

/**
 * @return {!WritableStreamDefaultWriter}
 * @see https://streams.spec.whatwg.org/#ws-get-writer
 */
WritableStream.prototype.getWriter = function() {};


/**
 * @interface
 * @see https://streams.spec.whatwg.org/#default-writer-class
 */
function WritableStreamDefaultWriter() {};

/**
 * @type {!Promise<undefined>}
 * @see https://streams.spec.whatwg.org/#default-writer-closed
 */
WritableStreamDefaultWriter.prototype.closed;

/**
 * @type {number}
 * @see https://streams.spec.whatwg.org/#default-writer-desiredSize
 */
WritableStreamDefaultWriter.prototype.desiredSize;

/**
 * @type {!Promise<number>}
 * @see https://streams.spec.whatwg.org/#default-writer-ready
 */
WritableStreamDefaultWriter.prototype.ready;

/**
 * @param {*} reason
 * @return {!Promise<undefined>}
 * @see https://streams.spec.whatwg.org/#default-writer-abort
 */
WritableStreamDefaultWriter.prototype.abort = function(reason) {};

/**
 * @return {!Promise<undefined>}
 * @see https://streams.spec.whatwg.org/#default-writer-close
 */
WritableStreamDefaultWriter.prototype.close = function() {};

/**
 * @return {undefined}
 * @see https://streams.spec.whatwg.org/#default-writer-release-lock
 */
WritableStreamDefaultWriter.prototype.releaseLock = function() {};

/**
 * @param {*} chunk
 * @return {!Promise<undefined>}
 * @see https://streams.spec.whatwg.org/#default-writer-write
 */
WritableStreamDefaultWriter.prototype.write = function(chunk) {};


/**
 * The WritableStreamDefaultController constructor cannot be used directly;
 * it only works on a WritableStream that is in the middle of being constructed.
 *
 * @interface
 * @see https://streams.spec.whatwg.org/#ws-default-controller-class
 */
function WritableStreamDefaultController() {};

/**
 * @param {*} err
 * @return {!Promise<undefined>}
 * @see https://streams.spec.whatwg.org/#ws-default-controller-error
 */
WritableStreamDefaultController.prototype.error = function(err) {};


/**
 * @param {{ highWaterMark:number }} config
 * @constructor
 * @see https://streams.spec.whatwg.org/#blqs-class
 */
function ByteLengthQueuingStrategy(config) {}

/**
 * If we don't want to be strict we can define chunk as {*}
 * and return as {number|undefined}
 *
 * @param {{ byteLength:number }} chunk
 * @return {number}
 * @see https://streams.spec.whatwg.org/#blqs-size
 */
ByteLengthQueuingStrategy.prototype.size = function(chunk) {};


/**
 * @param {{ highWaterMark:number }} config
 * @constructor
 * @see https://streams.spec.whatwg.org/#cqs-class
 */
function CountQueuingStrategy(config) {}

/**
 * @param {*} chunk
 * @return {number}
 * @see https://streams.spec.whatwg.org/#cqs-size
 */
CountQueuingStrategy.prototype.size = function(chunk) {};

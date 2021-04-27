/*
 * Copyright 2010 The Closure Compiler Authors
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
 * @fileoverview Definitions for objects in the File API, File Writer API, and
 * File System API. Details of the API are at:
 * http://www.w3.org/TR/FileAPI/
 *
 * @externs
 */

/** @record */
function BlobPropertyBag() {};

/** @type {(string|undefined)} */
BlobPropertyBag.prototype.type;

/**
 * @see http://dev.w3.org/2006/webapi/FileAPI/#dfn-Blob
 * @param {Array<ArrayBuffer|ArrayBufferView|Blob|string>=} opt_blobParts
 * @param {BlobPropertyBag=} opt_options
 * @constructor
 * @nosideeffects
 */
function Blob(opt_blobParts, opt_options) {}

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-size
 * @type {number}
 */
Blob.prototype.size;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-type
 * @type {string}
 */
Blob.prototype.type;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-slice
 * @param {number=} start
 * @param {number=} length
 * @param {string=} opt_contentType
 * @return {!Blob}
 * @nosideeffects
 */
Blob.prototype.slice = function(start, length, opt_contentType) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#arraybuffer-method-algo
 * @return {!Promise<!ArrayBuffer>}
 * @nosideeffects
 */
Blob.prototype.arrayBuffer = function() {};

/**
 * @see https://www.w3.org/TR/FileAPI/#dom-blob-text
 * @return {!Promise<string>}
 * @nosideeffects
 */
Blob.prototype.text = function() {};


/**
 * @record
 * @extends {BlobPropertyBag}
 **/
function FilePropertyBag() {};

/** @type {(number|undefined)} */
FilePropertyBag.prototype.lastModified;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-file
 * @param {!Array<string|!Blob|!ArrayBuffer>=} contents
 * @param {string=} name
 * @param {FilePropertyBag=} properties
 * @constructor
 * @extends {Blob}
 */
function File(contents, name, properties) {}

/**
 * Chrome uses this instead of name.
 * @deprecated Use name instead.
 * @type {string}
 */
File.prototype.fileName;

/**
 * Chrome uses this instead of size.
 * @deprecated Use size instead.
 * @type {string}
 */
File.prototype.fileSize;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-name
 * @type {string}
 */
File.prototype.name;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-lastModifiedDate
 * @type {Date}
 */
File.prototype.lastModifiedDate;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-lastModified
 * @type {number}
 */
File.prototype.lastModified;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-filereader
 * @constructor
 * @implements {EventTarget}
 */
function FileReader() {}

/** @override */
FileReader.prototype.addEventListener = function(type, listener, opt_options) {
};

/** @override */
FileReader.prototype.removeEventListener = function(
    type, listener, opt_options) {};

/** @override */
FileReader.prototype.dispatchEvent = function(evt) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-readAsArrayBuffer
 * @param {!Blob} blob
 * @return {undefined}
 */
FileReader.prototype.readAsArrayBuffer = function(blob) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-readAsBinaryStringAsync
 * @param {!Blob} blob
 * @return {undefined}
 */
FileReader.prototype.readAsBinaryString = function(blob) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-readAsText
 * @param {!Blob} blob
 * @param {string=} encoding
 * @return {undefined}
 */
FileReader.prototype.readAsText = function(blob, encoding) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-readAsDataURL
 * @param {!Blob} blob
 * @return {undefined}
 */
FileReader.prototype.readAsDataURL = function(blob) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-abort
 * @return {undefined}
 */
FileReader.prototype.abort = function() {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-empty
 * @const {number}
 */
FileReader.prototype.EMPTY;

/** @const {number} */
FileReader.EMPTY;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-loading
 * @const {number}
 */
FileReader.prototype.LOADING;

/** @const {number} */
FileReader.LOADING;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-done
 * @const {number}
 */
FileReader.prototype.DONE;

/** @const {number} */
FileReader.DONE;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-readystate
 * @type {number}
 */
FileReader.prototype.readyState;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-result
 * @type {string|Blob|ArrayBuffer}
 */
FileReader.prototype.result;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-error
 * @type {DOMError}
 */
FileReader.prototype.error;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onloadstart
 * @type {?function(!ProgressEvent<!FileReader>)}
 */
FileReader.prototype.onloadstart;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onprogress
 * @type {?function(!ProgressEvent<!FileReader>)}
 */
FileReader.prototype.onprogress;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onload
 * @type {?function(!ProgressEvent<!FileReader>)}
 */
FileReader.prototype.onload;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onabort
 * @type {?function(!ProgressEvent<!FileReader>)}
 */
FileReader.prototype.onabort;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onerror
 * @type {?function(!ProgressEvent<!FileReader>)}
 */
FileReader.prototype.onerror;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onloadend
 * @type {?function(!ProgressEvent<!FileReader>)}
 */
FileReader.prototype.onloadend;


/**
 * @see http://www.w3.org/TR/FileAPI/#FileReaderSyncSync
 * @constructor
 */
function FileReaderSync() {}

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-readAsArrayBufferSync
 * @param {!Blob} blob
 * @return {!ArrayBuffer}
 */
FileReaderSync.prototype.readAsArrayBuffer = function(blob) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-readAsBinaryStringSync
 * @param {!Blob} blob
 * @return {string}
 */
FileReaderSync.prototype.readAsBinaryString = function(blob) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-readAsTextSync
 * @param {!Blob} blob
 * @param {string=} encoding
 * @return {string}
 */
FileReaderSync.prototype.readAsText = function(blob, encoding) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-readAsDataURLSync
 * @param {!Blob} blob
 * @return {string}
 */
FileReaderSync.prototype.readAsDataURL = function(blob) {};

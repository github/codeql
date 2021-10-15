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
 * http://www.w3.org/TR/file-writer-api/
 * http://www.w3.org/TR/file-system-api/
 *
 * @externs
 * @author dbk@google.com (David Barrett-Kahn)
 */


/**
 * @see http://dev.w3.org/2006/webapi/FileAPI/#dfn-Blob
 * @param {Array<ArrayBuffer|ArrayBufferView|Blob|string>=} opt_blobParts
 * @param {Object=} opt_options
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
 * This replaces Blob.slice in Chrome since WebKit revision 84005.
 * @see http://lists.w3.org/Archives/Public/public-webapps/2011AprJun/0222.html
 * @param {number=} start
 * @param {number=} end
 * @param {string=} opt_contentType
 * @return {!Blob}
 * @nosideeffects
 */
Blob.prototype.webkitSlice = function(start, end, opt_contentType) {};

/**
 * This replaces Blob.slice in Firefox.
 * @see http://lists.w3.org/Archives/Public/public-webapps/2011AprJun/0222.html
 * @param {number=} start
 * @param {number=} end
 * @param {string=} opt_contentType
 * @return {!Blob}
 * @nosideeffects
 */
Blob.prototype.mozSlice = function(start, end, opt_contentType) {};

/**
 * @see http://www.w3.org/TR/file-writer-api/#the-blobbuilder-interface
 * @constructor
 */
function BlobBuilder() {}

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-BlobBuilder-append0
 * @see http://www.w3.org/TR/file-writer-api/#widl-BlobBuilder-append1
 * @see http://www.w3.org/TR/file-writer-api/#widl-BlobBuilder-append2
 * @param {string|Blob|ArrayBuffer} data
 * @param {string=} endings
 * @return {undefined}
 */
BlobBuilder.prototype.append = function(data, endings) {};

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-BlobBuilder-getBlob
 * @param {string=} contentType
 * @return {!Blob}
 */
BlobBuilder.prototype.getBlob = function(contentType) {};

/**
 * This has replaced BlobBuilder in Chrome since WebKit revision 84008.
 * @see http://lists.w3.org/Archives/Public/public-webapps/2011AprJun/0222.html
 * @constructor
 */
function WebKitBlobBuilder() {}

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-BlobBuilder-append0
 * @see http://www.w3.org/TR/file-writer-api/#widl-BlobBuilder-append1
 * @see http://www.w3.org/TR/file-writer-api/#widl-BlobBuilder-append2
 * @param {string|Blob|ArrayBuffer} data
 * @param {string=} endings
 * @return {undefined}
 */
WebKitBlobBuilder.prototype.append = function(data, endings) {};

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-BlobBuilder-getBlob
 * @param {string=} contentType
 * @return {!Blob}
 */
WebKitBlobBuilder.prototype.getBlob = function(contentType) {};


/**
 * @record
 * @see https://dev.w3.org/2009/dap/file-system/file-dir-sys.html#the-flags-dictionary
 */
function FileSystemFlags() {};

/** @type {(undefined|boolean)} */
FileSystemFlags.prototype.create;

/** @type {(undefined|boolean)} */
FileSystemFlags.prototype.exclusive;


/**
 * @see http://www.w3.org/TR/file-system-api/#the-directoryentry-interface
 * @constructor
 * @extends {Entry}
 */
function DirectoryEntry() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntry-createReader
 * @return {!DirectoryReader}
 */
DirectoryEntry.prototype.createReader = function() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntry-getFile
 * @param {string} path
 * @param {!FileSystemFlags=} options
 * @param {function(!FileEntry)=} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
DirectoryEntry.prototype.getFile = function(path, options, successCallback,
    errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntry-getDirectory
 * @param {string} path
 * @param {!FileSystemFlags=} options
 * @param {function(!DirectoryEntry)=} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
DirectoryEntry.prototype.getDirectory = function(path, options, successCallback,
    errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntry-removeRecursively
 * @param {function()} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
DirectoryEntry.prototype.removeRecursively = function(successCallback,
    errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#the-directoryreader-interface
 * @constructor
 */
function DirectoryReader() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryReader-readEntries
 * @param {function(!Array<!Entry>)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
DirectoryReader.prototype.readEntries = function(successCallback,
    errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#the-entry-interface
 * @constructor
 */
function Entry() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-isFile
 * @type {boolean}
 */
Entry.prototype.isFile;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-isDirectory
 * @type {boolean}
 */
Entry.prototype.isDirectory;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-name
 * @type {string}
 */
Entry.prototype.name;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-fullPath
 * @type {string}
 */
Entry.prototype.fullPath;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-filesystem
 * @type {!FileSystem}
 */
Entry.prototype.filesystem;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-moveTo
 * @param {!DirectoryEntry} parent
 * @param {string=} newName
 * @param {function(!Entry)=} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Entry.prototype.moveTo = function(parent, newName, successCallback,
    errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-copyTo
 * @param {!DirectoryEntry} parent
 * @param {string=} newName
 * @param {function(!Entry)=} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Entry.prototype.copyTo = function(parent, newName, successCallback,
    errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-toURL
 * @param {string=} mimeType
 * @return {string}
 */
Entry.prototype.toURL = function(mimeType) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-remove
 * @param {function()} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Entry.prototype.remove = function(successCallback, errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-getMetadata
 * @param {function(!Metadata)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Entry.prototype.getMetadata = function(successCallback, errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-getParent
 * @param {function(!Entry)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Entry.prototype.getParent = function(successCallback, errorCallback) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-file
 * @param {!Array<string|!Blob|!ArrayBuffer>=} opt_contents
 * @param {string=} opt_name
 * @param {{type: (string|undefined), lastModified: (number|undefined)}=}
 *     opt_properties
 * @constructor
 * @extends {Blob}
 */
function File(opt_contents, opt_name, opt_properties) {}

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
 * @see http://www.w3.org/TR/file-system-api/#the-fileentry-interface
 * @constructor
 * @extends {Entry}
 */
function FileEntry() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileEntry-createWriter
 * @param {function(!FileWriter)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
FileEntry.prototype.createWriter = function(successCallback, errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileEntry-file
 * @param {function(!File)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
FileEntry.prototype.file = function(successCallback, errorCallback) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#FileErrorInterface
 * @constructor
 * @extends {DOMError}
 */
function FileError() {}

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-NOT_FOUND_ERR
 * @type {number}
 */
FileError.prototype.NOT_FOUND_ERR = 1;

/** @type {number} */
FileError.NOT_FOUND_ERR = 1;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-SECURITY_ERR
 * @type {number}
 */
FileError.prototype.SECURITY_ERR = 2;

/** @type {number} */
FileError.SECURITY_ERR = 2;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-ABORT_ERR
 * @type {number}
 */
FileError.prototype.ABORT_ERR = 3;

/** @type {number} */
FileError.ABORT_ERR = 3;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-NOT_READABLE_ERR
 * @type {number}
 */
FileError.prototype.NOT_READABLE_ERR = 4;

/** @type {number} */
FileError.NOT_READABLE_ERR = 4;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-ENCODING_ERR
 * @type {number}
 */
FileError.prototype.ENCODING_ERR = 5;

/** @type {number} */
FileError.ENCODING_ERR = 5;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileError-NO_MODIFICATION_ALLOWED_ERR
 * @type {number}
 */
FileError.prototype.NO_MODIFICATION_ALLOWED_ERR = 6;

/** @type {number} */
FileError.NO_MODIFICATION_ALLOWED_ERR = 6;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileException-INVALID_STATE_ERR
 * @type {number}
 */
FileError.prototype.INVALID_STATE_ERR = 7;

/** @type {number} */
FileError.INVALID_STATE_ERR = 7;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileException-SYNTAX_ERR
 * @type {number}
 */
FileError.prototype.SYNTAX_ERR = 8;

/** @type {number} */
FileError.SYNTAX_ERR = 8;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileError-INVALID_MODIFICATION_ERR
 * @type {number}
 */
FileError.prototype.INVALID_MODIFICATION_ERR = 9;

/** @type {number} */
FileError.INVALID_MODIFICATION_ERR = 9;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileError-QUOTA_EXCEEDED_ERR
 * @type {number}
 */
FileError.prototype.QUOTA_EXCEEDED_ERR = 10;

/** @type {number} */
FileError.QUOTA_EXCEEDED_ERR = 10;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileException-TYPE_MISMATCH_ERR
 * @type {number}
 */
FileError.prototype.TYPE_MISMATCH_ERR = 11;

/** @type {number} */
FileError.TYPE_MISMATCH_ERR = 11;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileException-PATH_EXISTS_ERR
 * @type {number}
 */
FileError.prototype.PATH_EXISTS_ERR = 12;

/** @type {number} */
FileError.PATH_EXISTS_ERR = 12;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-code-exception
 * @type {number}
 * @deprecated Use the 'name' or 'message' attributes of DOMError rather than
 * 'code'
 */
FileError.prototype.code;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-filereader
 * @constructor
 * @implements {EventTarget}
 */
function FileReader() {}

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
FileReader.prototype.addEventListener = function(type, listener, opt_useCapture)
    {};

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
FileReader.prototype.removeEventListener = function(type, listener,
    opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
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
 * @type {number}
 */
FileReader.prototype.EMPTY = 0;

/** @type {number} */
FileReader.EMPTY = 0;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-loading
 * @type {number}
 */
FileReader.prototype.LOADING = 1;

/** @type {number} */
FileReader.LOADING = 1;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-done
 * @type {number}
 */
FileReader.prototype.DONE = 2;

/** @type {number} */
FileReader.DONE = 2;

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
 * @type {FileError}
 */
FileReader.prototype.error;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onloadstart
 * @type {?function(!ProgressEvent)}
 */
FileReader.prototype.onloadstart;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onprogress
 * @type {?function(!ProgressEvent)}
 */
FileReader.prototype.onprogress;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onload
 * @type {?function(!ProgressEvent)}
 */
FileReader.prototype.onload;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onabort
 * @type {?function(!ProgressEvent)}
 */
FileReader.prototype.onabort;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onerror
 * @type {?function(!ProgressEvent)}
 */
FileReader.prototype.onerror;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-onloadend
 * @type {?function(!ProgressEvent)}
 */
FileReader.prototype.onloadend;

/**
 * @see http://www.w3.org/TR/file-writer-api/#idl-def-FileSaver
 * @constructor
 */
function FileSaver() {};

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-abort
 * @return {undefined}
 */
FileSaver.prototype.abort = function() {};

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-INIT
 * @type {number}
 */
FileSaver.prototype.INIT = 0;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-WRITING
 * @type {number}
 */
FileSaver.prototype.WRITING = 1;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-DONE
 * @type {number}
 */
FileSaver.prototype.DONE = 2;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-readyState
 * @type {number}
 */
FileSaver.prototype.readyState;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-error
 * @type {FileError}
 */
FileSaver.prototype.error;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onwritestart
 * @type {?function(!ProgressEvent)}
 */
FileSaver.prototype.onwritestart;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onprogress
 * @type {?function(!ProgressEvent)}
 */
FileSaver.prototype.onprogress;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onwrite
 * @type {?function(!ProgressEvent)}
 */
FileSaver.prototype.onwrite;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onabort
 * @type {?function(!ProgressEvent)}
 */
FileSaver.prototype.onabort;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onerror
 * @type {?function(!ProgressEvent)}
 */
FileSaver.prototype.onerror;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onwriteend
 * @type {?function(!ProgressEvent)}
 */
FileSaver.prototype.onwriteend;

/**
 * @see http://www.w3.org/TR/file-system-api/#the-filesystem-interface
 * @constructor
 */
function FileSystem() {}

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileSystem-name
 * @type {string}
 */
FileSystem.prototype.name;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileSystem-root
 * @type {!DirectoryEntry}
 */
FileSystem.prototype.root;

/**
 * @see http://www.w3.org/TR/file-writer-api/#idl-def-FileWriter
 * @constructor
 * @extends {FileSaver}
 */
function FileWriter() {}

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriter-position
 * @type {number}
 */
FileWriter.prototype.position;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriter-length
 * @type {number}
 */
FileWriter.prototype.length;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriter-write
 * @param {!Blob} blob
 * @return {undefined}
 */
FileWriter.prototype.write = function(blob) {};

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriter-seek
 * @param {number} offset
 * @return {undefined}
 */
FileWriter.prototype.seek = function(offset) {};

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriter-truncate
 * @param {number} size
 * @return {undefined}
 */
FileWriter.prototype.truncate = function(size) {};

/**
 * LocalFileSystem interface, implemented by Window and WorkerGlobalScope.
 * @see http://www.w3.org/TR/file-system-api/#idl-def-LocalFileSystem
 * @constructor
 */
function LocalFileSystem() {}

/**
 * Metadata interface.
 * @see http://www.w3.org/TR/file-system-api/#idl-def-Metadata
 * @constructor
 */
function Metadata() {}

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Metadata-modificationTime
 * @type {!Date}
 */
Metadata.prototype.modificationTime;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Metadata-size
 * @type {number}
 */
Metadata.prototype.size;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-TEMPORARY
 * @type {number}
*/
Window.prototype.TEMPORARY = 0;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-PERSISTENT
 * @type {number}
*/
Window.prototype.PERSISTENT = 1;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-requestFileSystem
 * @param {number} type
 * @param {number} size
 * @param {function(!FileSystem)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
function requestFileSystem(type, size, successCallback, errorCallback) {}

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-requestFileSystem
 * @param {number} type
 * @param {number} size
 * @param {function(!FileSystem)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Window.prototype.requestFileSystem = function(type, size, successCallback,
    errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-resolveLocalFileSystemURI
 * @param {string} uri
 * @param {function(!Entry)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
function resolveLocalFileSystemURI(uri, successCallback, errorCallback) {}

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-resolveLocalFileSystemURI
 * @param {string} uri
 * @param {function(!Entry)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Window.prototype.resolveLocalFileSystemURI = function(uri, successCallback,
    errorCallback) {}

/**
 * This has replaced requestFileSystem in Chrome since WebKit revision 84224.
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-requestFileSystem
 * @param {number} type
 * @param {number} size
 * @param {function(!FileSystem)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
function webkitRequestFileSystem(type, size, successCallback, errorCallback) {}

/**
 * This has replaced requestFileSystem in Chrome since WebKit revision 84224.
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-requestFileSystem
 * @param {number} type
 * @param {number} size
 * @param {function(!FileSystem)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Window.prototype.webkitRequestFileSystem = function(type, size, successCallback,
    errorCallback) {};

/**
 * This has replaced resolveLocalFileSystemURI in Chrome since WebKit revision
 * 84224.
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-resolveLocalFileSystemURI
 * @param {string} uri
 * @param {function(!Entry)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
function webkitResolveLocalFileSystemURI(uri, successCallback, errorCallback) {}

/**
 * This has replaced resolveLocalFileSystemURI in Chrome since WebKit revision
 * 84224.
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-resolveLocalFileSystemURI
 * @param {string} uri
 * @param {function(!Entry)} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Window.prototype.webkitResolveLocalFileSystemURI = function(uri, successCallback,
    errorCallback) {}

// WindowBlobURIMethods interface, implemented by Window and WorkerGlobalScope.
// There are three APIs for this: the old specced API, the new specced API, and
// the webkit-prefixed API.
// @see http://www.w3.org/TR/FileAPI/#creating-revoking

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-createObjectURL
 * @param {!Object} obj
 * @return {string}
 */
function createObjectURL(obj) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-createObjectURL
 * @param {!Object} obj
 * @return {string}
 */
Window.prototype.createObjectURL = function(obj) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-revokeObjectURL
 * @param {string} url
 * @return {undefined}
 */
function revokeObjectURL(url) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-revokeObjectURL
 * @param {string} url
 * @return {undefined}
 */
Window.prototype.revokeObjectURL = function(url) {};

/**
 * This has been replaced by URL in Chrome since WebKit revision 75739.
 * @constructor
 * @param {string} urlString
 * @param {string=} opt_base
 */
function webkitURL(urlString, opt_base) {}

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-createObjectURL
 * @param {!Object} obj
 * @return {string}
 */
webkitURL.createObjectURL = function(obj) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-revokeObjectURL
 * @param {string} url
 * @return {undefined}
 */
webkitURL.revokeObjectURL = function(url) {};

/**
 * @see https://developers.google.com/chrome/whitepapers/storage
 * @constructor
 */
function StorageInfo() {}

/**
 * @see https://developers.google.com/chrome/whitepapers/storage
 * @type {number}
 * */
StorageInfo.prototype.TEMPORARY = 0;

/**
 * @see https://developers.google.com/chrome/whitepapers/storage
 * @type {number}
 */
StorageInfo.prototype.PERSISTENT = 1;

/**
 * @see https://developers.google.com/chrome/whitepapers/storage#requestQuota
 * @param {number} type
 * @param {number} size
 * @param {function(number)} successCallback
 * @param {function(!DOMException)=} errorCallback
 * @return {undefined}
 */
StorageInfo.prototype.requestQuota = function(type, size, successCallback,
    errorCallback) {};

/**
 * @see https://developers.google.com/chrome/whitepapers/storage#queryUsageAndQuota
 * @param {number} type
 * @param {function(number, number)} successCallback
 * @param {function(!DOMException)=} errorCallback
 * @return {undefined}
 */
StorageInfo.prototype.queryUsageAndQuota = function(type, successCallback,
    errorCallback) {};

/**
 * @see https://developers.google.com/chrome/whitepapers/storage
 * @type {!StorageInfo}
 */
Window.prototype.webkitStorageInfo;

/**
 * @see https://dvcs.w3.org/hg/quota/raw-file/tip/Overview.html#storagequota-interface.
 * @constructor
 */
function StorageQuota() {}

/**
 * @param {number} size
 * @param {function(number)=} opt_successCallback
 * @param {function(!DOMException)=} opt_errorCallback
 * @return {undefined}
 */
StorageQuota.prototype.requestQuota = function(size, opt_successCallback,
    opt_errorCallback) {};

/**
 * @param {function(number, number)} successCallback
 * @param {function(!DOMException)=} opt_errorCallback
 * @return {undefined}
 */
StorageQuota.prototype.queryUsageAndQuota = function(successCallback,
    opt_errorCallback) {};


/**
 * @type {!StorageQuota}
 * @see https://developer.chrome.com/apps/offline_storage
 */
Navigator.prototype.webkitPersistentStorage;

/**
 * @type {!StorageQuota}
 * @see https://developer.chrome.com/apps/offline_storage
 */
Navigator.prototype.webkitTemporaryStorage;

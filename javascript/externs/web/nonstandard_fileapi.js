/*
 * Copyright 2019 The Closure Compiler Authors
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
 * @fileoverview Definitions for file api implemented in
 *     various browsers but not part of https://www.w3.org/TR/FileAPI.
 * @externs
 */

/**
 * This replaces Blob.slice in Chrome since WebKit revision 84005.
 * @see http://lists.w3.org/Archives/Public/public-webapps/2011AprJun/0222.html
 * @param {number=} start
 * @param {number=} end
 * @param {string=} contentType
 * @return {!Blob}
 * @nosideeffects
 */
Blob.prototype.webkitSlice = function(start, end, contentType) {};

/**
 * This replaces Blob.slice in Firefox.
 * @see http://lists.w3.org/Archives/Public/public-webapps/2011AprJun/0222.html
 * @param {number=} start
 * @param {number=} end
 * @param {string=} contentType
 * @return {!Blob}
 * @nosideeffects
 */
Blob.prototype.mozSlice = function(start, end, contentType) {};

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
DirectoryEntry.prototype.getFile = function(
    path, options, successCallback, errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntry-getDirectory
 * @param {string} path
 * @param {!FileSystemFlags=} options
 * @param {function(!DirectoryEntry)=} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
DirectoryEntry.prototype.getDirectory = function(
    path, options, successCallback, errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntry-removeRecursively
 * @param {function()} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
DirectoryEntry.prototype.removeRecursively = function(
    successCallback, errorCallback) {};

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
DirectoryReader.prototype.readEntries = function(
    successCallback, errorCallback) {};

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
Entry.prototype.moveTo = function(
    parent, newName, successCallback, errorCallback) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-Entry-copyTo
 * @param {!DirectoryEntry} parent
 * @param {string=} newName
 * @param {function(!Entry)=} successCallback
 * @param {function(!FileError)=} errorCallback
 * @return {undefined}
 */
Entry.prototype.copyTo = function(
    parent, newName, successCallback, errorCallback) {};

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
 * @return {?Entry} The Entry corresponding to this item, or null. Note that
 * despite its name,this method only works in Chrome, and will eventually
 * be renamed to {@code getAsEntry}.
 * @nosideeffects
 */
DataTransferItem.prototype.webkitGetAsEntry = function() {};

/**
 * @see https://wicg.github.io/entries-api/#dom-file-webkitrelativepath
 * @type {string}
 */
File.prototype.webkitRelativePath;

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
 * @const {number}
 */
FileError.prototype.NOT_FOUND_ERR;

/** @const {number} */
FileError.NOT_FOUND_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-SECURITY_ERR
 * @const {number}
 */
FileError.prototype.SECURITY_ERR;

/** @const {number} */
FileError.SECURITY_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-ABORT_ERR
 * @const {number}
 */
FileError.prototype.ABORT_ERR;

/** @const {number} */
FileError.ABORT_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-NOT_READABLE_ERR
 * @const {number}
 */
FileError.prototype.NOT_READABLE_ERR;

/** @const {number} */
FileError.NOT_READABLE_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-ENCODING_ERR
 * @const {number}
 */
FileError.prototype.ENCODING_ERR;

/** @const {number} */
FileError.ENCODING_ERR;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileError-NO_MODIFICATION_ALLOWED_ERR
 * @const {number}
 */
FileError.prototype.NO_MODIFICATION_ALLOWED_ERR;

/** @const {number} */
FileError.NO_MODIFICATION_ALLOWED_ERR;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileException-INVALID_STATE_ERR
 * @const {number}
 */
FileError.prototype.INVALID_STATE_ERR;

/** @const {number} */
FileError.INVALID_STATE_ERR;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileException-SYNTAX_ERR
 * @const {number}
 */
FileError.prototype.SYNTAX_ERR;

/** @const {number} */
FileError.SYNTAX_ERR;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileError-INVALID_MODIFICATION_ERR
 * @const {number}
 */
FileError.prototype.INVALID_MODIFICATION_ERR;

/** @const {number} */
FileError.INVALID_MODIFICATION_ERR;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileError-QUOTA_EXCEEDED_ERR
 * @const {number}
 */
FileError.prototype.QUOTA_EXCEEDED_ERR;

/** @const {number} */
FileError.QUOTA_EXCEEDED_ERR;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileException-TYPE_MISMATCH_ERR
 * @const {number}
 */
FileError.prototype.TYPE_MISMATCH_ERR;

/** @const {number} */
FileError.TYPE_MISMATCH_ERR;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileException-PATH_EXISTS_ERR
 * @const {number}
 */
FileError.prototype.PATH_EXISTS_ERR;

/** @const {number} */
FileError.PATH_EXISTS_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-code-exception
 * @type {number}
 * @deprecated Use the 'name' or 'message' attributes of DOMError rather than
 * 'code'
 */
FileError.prototype.code;

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
 * @const {number}
 */
FileSaver.prototype.INIT;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-WRITING
 * @const {number}
 */
FileSaver.prototype.WRITING;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-DONE
 * @const {number}
 */
FileSaver.prototype.DONE;

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
 * @type {?function(!ProgressEvent<!FileSaver>)}
 */
FileSaver.prototype.onwritestart;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onprogress
 * @type {?function(!ProgressEvent<!FileSaver>)}
 */
FileSaver.prototype.onprogress;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onwrite
 * @type {?function(!ProgressEvent<!FileSaver>)}
 */
FileSaver.prototype.onwrite;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onabort
 * @type {?function(!ProgressEvent<!FileSaver>)}
 */
FileSaver.prototype.onabort;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onerror
 * @type {?function(!ProgressEvent<!FileSaver>)}
 */
FileSaver.prototype.onerror;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileSaver-onwriteend
 * @type {?function(!ProgressEvent<!FileSaver>)}
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
 * @const {number}
 */
Window.prototype.TEMPORARY;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystem-PERSISTENT
 * @const {number}
 */
Window.prototype.PERSISTENT;

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
Window.prototype.requestFileSystem = function(
    type, size, successCallback, errorCallback) {};

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
Window.prototype.resolveLocalFileSystemURI =
    function(uri, successCallback, errorCallback) {}

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
Window.prototype.webkitResolveLocalFileSystemURI = function(
    uri, successCallback, errorCallback) {}

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
 * @param {string=} base
 */
function webkitURL(urlString, base) {}

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
 * @const {number}
 * */
StorageInfo.prototype.TEMPORARY;

/**
 * @see https://developers.google.com/chrome/whitepapers/storage
 * @const {number}
 */
StorageInfo.prototype.PERSISTENT;

/**
 * @see https://developers.google.com/chrome/whitepapers/storage#requestQuota
 * @param {number} type
 * @param {number} size
 * @param {function(number)} successCallback
 * @param {function(!DOMException)=} errorCallback
 * @return {undefined}
 */
StorageInfo.prototype.requestQuota = function(
    type, size, successCallback, errorCallback) {};

/**
 * @see https://developers.google.com/chrome/whitepapers/storage#queryUsageAndQuota
 * @param {number} type
 * @param {function(number, number)} successCallback
 * @param {function(!DOMException)=} errorCallback
 * @return {undefined}
 */
StorageInfo.prototype.queryUsageAndQuota = function(
    type, successCallback, errorCallback) {};

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
 * @param {function(number)=} successCallback
 * @param {function(!DOMException)=} errorCallback
 * @return {undefined}
 */
StorageQuota.prototype.requestQuota = function(
    size, successCallback, errorCallback) {};

/**
 * @param {function(number, number)} successCallback
 * @param {function(!DOMException)=} errorCallback
 * @return {undefined}
 */
StorageQuota.prototype.queryUsageAndQuota = function(
    successCallback, errorCallback) {};

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


/**
 * @see http://www.w3.org/TR/file-writer-api/#idl-def-FileWriterSync
 * @constructor
 */
function FileWriterSync() {}

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriterSync-position
 * @type {number}
 * @const
 */
FileWriterSync.prototype.position;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriterSync-length
 * @type {number}
 * @const
 */
FileWriterSync.prototype.length;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriter-write
 * @param {!Blob} blob
 * @return {undefined}
 */
FileWriterSync.prototype.write = function(blob) {};

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriterSync-seek
 * @param {number} offset
 * @return {undefined}
 */
FileWriterSync.prototype.seek = function(offset) {};

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileWriterSync-truncate
 * @param {number} size
 * @return {undefined}
 */
FileWriterSync.prototype.truncate = function(size) {};

/**
 * LocalFileSystemSync interface, implemented by WorkerGlobalScope.
 * @see http://www.w3.org/TR/file-system-api/#idl-def-LocalFileSystemSync
 * @constructor
 */
function LocalFileSystemSync() {}

/**
 * @see http://www.w3.org/TR/file-system-api/
 *     #the-synchronous-filesystem-interface
 * @constructor
 */
function FileSystemSync() {}

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileSystemSync-name
 * @type {string}
 * @const
 */
FileSystemSync.prototype.name;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileSystemSync-root
 * @type {!DirectoryEntrySync}
 * @const
 */
FileSystemSync.prototype.root;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystemSync-requestFileSystemSync-FileSystemSync-unsigned-short-type-unsigned-long-long-size
 * @param {number} type
 * @param {number} size
 * @return {!FileSystemSync}
 */
function requestFileSystemSync(type, size) {}

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-LocalFileSystemSync-requestFileSystemSync-FileSystemSync-unsigned-short-type-unsigned-long-long-size
 * @param {number} type
 * @param {number} size
 * @return {!FileSystemSync}
 */
function webkitRequestFileSystemSync(type, size) {}

/**
 * @see http://www.w3.org/TR/file-system-api/#the-entrysync-interface
 * @constructor
 */
function EntrySync() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-isFile
 * @type {boolean}
 * @const
 */
EntrySync.prototype.isFile;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-isDirectory
 * @type {boolean}
 * @const
 */
EntrySync.prototype.isDirectory;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-name
 * @type {string}
 * @const
 */
EntrySync.prototype.name;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-fullPath
 * @type {string}
 * @const
 */
EntrySync.prototype.fullPath;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-filesystem
 * @type {!FileSystemSync}
 * @const
 */
EntrySync.prototype.filesystem;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-moveTo
 * @param {!DirectoryEntrySync} parent
 * @param {string=} newName
 * @return {!EntrySync}
 */
EntrySync.prototype.moveTo = function(parent, newName) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-copyTo
 * @param {!DirectoryEntrySync} parent
 * @param {string=} newName
 * @return {!EntrySync}
 */
EntrySync.prototype.copyTo = function(parent, newName) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-toURL
 * @param {string=} mimeType
 * @return {string}
 */
EntrySync.prototype.toURL = function(mimeType) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-remove
 * @return {undefined}
 */
EntrySync.prototype.remove = function() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-getMetadata
 * @return {!Metadata}
 */
EntrySync.prototype.getMetadata = function() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-EntrySync-getParent
 * @return {!DirectoryEntrySync}
 */
EntrySync.prototype.getParent = function() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#the-directoryentrysync-interface
 * @constructor
 * @extends {EntrySync}
 */
function DirectoryEntrySync() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntrySync-createReader
 * @return {!DirectoryReaderSync}
 */
DirectoryEntrySync.prototype.createReader = function() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntrySync-getFile
 * @param {string} path
 * @param {Object=} options
 * @return {!FileEntrySync}
 */
DirectoryEntrySync.prototype.getFile = function(path, options) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntrySync-getDirectory
 * @param {string} path
 * @param {Object=} options
 * @return {!DirectoryEntrySync}
 */
DirectoryEntrySync.prototype.getDirectory = function(path, options) {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryEntrySync-removeRecursively
 * @return {undefined}
 */
DirectoryEntrySync.prototype.removeRecursively = function() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#the-directoryreadersync-interface
 * @constructor
 */
function DirectoryReaderSync() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-DirectoryReaderSync-readEntries
 * @return {!Array<!EntrySync>}
 */
DirectoryReaderSync.prototype.readEntries = function() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#the-fileentrysync-interface
 * @constructor
 * @extends {EntrySync}
 */
function FileEntrySync() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileEntrySync-createWriter
 * @return {!FileWriterSync}
 */
FileEntrySync.prototype.createWriter = function() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileEntrySync-file
 * @return {!File}
 */
FileEntrySync.prototype.file = function() {};

/**
 * @see http://www.w3.org/TR/file-system-api/#the-fileexception-exception
 * @constructor
 */
function FileException() {}

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-NOT_FOUND_ERR
 * @type {number}
 */
FileException.prototype.NOT_FOUND_ERR;

/** @type {number} */
FileException.NOT_FOUND_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-SECURITY_ERR
 * @type {number}
 */
FileException.prototype.SECURITY_ERR;

/** @type {number} */
FileException.SECURITY_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#widl-FileException-ABORT_ERR
 * @type {number}
 */
FileException.prototype.ABORT_ERR;

/** @type {number} */
FileException.ABORT_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#widl-FileException-NOT_READABLE_ERR
 * @type {number}
 */
FileException.prototype.NOT_READABLE_ERR;

/** @type {number} */
FileException.NOT_READABLE_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#widl-FileException-ENCODING_ERR
 * @type {number}
 */
FileException.prototype.ENCODING_ERR;

/** @type {number} */
FileException.ENCODING_ERR;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileException-NO_MODIFICATION_ALLOWED_ERR
 * @type {number}
 */
FileException.prototype.NO_MODIFICATION_ALLOWED_ERR;

/** @type {number} */
FileException.NO_MODIFICATION_ALLOWED_ERR;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileException-INVALID_STATE_ERR
 * @type {number}
 */
FileException.prototype.INVALID_STATE_ERR;

/** @type {number} */
FileException.INVALID_STATE_ERR;

/**
 * @see http://www.w3.org/TR/file-writer-api/#widl-FileException-SYNTAX_ERR
 * @type {number}
 */
FileException.prototype.SYNTAX_ERR;

/** @type {number} */
FileException.SYNTAX_ERR;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileException-INVALID_MODIFICATION_ERR
 * @type {number}
 */
FileException.prototype.INVALID_MODIFICATION_ERR;

/** @type {number} */
FileException.INVALID_MODIFICATION_ERR;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileException-QUOTA_EXCEEDED_ERR
 * @type {number}
 */
FileException.prototype.QUOTA_EXCEEDED_ERR;

/** @type {number} */
FileException.QUOTA_EXCEEDED_ERR;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileException-TYPE_MISMATCH_ERR
 * @type {number}
 */
FileException.prototype.TYPE_MISMATCH_ERR;

/** @type {number} */
FileException.TYPE_MISMATCH_ERR;

/**
 * @see http://www.w3.org/TR/file-system-api/#widl-FileException-PATH_EXISTS_ERR
 * @type {number}
 */
FileException.prototype.PATH_EXISTS_ERR;

/** @type {number} */
FileException.PATH_EXISTS_ERR;

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-code-exception
 * @type {number}
 */
FileException.prototype.code;

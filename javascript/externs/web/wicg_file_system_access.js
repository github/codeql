/*
 * Copyright 2020 The Closure Compiler Authors
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
 * File System Access
 * Draft Community Group Report, 18 November 2020
 * @externs
 * @see https://wicg.github.io/file-system-access/
 */



/**
 * @record
 * @struct
 * @see https://wicg.github.io/file-system-access/#dictdef-filesystemhandlepermissiondescriptor
 */
var FileSystemHandlePermissionDescriptor = function() {};

/** @type {undefined|string} */
FileSystemHandlePermissionDescriptor.prototype.mode;


/**
 * @typedef {string}
 * @see https://wicg.github.io/file-system-access/#enumdef-filesystemhandlekind
 */
var FileSystemHandleKind;


/**
 * @interface
 * @see https://wicg.github.io/file-system-access/#api-filesystemhandle
 */
var FileSystemHandle = function() {};

/** @const {!FileSystemHandleKind} */
FileSystemHandle.prototype.kind;

/** @const {string} */
FileSystemHandle.prototype.name;

/**
 * @param {!FileSystemHandle} other
 * @return {!Promise<boolean>}
 */
FileSystemHandle.prototype.isSameEntry = function(other) {};

/**
 * @param {!FileSystemHandlePermissionDescriptor=} opt_descriptor
 * @return {!Promise<!PermissionState>}
 */
FileSystemHandle.prototype.queryPermission = function(opt_descriptor) {};

/**
 * @param {!FileSystemHandlePermissionDescriptor=} opt_descriptor
 * @return {!Promise<!PermissionState>}
 */
FileSystemHandle.prototype.requestPermission = function(opt_descriptor) {};


/**
 * @record
 * @struct
 * @see https://wicg.github.io/file-system-access/#dictdef-filesystemcreatewritableoptions
 */
var FileSystemCreateWritableOptions = function() {};

/** @type {undefined|boolean} */
FileSystemCreateWritableOptions.prototype.keepExistingData;


/**
 * @interface
 * @extends {FileSystemHandle}
 * @see https://wicg.github.io/file-system-access/#api-filesystemfilehandle
 */
var FileSystemFileHandle = function() {};

/**
 * @return {!Promise<!File>}
 */
FileSystemFileHandle.prototype.getFile = function() {};

/**
 * @param {!FileSystemCreateWritableOptions=} opt_options
 * @return {!Promise<!FileSystemWritableFileStream>}
 */
FileSystemFileHandle.prototype.createWritable = function(opt_options) {};


/**
 * @record
 * @struct
 * @see https://wicg.github.io/file-system-access/#dictdef-filesystemgetfileoptions
 */
var FileSystemGetFileOptions = function() {};

/** @type {undefined|boolean} */
FileSystemGetFileOptions.prototype.create;


/**
 * @record
 * @struct
 * @see https://wicg.github.io/file-system-access/#dictdef-filesystemgetdirectoryoptions
 */
var FileSystemGetDirectoryOptions = function() {};

/** @type {undefined|boolean} */
FileSystemGetDirectoryOptions.prototype.create;


/**
 * @record
 * @struct
 * @see https://wicg.github.io/file-system-access/#dictdef-filesystemremoveoptions
 */
var FileSystemRemoveOptions = function() {};

/** @type {undefined|boolean} */
FileSystemRemoveOptions.prototype.recursive;


/**
 * @interface
 * @extends {FileSystemHandle}
 * @extends {AsyncIterable<!Array<string|!FileSystemHandle>>}
 * @see https://wicg.github.io/file-system-access/#api-filesystemdirectoryhandle
 * @see https://wicg.github.io/file-system-access/#api-filesystemdirectoryhandle-asynciterable
 */
var FileSystemDirectoryHandle = function() {};

/**
 * @param {string} name
 * @param {!FileSystemGetFileOptions=} opt_options
 * @return {!Promise<!FileSystemFileHandle>}
 */
FileSystemDirectoryHandle.prototype.getFileHandle = function(name, opt_options) {};

/**
 * @param {string} name
 * @param {!FileSystemGetDirectoryOptions=} opt_options
 * @return {!Promise<!FileSystemDirectoryHandle>}
 */
FileSystemDirectoryHandle.prototype.getDirectoryHandle = function(name, opt_options) {};

/**
 * @param {string} name
 * @param {!FileSystemRemoveOptions=} opt_options
 * @return {!Promise<void>}
 */
FileSystemDirectoryHandle.prototype.removeEntry = function(name, opt_options) {};

/**
 * @param {!FileSystemHandle} possibleDescendant
 * @return {!Promise<?Array<string>>}
 */
FileSystemDirectoryHandle.prototype.resolve = function(possibleDescendant) {};

/**
 * @return {!AsyncIterable<!Array<string|!FileSystemHandle>>}
 * @see https://wicg.github.io/file-system-access/#api-filesystemdirectoryhandle-asynciterable
 */
FileSystemDirectoryHandle.prototype.entries = function() {};

/**
 * @return {!AsyncIterable<!FileSystemHandle>}
 * @see https://wicg.github.io/file-system-access/#api-filesystemdirectoryhandle-asynciterable
 */
FileSystemDirectoryHandle.prototype.values = function() {};

/**
 * @return {!AsyncIterable<string>}
 * @see https://wicg.github.io/file-system-access/#api-filesystemdirectoryhandle-asynciterable
 */
FileSystemDirectoryHandle.prototype.keys = function() {};


/**
 * @typedef {string}
 * @see https://wicg.github.io/file-system-access/#enumdef-writecommandtype
 */
var WriteCommandType;


/**
 * @record
 * @struct
 * @see https://wicg.github.io/file-system-access/#dictdef-writeparams
 */
var WriteParams = function() {};

/** @type {!WriteCommandType} */
WriteParams.prototype.type;

/** @type {undefined|?number} */
WriteParams.prototype.size;

/** @type {undefined|?number} */
WriteParams.prototype.position;

/** @type {undefined|!BufferSource|!Blob|?string} */
WriteParams.prototype.data;


/**
 * @typedef {!BufferSource|!Blob|string|!WriteParams}
 * @see https://wicg.github.io/file-system-access/#typedefdef-filesystemwritechunktype
 */
var FileSystemWriteChunkType;


/**
 * @constructor
 * @extends {WritableStream}
 * @see https://wicg.github.io/file-system-access/#filesystemwritablefilestream
 */
var FileSystemWritableFileStream = function() {};

/**
 * @param {!FileSystemWriteChunkType} data
 * @return {!Promise<void>}
 */
FileSystemWritableFileStream.prototype.write = function(data) {};

/**
 * @param {number} position
 * @return {!Promise<void>}
 */
FileSystemWritableFileStream.prototype.seek = function(position) {};

/**
 * @param {number} size
 * @return {!Promise<void>}
 */
FileSystemWritableFileStream.prototype.truncate = function(size) {};


/**
 * @record
 * @struct
 * @see https://wicg.github.io/file-system-access/#dictdef-filepickeraccepttype
 */
var FilePickerAcceptType = function() {};

/** @type {undefined|string} */
FilePickerAcceptType.prototype.description;

/** @type {undefined|!Object<string,(string|!Array<string>)>} */
FilePickerAcceptType.prototype.accept;


/**
 * @record
 * @struct
 * @see https://wicg.github.io/file-system-access/#dictdef-filepickeroptions
 */
var FilePickerOptions = function() {};

/** @type {undefined|!Array<!FilePickerAcceptType>} */
FilePickerOptions.prototype.types;

/** @type {undefined|boolean} */
FilePickerOptions.prototype.excludeAcceptAllOption;


/**
 * @record
 * @struct
 * @extends {FilePickerOptions}
 * @see https://wicg.github.io/file-system-access/#dictdef-openfilepickeroptions
 */
var OpenFilePickerOptions = function() {};

/** @type {undefined|boolean} */
OpenFilePickerOptions.prototype.multiple;


/**
 * @record
 * @struct
 * @extends {FilePickerOptions}
 * @see https://wicg.github.io/file-system-access/#dictdef-savefilepickeroptions
 */
var SaveFilePickerOptions = function() {};


/**
 * @record
 * @struct
 * @see https://wicg.github.io/file-system-access/#dictdef-directorypickeroptions
 */
var DirectoryPickerOptions = function() {};


/**
 * @param {!OpenFilePickerOptions=} opt_options
 * @return {!Promise<!Array<!FileSystemFileHandle>>}
 * @see https://wicg.github.io/file-system-access/#local-filesystem
 */
Window.prototype.showOpenFilePicker = function(opt_options) {};


/**
 * @param {!SaveFilePickerOptions=} opt_options
 * @return {!Promise<!FileSystemFileHandle>}
 * @see https://wicg.github.io/file-system-access/#local-filesystem
 */
Window.prototype.showSaveFilePicker = function(opt_options) {};


/**
 * @param {!DirectoryPickerOptions=} opt_options
 * @return {!Promise<!FileSystemDirectoryHandle>}
 * @see https://wicg.github.io/file-system-access/#local-filesystem
 */
Window.prototype.showDirectoryPicker = function(opt_options) {};

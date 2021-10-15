/*
 * Copyright 2014 The Closure Compiler Authors.
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
 * @fileoverview W3C Web MIDI specification.
 * @see http://www.w3.org/TR/webmidi/
 *
 * @externs
 */


/**
 * @param {!MIDIOptions=} opt_options
 * @return {!Promise.<!MIDIAccess>}
 */
navigator.requestMIDIAccess = function(opt_options) {};


/**
 * @typedef {{
 *   sysex: boolean
 * }}
 */
var MIDIOptions;



/**
 * @interface
 */
var MIDIInputMap = function() {};


/**
 * @const {number}
 */
MIDIInputMap.prototype.size;


/**
 * @param {function(string)} iterator
 */
MIDIInputMap.prototype.keys = function(iterator) {};


/**
 * @param {function(!Array.<*>)} iterator
 */
MIDIInputMap.prototype.entries = function(iterator) {};


/**
 * @param {function(!MIDIInput)} iterator
 */
MIDIInputMap.prototype.values = function(iterator) {};


/**
 * @param {string} key
 * @return {!MIDIInput}
 */
MIDIInputMap.prototype.get = function(key) {};


/**
 * @param {string} key
 * @return {boolean}
 */
MIDIInputMap.prototype.has = function(key) {};



/**
 * @interface
 */
var MIDIOutputMap = function() {};


/**
 * @const {number}
 */
MIDIOutputMap.prototype.size;


/**
 * @param {function(string)} iterator
 */
MIDIOutputMap.prototype.keys = function(iterator) {};


/**
 * @param {function(!Array.<*>)} iterator
 */
MIDIOutputMap.prototype.entries = function(iterator) {};


/**
 * @param {function(!MIDIOutput)} iterator
 */
MIDIOutputMap.prototype.values = function(iterator) {};


/**
 * @param {string} key
 * @return {!MIDIOutput}
 */
MIDIOutputMap.prototype.get = function(key) {};


/**
 * @param {string} key
 * @return {boolean}
 */
MIDIOutputMap.prototype.has = function(key) {};



/**
 * @interface
 * @extends {EventTarget}
 */
var MIDIAccess = function() {};


/**
 * @const {!MIDIInputMap}
 */
MIDIAccess.prototype.inputs;


/**
 * @const {!MIDIOutputMap}
 */
MIDIAccess.prototype.outputs;


/**
 * @const {function(!MIDIConnectionEvent)}
 */
MIDIAccess.prototype.onconnect;


/**
 * @type {function(!MIDIConnectionEvent)}
 */
MIDIAccess.prototype.ondisconnect;


/**
 * @const {boolean}
 */
MIDIAccess.prototype.sysexEnabled;



/**
 * @interface
 * @extends {EventTarget}
 */
var MIDIPort = function() {};


/**
 * @const {string}
 */
MIDIPort.prototype.id;


/**
 * @const {string}
 */
MIDIPort.prototype.manufacturer;


/**
 * @const {string}
 */
MIDIPort.prototype.name;


/**
 * @const {string}
 */
MIDIPort.prototype.type;


/**
 * @const {string}
 */
MIDIPort.prototype.version;


/**
 * @type {function(!MIDIConnectionEvent)}
 */
MIDIPort.prototype.ondisconnect;



/**
 * @interface
 * @extends {MIDIPort}
 */
var MIDIInput = function() {};


/**
 * @type {function(!MIDIMessageEvent)}
 */
MIDIInput.prototype.onmidimessage;



/**
 * @interface
 * @extends {MIDIPort}
 */
var MIDIOutput = function() {};


/**
 * @param {!Uint8Array} data
 * @param {number=} opt_timestamp
 */
MIDIOutput.prototype.send = function(data, opt_timestamp) {};



/**
 * @constructor
 * @extends {Event}
 * @param {string} type
 * @param {!MIDIMessageEventInit=} opt_init
 */
var MIDIMessageEvent = function(type, opt_init) {};


/**
 * @const {number}
 */
MIDIMessageEvent.prototype.receivedTime;


/**
 * @const {!Uint8Array}
 */
MIDIMessageEvent.prototype.data;


/**
 * @record
 * @extends {EventInit}
 * @see https://www.w3.org/TR/webmidi/#midimessageeventinit-interface
 */
function MIDIMessageEventInit() {}

/** @type {undefined|number} */
MIDIMessageEventInit.prototype.receivedTime;

/** @type {undefined|!Uint8Array} */
MIDIMessageEventInit.prototype.data;



/**
 * @constructor
 * @extends {Event}
 * @param {string} type
 * @param {!MIDIConnectionEventInit=} opt_init
 */
var MIDIConnectionEvent = function(type, opt_init) {};


/**
 * @const {MIDIPort}
 */
MIDIConnectionEvent.prototype.port;


/**
 * @record
 * @extends {EventInit}
 * @see https://www.w3.org/TR/webmidi/#idl-def-MIDIConnectionEventInit
 */
function MIDIConnectionEventInit() {}

/** @type {undefined|!MIDIPort} */
MIDIConnectionEventInit.prototype.port;

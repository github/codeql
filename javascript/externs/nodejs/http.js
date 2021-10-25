// Automatically generated from TypeScript type definitions provided by
// DefinitelyTyped (https://github.com/DefinitelyTyped/DefinitelyTyped),
// which is licensed under the MIT license; see file DefinitelyTyped-LICENSE
// in parent directory.
// Type definitions for Node.js 10.5.x
// Project: http://nodejs.org/
// Definitions by: Microsoft TypeScript <http://typescriptlang.org>
//                 DefinitelyTyped <https://github.com/DefinitelyTyped/DefinitelyTyped>
//                 Parambir Singh <https://github.com/parambirs>
//                 Christian Vaagland Tellnes <https://github.com/tellnes>
//                 Wilco Bakker <https://github.com/WilcoBakker>
//                 Nicolas Voigt <https://github.com/octo-sniffle>
//                 Chigozirim C. <https://github.com/smac89>
//                 Flarna <https://github.com/Flarna>
//                 Mariusz Wiktorczyk <https://github.com/mwiktorczyk>
//                 wwwy3y3 <https://github.com/wwwy3y3>
//                 Deividas Bakanas <https://github.com/DeividasBakanas>
//                 Kelvin Jin <https://github.com/kjin>
//                 Alvis HT Tang <https://github.com/alvis>
//                 Sebastian Silbermann <https://github.com/eps1lon>
//                 Hannes Magnusson <https://github.com/Hannes-Magnusson-CK>
//                 Alberto Schiabel <https://github.com/jkomyno>
//                 Klaus Meinhardt <https://github.com/ajafff>
//                 Huw <https://github.com/hoo29>
//                 Nicolas Even <https://github.com/n-e>
//                 Bruno Scheufler <https://github.com/brunoscheufler>
//                 Mohsen Azimi <https://github.com/mohsen1>
//                 Hoàng Văn Khải <https://github.com/KSXGitHub>
//                 Alexander T. <https://github.com/a-tarasyuk>
//                 Lishude <https://github.com/islishude>
//                 Andrew Makarov <https://github.com/r3nya>
//                 Zane Hannan AU <https://github.com/ZaneHannanAU>
// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped

/**
 * @externs
 * @fileoverview Definitions for module "http"
 */

var http = {};

var net = require("net");

/**
 * @interface
 */
http.RequestOptions = function() {};

/**
 * @type {string}
 */
http.RequestOptions.prototype.protocol;

/**
 * @type {string}
 */
http.RequestOptions.prototype.host;

/**
 * @type {string}
 */
http.RequestOptions.prototype.hostname;

/**
 * @type {number}
 */
http.RequestOptions.prototype.family;

/**
 * @type {number}
 */
http.RequestOptions.prototype.port;

/**
 * @type {string}
 */
http.RequestOptions.prototype.localAddress;

/**
 * @type {string}
 */
http.RequestOptions.prototype.socketPath;

/**
 * @type {string}
 */
http.RequestOptions.prototype.method;

/**
 * @type {string}
 */
http.RequestOptions.prototype.path;

http.RequestOptions.prototype.headers;


/**
 * @type {string}
 */
http.RequestOptions.prototype.auth;

/**
 * @type {(http.Agent|boolean)}
 */
http.RequestOptions.prototype.agent;

/**
 * @interface
 * @extends {net.Server}
 */
http.Server = function() {};

/**
 * @param {number} msecs
 * @param {Function} callback
 * @return {void}
 */
http.Server.prototype.setTimeout = function(msecs, callback) {};

/**
 * @type {number}
 */
http.Server.prototype.maxHeadersCount;

/**
 * @type {number}
 */
http.Server.prototype.timeout;

/**
 * @type {boolean}
 */
http.Server.prototype.listening;

/**
 * @interface
 * @extends {http.IncomingMessage}
 */
http.ServerRequest = function() {};

/**
 * @type {net.Socket}
 */
http.ServerRequest.prototype.connection;

/**
 * @interface
 * @extends {internal.Writable}
 */
http.ServerResponse = function() {};

/**
 * @param {Buffer} buffer
 * @return {boolean}
 */
http.ServerResponse.prototype.write = function(buffer) {};

/**
 * @param {Buffer} buffer
 * @param {Function=} cb
 * @return {boolean}
 */
http.ServerResponse.prototype.write = function(buffer, cb) {};

/**
 * @param {string} str
 * @param {Function=} cb
 * @return {boolean}
 */
http.ServerResponse.prototype.write = function(str, cb) {};

/**
 * @param {string} str
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {boolean}
 */
http.ServerResponse.prototype.write = function(str, encoding, cb) {};

/**
 * @param {string} str
 * @param {string=} encoding
 * @param {string=} fd
 * @return {boolean}
 */
http.ServerResponse.prototype.write = function(str, encoding, fd) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @return {*}
 */
http.ServerResponse.prototype.write = function(chunk, encoding) {};

/**
 * @return {void}
 */
http.ServerResponse.prototype.writeContinue = function() {};

/**
 * @param {number} statusCode
 * @param {string=} reasonPhrase
 * @param {*=} headers
 * @return {void}
 */
http.ServerResponse.prototype.writeHead = function(statusCode, reasonPhrase, headers) {};

/**
 * @param {number} statusCode
 * @param {*=} headers
 * @return {void}
 */
http.ServerResponse.prototype.writeHead = function(statusCode, headers) {};

/**
 * @type {number}
 */
http.ServerResponse.prototype.statusCode;

/**
 * @type {string}
 */
http.ServerResponse.prototype.statusMessage;

/**
 * @type {boolean}
 */
http.ServerResponse.prototype.headersSent;

/**
 * @param {string} name
 * @param {(string|Array<string>)} value
 * @return {void}
 */
http.ServerResponse.prototype.setHeader = function(name, value) {};

/**
 * @param {number} msecs
 * @param {Function} callback
 * @return {http.ServerResponse}
 */
http.ServerResponse.prototype.setTimeout = function(msecs, callback) {};

/**
 * @type {boolean}
 */
http.ServerResponse.prototype.sendDate;

/**
 * @param {string} name
 * @return {string}
 */
http.ServerResponse.prototype.getHeader = function(name) {};

/**
 * @param {string} name
 * @return {void}
 */
http.ServerResponse.prototype.removeHeader = function(name) {};

/**
 * @param {*} headers
 * @return {void}
 */
http.ServerResponse.prototype.addTrailers = function(headers) {};

/**
 * @type {boolean}
 */
http.ServerResponse.prototype.finished;

/**
 * @return {void}
 */
http.ServerResponse.prototype.end = function() {};

/**
 * @param {Buffer} buffer
 * @param {Function=} cb
 * @return {void}
 */
http.ServerResponse.prototype.end = function(buffer, cb) {};

/**
 * @param {string} str
 * @param {Function=} cb
 * @return {void}
 */
http.ServerResponse.prototype.end = function(str, cb) {};

/**
 * @param {string} str
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {void}
 */
http.ServerResponse.prototype.end = function(str, encoding, cb) {};

/**
 * @param {*=} data
 * @param {string=} encoding
 * @return {void}
 */
http.ServerResponse.prototype.end = function(data, encoding) {};

/**
 * @interface
 * @extends {internal.Writable}
 */
http.ClientRequest = function() {};

/**
 * @param {Buffer} buffer
 * @return {boolean}
 */
http.ClientRequest.prototype.write = function(buffer) {};

/**
 * @param {Buffer} buffer
 * @param {Function=} cb
 * @return {boolean}
 */
http.ClientRequest.prototype.write = function(buffer, cb) {};

/**
 * @param {string} str
 * @param {Function=} cb
 * @return {boolean}
 */
http.ClientRequest.prototype.write = function(str, cb) {};

/**
 * @param {string} str
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {boolean}
 */
http.ClientRequest.prototype.write = function(str, encoding, cb) {};

/**
 * @param {string} str
 * @param {string=} encoding
 * @param {string=} fd
 * @return {boolean}
 */
http.ClientRequest.prototype.write = function(str, encoding, fd) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @return {void}
 */
http.ClientRequest.prototype.write = function(chunk, encoding) {};

/**
 * @return {void}
 */
http.ClientRequest.prototype.abort = function() {};

/**
 * @param {number} timeout
 * @param {Function=} callback
 * @return {void}
 */
http.ClientRequest.prototype.setTimeout = function(timeout, callback) {};

/**
 * @param {boolean=} noDelay
 * @return {void}
 */
http.ClientRequest.prototype.setNoDelay = function(noDelay) {};

/**
 * @param {boolean=} enable
 * @param {number=} initialDelay
 * @return {void}
 */
http.ClientRequest.prototype.setSocketKeepAlive = function(enable, initialDelay) {};

/**
 * @param {string} name
 * @param {(string|Array<string>)} value
 * @return {void}
 */
http.ClientRequest.prototype.setHeader = function(name, value) {};

/**
 * @param {string} name
 * @return {string}
 */
http.ClientRequest.prototype.getHeader = function(name) {};

/**
 * @param {string} name
 * @return {void}
 */
http.ClientRequest.prototype.removeHeader = function(name) {};

/**
 * @param {*} headers
 * @return {void}
 */
http.ClientRequest.prototype.addTrailers = function(headers) {};

/**
 * @return {void}
 */
http.ClientRequest.prototype.end = function() {};

/**
 * @param {Buffer} buffer
 * @param {Function=} cb
 * @return {void}
 */
http.ClientRequest.prototype.end = function(buffer, cb) {};

/**
 * @param {string} str
 * @param {Function=} cb
 * @return {void}
 */
http.ClientRequest.prototype.end = function(str, cb) {};

/**
 * @param {string} str
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {void}
 */
http.ClientRequest.prototype.end = function(str, encoding, cb) {};

/**
 * @param {*=} data
 * @param {string=} encoding
 * @return {void}
 */
http.ClientRequest.prototype.end = function(data, encoding) {};

/**
 * @interface
 * @extends {internal.Readable}
 */
http.IncomingMessage = function() {};

/**
 * @type {string}
 */
http.IncomingMessage.prototype.httpVersion;

/**
 * @type {string}
 */
http.IncomingMessage.prototype.httpVersionMajor;

/**
 * @type {string}
 */
http.IncomingMessage.prototype.httpVersionMinor;

/**
 * @type {net.Socket}
 */
http.IncomingMessage.prototype.connection;

/**
 * @type {*}
 */
http.IncomingMessage.prototype.headers;

/**
 * @type {Array<string>}
 */
http.IncomingMessage.prototype.rawHeaders;

/**
 * @type {*}
 */
http.IncomingMessage.prototype.trailers;

/**
 * @type {*}
 */
http.IncomingMessage.prototype.rawTrailers;

/**
 * @param {number} msecs
 * @param {Function} callback
 * @return {NodeJS.Timer}
 */
http.IncomingMessage.prototype.setTimeout = function(msecs, callback) {};

/**
 * @type {string}
 */
http.IncomingMessage.prototype.method;

/**
 * @type {string}
 */
http.IncomingMessage.prototype.url;

/**
 * @type {number}
 */
http.IncomingMessage.prototype.statusCode;

/**
 * @type {string}
 */
http.IncomingMessage.prototype.statusMessage;

/**
 * @type {net.Socket}
 */
http.IncomingMessage.prototype.socket;

/**
 * @param {Error=} error
 * @return {void}
 */
http.IncomingMessage.prototype.destroy = function(error) {};

/**
 * @interface
 * @extends {http.IncomingMessage}
 */
http.ClientResponse = function() {};

/**
 * @interface
 */
http.AgentOptions = function() {};

/**
 * @type {boolean}
 */
http.AgentOptions.prototype.keepAlive;

/**
 * @type {number}
 */
http.AgentOptions.prototype.keepAliveMsecs;

/**
 * @type {number}
 */
http.AgentOptions.prototype.maxSockets;

/**
 * @type {number}
 */
http.AgentOptions.prototype.maxFreeSockets;

/**
 * @param {http.AgentOptions=} opts
 * @return {http.Agent}
 * @constructor
 */
http.Agent = function(opts) {};

/**
 * @type {number}
 */
http.Agent.prototype.maxSockets;

/**
 * @type {*}
 */
http.Agent.prototype.sockets;

/**
 * @type {*}
 */
http.Agent.prototype.requests;

/**
 * @return {void}
 */
http.Agent.prototype.destroy = function() {};

/**
 * @type {Array<string>}
 */
http.METHODS;

http.STATUS_CODES;


/**
 * @param {(function(http.IncomingMessage, http.ServerResponse): void)=} requestListener
 * @return {http.Server}
 */
http.createServer = function(requestListener) {};

/**
 * @param {number=} port
 * @param {string=} host
 * @return {*}
 */
http.createClient = function(port, host) {};

/**
 * @param {http.RequestOptions} options
 * @param {(function(http.IncomingMessage): void)=} callback
 * @return {http.ClientRequest}
 */
http.request = function(options, callback) {};

/**
 * @param {*} options
 * @param {(function(http.IncomingMessage): void)=} callback
 * @return {http.ClientRequest}
 */
http.get = function(options, callback) {};

/**
 * @type {http.Agent}
 */
http.globalAgent;

module.exports.RequestOptions = http.RequestOptions;

module.exports.Server = http.Server;

module.exports.ServerRequest = http.ServerRequest;

module.exports.ServerResponse = http.ServerResponse;

module.exports.ClientRequest = http.ClientRequest;

module.exports.IncomingMessage = http.IncomingMessage;

module.exports.ClientResponse = http.ClientResponse;

module.exports.AgentOptions = http.AgentOptions;

module.exports.Agent = http.Agent;

module.exports.METHODS = http.METHODS;

module.exports.STATUS_CODES = http.STATUS_CODES;

module.exports.createServer = http.createServer;

module.exports.createClient = http.createClient;

module.exports.request = http.request;

module.exports.get = http.get;

module.exports.globalAgent = http.globalAgent;


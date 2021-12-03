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
 * @fileoverview Definitions for module "https"
 */

var https = {};

var tls = require("tls");

var http = require("http");

/**
 * @interface
 */
https.ServerOptions = function() {};

/**
 * @type {*}
 */
https.ServerOptions.prototype.pfx;

/**
 * @type {*}
 */
https.ServerOptions.prototype.key;

/**
 * @type {string}
 */
https.ServerOptions.prototype.passphrase;

/**
 * @type {*}
 */
https.ServerOptions.prototype.cert;

/**
 * @type {*}
 */
https.ServerOptions.prototype.ca;

/**
 * @type {*}
 */
https.ServerOptions.prototype.crl;

/**
 * @type {string}
 */
https.ServerOptions.prototype.ciphers;

/**
 * @type {boolean}
 */
https.ServerOptions.prototype.honorCipherOrder;

/**
 * @type {boolean}
 */
https.ServerOptions.prototype.requestCert;

/**
 * @type {boolean}
 */
https.ServerOptions.prototype.rejectUnauthorized;

/**
 * @type {*}
 */
https.ServerOptions.prototype.NPNProtocols;

/**
 * @type {(function(string, (function(Error, tls.SecureContext): *)): *)}
 */
https.ServerOptions.prototype.SNICallback;

/**
 * @interface
 * @extends {http.RequestOptions}
 */
https.RequestOptions = function() {};

/**
 * @type {*}
 */
https.RequestOptions.prototype.pfx;

/**
 * @type {*}
 */
https.RequestOptions.prototype.key;

/**
 * @type {string}
 */
https.RequestOptions.prototype.passphrase;

/**
 * @type {*}
 */
https.RequestOptions.prototype.cert;

/**
 * @type {*}
 */
https.RequestOptions.prototype.ca;

/**
 * @type {string}
 */
https.RequestOptions.prototype.ciphers;

/**
 * @type {boolean}
 */
https.RequestOptions.prototype.rejectUnauthorized;

/**
 * @type {string}
 */
https.RequestOptions.prototype.secureProtocol;

/**
 * @interface
 * @extends {http.Agent}
 */
https.Agent = function() {};

/**
 * @interface
 * @extends {http.AgentOptions}
 */
https.AgentOptions = function() {};

/**
 * @type {*}
 */
https.AgentOptions.prototype.pfx;

/**
 * @type {*}
 */
https.AgentOptions.prototype.key;

/**
 * @type {string}
 */
https.AgentOptions.prototype.passphrase;

/**
 * @type {*}
 */
https.AgentOptions.prototype.cert;

/**
 * @type {*}
 */
https.AgentOptions.prototype.ca;

/**
 * @type {string}
 */
https.AgentOptions.prototype.ciphers;

/**
 * @type {boolean}
 */
https.AgentOptions.prototype.rejectUnauthorized;

/**
 * @type {string}
 */
https.AgentOptions.prototype.secureProtocol;

/**
 * @type {number}
 */
https.AgentOptions.prototype.maxCachedSessions;

/**
 * @type {(function(new: https.Agent, https.AgentOptions=))}
 */
https.Agent;

/**
 * @interface
 * @extends {tls.Server}
 */
https.Server = function() {};

/**
 * @param {https.ServerOptions} options
 * @param {Function=} requestListener
 * @return {https.Server}
 */
https.createServer = function(options, requestListener) {};

/**
 * @param {https.RequestOptions} options
 * @param {(function(http.IncomingMessage): void)=} callback
 * @return {http.ClientRequest}
 */
https.request = function(options, callback) {};

/**
 * @param {https.RequestOptions} options
 * @param {(function(http.IncomingMessage): void)=} callback
 * @return {http.ClientRequest}
 */
https.get = function(options, callback) {};

/**
 * @type {https.Agent}
 */
https.globalAgent;

module.exports.ServerOptions = https.ServerOptions;

module.exports.RequestOptions = https.RequestOptions;

module.exports.Agent = https.Agent;

module.exports.AgentOptions = https.AgentOptions;

module.exports.Agent = https.Agent;

module.exports.Server = https.Server;

module.exports.createServer = https.createServer;

module.exports.request = https.request;

module.exports.get = https.get;

module.exports.globalAgent = https.globalAgent;


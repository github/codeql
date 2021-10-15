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
 * @fileoverview Definitions for module "tls"
 */

var tls = {};

var crypto = require("crypto");

var net = require("net");

/**
 * @type {number}
 */
var CLIENT_RENEG_LIMIT;

/**
 * @type {number}
 */
var CLIENT_RENEG_WINDOW;

/**
 * @interface
 */
tls.Certificate = function() {};

/**
 * @type {string}
 */
tls.Certificate.prototype.C;

/**
 * @type {string}
 */
tls.Certificate.prototype.ST;

/**
 * @type {string}
 */
tls.Certificate.prototype.L;

/**
 * @type {string}
 */
tls.Certificate.prototype.O;

/**
 * @type {string}
 */
tls.Certificate.prototype.OU;

/**
 * @type {string}
 */
tls.Certificate.prototype.CN;

/**
 * @interface
 */
tls.CipherNameAndProtocol = function() {};

/**
 * @type {string}
 */
tls.CipherNameAndProtocol.prototype.name;

/**
 * @type {string}
 */
tls.CipherNameAndProtocol.prototype.version;

/**
 * @constructor
 * @extends {internal.Duplex}
 */
tls.TLSSocket;

/**
 * @return {{port: number, family: string, address: string}}
 */
tls.TLSSocket.prototype.address = function() {};

/**
 * @type {boolean}
 */
tls.TLSSocket.prototype.authorized;

/**
 * @type {Error}
 */
tls.TLSSocket.prototype.authorizationError;

/**
 * @type {boolean}
 */
tls.TLSSocket.prototype.encrypted;

/**
 * @return {tls.CipherNameAndProtocol}
 */
tls.TLSSocket.prototype.getCipher = function() {};

/**
 * @param {boolean=} detailed
 * @return {{subject: tls.Certificate, issuerInfo: tls.Certificate, issuer: tls.Certificate, raw: *, valid_from: string, valid_to: string, fingerprint: string, serialNumber: string}}
 */
tls.TLSSocket.prototype.getPeerCertificate = function(detailed) {};

/**
 * @return {*}
 */
tls.TLSSocket.prototype.getSession = function() {};

/**
 * @return {*}
 */
tls.TLSSocket.prototype.getTLSTicket = function() {};

/**
 * @type {string}
 */
tls.TLSSocket.prototype.localAddress;

/**
 * @type {string}
 */
tls.TLSSocket.prototype.localPort;

/**
 * @type {string}
 */
tls.TLSSocket.prototype.remoteAddress;

/**
 * @type {string}
 */
tls.TLSSocket.prototype.remoteFamily;

/**
 * @type {number}
 */
tls.TLSSocket.prototype.remotePort;

/**
 * @param {tls.TlsOptions} options
 * @param {(function(Error): *)} callback
 * @return {*}
 */
tls.TLSSocket.prototype.renegotiate = function(options, callback) {};

/**
 * @param {number} size
 * @return {boolean}
 */
tls.TLSSocket.prototype.setMaxSendFragment = function(size) {};

/**
 * @interface
 */
tls.TlsOptions = function() {};

/**
 * @type {string}
 */
tls.TlsOptions.prototype.host;

/**
 * @type {number}
 */
tls.TlsOptions.prototype.port;

/**
 * @type {(string|Array<Buffer>)}
 */
tls.TlsOptions.prototype.pfx;

/**
 * @type {(string|Array<string>|Buffer|Array<*>)}
 */
tls.TlsOptions.prototype.key;

/**
 * @type {string}
 */
tls.TlsOptions.prototype.passphrase;

/**
 * @type {(string|Array<string>|Buffer|Array<Buffer>)}
 */
tls.TlsOptions.prototype.cert;

/**
 * @type {(string|Array<string>|Buffer|Array<Buffer>)}
 */
tls.TlsOptions.prototype.ca;

/**
 * @type {(string|Array<string>)}
 */
tls.TlsOptions.prototype.crl;

/**
 * @type {string}
 */
tls.TlsOptions.prototype.ciphers;

/**
 * @type {boolean}
 */
tls.TlsOptions.prototype.honorCipherOrder;

/**
 * @type {boolean}
 */
tls.TlsOptions.prototype.requestCert;

/**
 * @type {boolean}
 */
tls.TlsOptions.prototype.rejectUnauthorized;

/**
 * @type {(Array<string>|Buffer)}
 */
tls.TlsOptions.prototype.NPNProtocols;

/**
 * @type {(function(string, (function(Error, tls.SecureContext): *)): *)}
 */
tls.TlsOptions.prototype.SNICallback;

/**
 * @type {string}
 */
tls.TlsOptions.prototype.ecdhCurve;

/**
 * @type {(string|Buffer)}
 */
tls.TlsOptions.prototype.dhparam;

/**
 * @type {number}
 */
tls.TlsOptions.prototype.handshakeTimeout;

/**
 * @type {(Array<string>|Buffer)}
 */
tls.TlsOptions.prototype.ALPNProtocols;

/**
 * @type {number}
 */
tls.TlsOptions.prototype.sessionTimeout;

/**
 * @type {*}
 */
tls.TlsOptions.prototype.ticketKeys;

/**
 * @type {string}
 */
tls.TlsOptions.prototype.sessionIdContext;

/**
 * @type {string}
 */
tls.TlsOptions.prototype.secureProtocol;

/**
 * @interface
 */
tls.ConnectionOptions = function() {};

/**
 * @type {string}
 */
tls.ConnectionOptions.prototype.host;

/**
 * @type {number}
 */
tls.ConnectionOptions.prototype.port;

/**
 * @type {net.Socket}
 */
tls.ConnectionOptions.prototype.socket;

/**
 * @type {(string|Buffer)}
 */
tls.ConnectionOptions.prototype.pfx;

/**
 * @type {(string|Array<string>|Buffer|Array<Buffer>)}
 */
tls.ConnectionOptions.prototype.key;

/**
 * @type {string}
 */
tls.ConnectionOptions.prototype.passphrase;

/**
 * @type {(string|Array<string>|Buffer|Array<Buffer>)}
 */
tls.ConnectionOptions.prototype.cert;

/**
 * @type {(string|Buffer|Array<(string|Buffer)>)}
 */
tls.ConnectionOptions.prototype.ca;

/**
 * @type {boolean}
 */
tls.ConnectionOptions.prototype.rejectUnauthorized;

/**
 * @type {Array<(string|Buffer)>}
 */
tls.ConnectionOptions.prototype.NPNProtocols;

/**
 * @type {string}
 */
tls.ConnectionOptions.prototype.servername;

/**
 * @type {string}
 */
tls.ConnectionOptions.prototype.path;

/**
 * @type {Array<(string|Buffer)>}
 */
tls.ConnectionOptions.prototype.ALPNProtocols;

/**
 * @type {(function(string, (string|Buffer|Array<(string|Buffer)>)): *)}
 */
tls.ConnectionOptions.prototype.checkServerIdentity;

/**
 * @type {string}
 */
tls.ConnectionOptions.prototype.secureProtocol;

/**
 * @type {Object}
 */
tls.ConnectionOptions.prototype.secureContext;

/**
 * @type {Buffer}
 */
tls.ConnectionOptions.prototype.session;

/**
 * @type {number}
 */
tls.ConnectionOptions.prototype.minDHSize;

/**
 * @interface
 * @extends {net.Server}
 */
tls.Server = function() {};

/**
 * @return {tls.Server}
 */
tls.Server.prototype.close = function() {};

/**
 * @return {{port: number, family: string, address: string}}
 */
tls.Server.prototype.address = function() {};

/**
 * @param {string} hostName
 * @param {{key: string, cert: string, ca: string}} credentials
 * @return {void}
 */
tls.Server.prototype.addContext = function(hostName, credentials) {};

/**
 * @type {number}
 */
tls.Server.prototype.maxConnections;

/**
 * @type {number}
 */
tls.Server.prototype.connections;

/**
 * @interface
 * @extends {internal.Duplex}
 */
tls.ClearTextStream = function() {};

/**
 * @type {boolean}
 */
tls.ClearTextStream.prototype.authorized;

/**
 * @type {Error}
 */
tls.ClearTextStream.prototype.authorizationError;

/**
 * @return {*}
 */
tls.ClearTextStream.prototype.getPeerCertificate = function() {};

tls.ClearTextStream.prototype.getCipher;

/**
 * @type {string}
 */
tls.ClearTextStream.prototype.getCipher.name;

/**
 * @type {string}
 */
tls.ClearTextStream.prototype.getCipher.version;


tls.ClearTextStream.prototype.address;

/**
 * @type {number}
 */
tls.ClearTextStream.prototype.address.port;

/**
 * @type {string}
 */
tls.ClearTextStream.prototype.address.family;

/**
 * @type {string}
 */
tls.ClearTextStream.prototype.address.address;


/**
 * @type {string}
 */
tls.ClearTextStream.prototype.remoteAddress;

/**
 * @type {number}
 */
tls.ClearTextStream.prototype.remotePort;

/**
 * @interface
 */
tls.SecurePair = function() {};

/**
 * @type {*}
 */
tls.SecurePair.prototype.encrypted;

/**
 * @type {*}
 */
tls.SecurePair.prototype.cleartext;

/**
 * @interface
 */
tls.SecureContextOptions = function() {};

/**
 * @type {(string|Buffer)}
 */
tls.SecureContextOptions.prototype.pfx;

/**
 * @type {(string|Buffer)}
 */
tls.SecureContextOptions.prototype.key;

/**
 * @type {string}
 */
tls.SecureContextOptions.prototype.passphrase;

/**
 * @type {(string|Buffer)}
 */
tls.SecureContextOptions.prototype.cert;

/**
 * @type {(string|Buffer)}
 */
tls.SecureContextOptions.prototype.ca;

/**
 * @type {(string|Array<string>)}
 */
tls.SecureContextOptions.prototype.crl;

/**
 * @type {string}
 */
tls.SecureContextOptions.prototype.ciphers;

/**
 * @type {boolean}
 */
tls.SecureContextOptions.prototype.honorCipherOrder;

/**
 * @interface
 */
tls.SecureContext = function() {};

/**
 * @type {*}
 */
tls.SecureContext.prototype.context;

/**
 * @param {tls.TlsOptions} options
 * @param {(function(tls.ClearTextStream): void)=} secureConnectionListener
 * @return {tls.Server}
 */
tls.createServer = function(options, secureConnectionListener) {};

/**
 * @param {tls.ConnectionOptions} options
 * @param {(function(): void)=} secureConnectionListener
 * @return {tls.ClearTextStream}
 */
tls.connect = function(options, secureConnectionListener) {};

/**
 * @param {number} port
 * @param {string=} host
 * @param {tls.ConnectionOptions=} options
 * @param {(function(): void)=} secureConnectListener
 * @return {tls.ClearTextStream}
 */
tls.connect = function(port, host, options, secureConnectListener) {};

/**
 * @param {number} port
 * @param {tls.ConnectionOptions=} options
 * @param {(function(): void)=} secureConnectListener
 * @return {tls.ClearTextStream}
 */
tls.connect = function(port, options, secureConnectListener) {};

/**
 * @param {crypto.Credentials=} credentials
 * @param {boolean=} isServer
 * @param {boolean=} requestCert
 * @param {boolean=} rejectUnauthorized
 * @return {tls.SecurePair}
 */
tls.createSecurePair = function(credentials, isServer, requestCert, rejectUnauthorized) {};

/**
 * @param {tls.SecureContextOptions} details
 * @return {tls.SecureContext}
 */
tls.createSecureContext = function(details) {};

module.exports.Certificate = tls.Certificate;

module.exports.CipherNameAndProtocol = tls.CipherNameAndProtocol;

module.exports.TLSSocket = tls.TLSSocket;

module.exports.TlsOptions = tls.TlsOptions;

module.exports.ConnectionOptions = tls.ConnectionOptions;

module.exports.Server = tls.Server;

module.exports.ClearTextStream = tls.ClearTextStream;

module.exports.SecurePair = tls.SecurePair;

module.exports.SecureContextOptions = tls.SecureContextOptions;

module.exports.SecureContext = tls.SecureContext;

module.exports.createServer = tls.createServer;

module.exports.connect = tls.connect;

module.exports.connect = tls.connect;

module.exports.connect = tls.connect;

module.exports.createSecurePair = tls.createSecurePair;

module.exports.createSecureContext = tls.createSecureContext;

module.exports.CLIENT_RENEG_WINDOW = CLIENT_RENEG_WINDOW;

module.exports.CLIENT_RENEG_LIMIT = CLIENT_RENEG_LIMIT;

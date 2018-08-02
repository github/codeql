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
 * @fileoverview Definitions for module "dns"
 */

var dns = {};

/**
 * @interface
 */
dns.MxRecord = function() {};

/**
 * @type {string}
 */
dns.MxRecord.prototype.exchange;

/**
 * @type {number}
 */
dns.MxRecord.prototype.priority;

/**
 * @param {string} domain
 * @param {number} family
 * @param {(function(Error, string, number): void)} callback
 * @return {string}
 */
dns.lookup = function(domain, family, callback) {};

/**
 * @param {string} domain
 * @param {(function(Error, string, number): void)} callback
 * @return {string}
 */
dns.lookup = function(domain, callback) {};

/**
 * @param {string} domain
 * @param {string} rrtype
 * @param {(function(Error, Array<string>): void)} callback
 * @return {Array<string>}
 */
dns.resolve = function(domain, rrtype, callback) {};

/**
 * @param {string} domain
 * @param {(function(Error, Array<string>): void)} callback
 * @return {Array<string>}
 */
dns.resolve = function(domain, callback) {};

/**
 * @param {string} domain
 * @param {(function(Error, Array<string>): void)} callback
 * @return {Array<string>}
 */
dns.resolve4 = function(domain, callback) {};

/**
 * @param {string} domain
 * @param {(function(Error, Array<string>): void)} callback
 * @return {Array<string>}
 */
dns.resolve6 = function(domain, callback) {};

/**
 * @param {string} domain
 * @param {(function(Error, Array<dns.MxRecord>): void)} callback
 * @return {Array<string>}
 */
dns.resolveMx = function(domain, callback) {};

/**
 * @param {string} domain
 * @param {(function(Error, Array<string>): void)} callback
 * @return {Array<string>}
 */
dns.resolveTxt = function(domain, callback) {};

/**
 * @param {string} domain
 * @param {(function(Error, Array<string>): void)} callback
 * @return {Array<string>}
 */
dns.resolveSrv = function(domain, callback) {};

/**
 * @param {string} domain
 * @param {(function(Error, Array<string>): void)} callback
 * @return {Array<string>}
 */
dns.resolveNs = function(domain, callback) {};

/**
 * @param {string} domain
 * @param {(function(Error, Array<string>): void)} callback
 * @return {Array<string>}
 */
dns.resolveCname = function(domain, callback) {};

/**
 * @param {string} ip
 * @param {(function(Error, Array<string>): void)} callback
 * @return {Array<string>}
 */
dns.reverse = function(ip, callback) {};

/**
 * @param {Array<string>} servers
 * @return {void}
 */
dns.setServers = function(servers) {};

/**
 * @type {string}
 */
dns.NODATA;

/**
 * @type {string}
 */
dns.FORMERR;

/**
 * @type {string}
 */
dns.SERVFAIL;

/**
 * @type {string}
 */
dns.NOTFOUND;

/**
 * @type {string}
 */
dns.NOTIMP;

/**
 * @type {string}
 */
dns.REFUSED;

/**
 * @type {string}
 */
dns.BADQUERY;

/**
 * @type {string}
 */
dns.BADNAME;

/**
 * @type {string}
 */
dns.BADFAMILY;

/**
 * @type {string}
 */
dns.BADRESP;

/**
 * @type {string}
 */
dns.CONNREFUSED;

/**
 * @type {string}
 */
dns.TIMEOUT;

/**
 * @type {string}
 */
dns.EOF;

/**
 * @type {string}
 */
dns.FILE;

/**
 * @type {string}
 */
dns.NOMEM;

/**
 * @type {string}
 */
dns.DESTRUCTION;

/**
 * @type {string}
 */
dns.BADSTR;

/**
 * @type {string}
 */
dns.BADFLAGS;

/**
 * @type {string}
 */
dns.NONAME;

/**
 * @type {string}
 */
dns.BADHINTS;

/**
 * @type {string}
 */
dns.NOTINITIALIZED;

/**
 * @type {string}
 */
dns.LOADIPHLPAPI;

/**
 * @type {string}
 */
dns.ADDRGETNETWORKPARAMS;

/**
 * @type {string}
 */
dns.CANCELLED;

module.exports.MxRecord = dns.MxRecord;

module.exports.lookup = dns.lookup;

module.exports.lookup = dns.lookup;

module.exports.resolve = dns.resolve;

module.exports.resolve = dns.resolve;

module.exports.resolve4 = dns.resolve4;

module.exports.resolve6 = dns.resolve6;

module.exports.resolveMx = dns.resolveMx;

module.exports.resolveTxt = dns.resolveTxt;

module.exports.resolveSrv = dns.resolveSrv;

module.exports.resolveNs = dns.resolveNs;

module.exports.resolveCname = dns.resolveCname;

module.exports.reverse = dns.reverse;

module.exports.setServers = dns.setServers;

module.exports.NODATA = dns.NODATA;

module.exports.FORMERR = dns.FORMERR;

module.exports.SERVFAIL = dns.SERVFAIL;

module.exports.NOTFOUND = dns.NOTFOUND;

module.exports.NOTIMP = dns.NOTIMP;

module.exports.REFUSED = dns.REFUSED;

module.exports.BADQUERY = dns.BADQUERY;

module.exports.BADNAME = dns.BADNAME;

module.exports.BADFAMILY = dns.BADFAMILY;

module.exports.BADRESP = dns.BADRESP;

module.exports.CONNREFUSED = dns.CONNREFUSED;

module.exports.TIMEOUT = dns.TIMEOUT;

module.exports.EOF = dns.EOF;

module.exports.FILE = dns.FILE;

module.exports.NOMEM = dns.NOMEM;

module.exports.DESTRUCTION = dns.DESTRUCTION;

module.exports.BADSTR = dns.BADSTR;

module.exports.BADFLAGS = dns.BADFLAGS;

module.exports.NONAME = dns.NONAME;

module.exports.BADHINTS = dns.BADHINTS;

module.exports.NOTINITIALIZED = dns.NOTINITIALIZED;

module.exports.LOADIPHLPAPI = dns.LOADIPHLPAPI;

module.exports.ADDRGETNETWORKPARAMS = dns.ADDRGETNETWORKPARAMS;

module.exports.CANCELLED = dns.CANCELLED;


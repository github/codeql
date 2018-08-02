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
 * @fileoverview Definitions for module "os"
 */

var os = {};

/**
 * @interface
 */
os.CpuInfo = function() {};

/**
 * @type {string}
 */
os.CpuInfo.prototype.model;

/**
 * @type {number}
 */
os.CpuInfo.prototype.speed;

os.CpuInfo.prototype.times;

/**
 * @type {number}
 */
os.CpuInfo.prototype.times.user;

/**
 * @type {number}
 */
os.CpuInfo.prototype.times.nice;

/**
 * @type {number}
 */
os.CpuInfo.prototype.times.sys;

/**
 * @type {number}
 */
os.CpuInfo.prototype.times.idle;

/**
 * @type {number}
 */
os.CpuInfo.prototype.times.irq;


/**
 * @interface
 */
os.NetworkInterfaceInfo = function() {};

/**
 * @type {string}
 */
os.NetworkInterfaceInfo.prototype.address;

/**
 * @type {string}
 */
os.NetworkInterfaceInfo.prototype.netmask;

/**
 * @type {string}
 */
os.NetworkInterfaceInfo.prototype.family;

/**
 * @type {string}
 */
os.NetworkInterfaceInfo.prototype.mac;

/**
 * @type {boolean}
 */
os.NetworkInterfaceInfo.prototype.internal;

/**
 * @return {string}
 */
os.hostname = function() {};

/**
 * @return {Array<number>}
 */
os.loadavg = function() {};

/**
 * @return {number}
 */
os.uptime = function() {};

/**
 * @return {number}
 */
os.freemem = function() {};

/**
 * @return {number}
 */
os.totalmem = function() {};

/**
 * @return {Array<os.CpuInfo>}
 */
os.cpus = function() {};

/**
 * @return {string}
 */
os.type = function() {};

/**
 * @return {string}
 */
os.release = function() {};

/**
 * @return {Object<string,Array<os.NetworkInterfaceInfo>>}
 */
os.networkInterfaces = function() {};

/**
 * @return {string}
 */
os.homedir = function() {};

/**
 * @param {{encoding: string}=} options
 * @return {{username: string, uid: number, gid: number, shell: *, homedir: string}}
 */
os.userInfo = function(options) {};

os.constants;

/**
 * @type {number}
 */
os.constants.UV_UDP_REUSEADDR;

/**
 * @type {{SIGHUP: number, SIGINT: number, SIGQUIT: number, SIGILL: number, SIGTRAP: number, SIGABRT: number, SIGIOT: number, SIGBUS: number, SIGFPE: number, SIGKILL: number, SIGUSR1: number, SIGSEGV: number, SIGUSR2: number, SIGPIPE: number, SIGALRM: number, SIGTERM: number, SIGCHLD: number, SIGSTKFLT: number, SIGCONT: number, SIGSTOP: number, SIGTSTP: number, SIGTTIN: number, SIGTTOU: number, SIGURG: number, SIGXCPU: number, SIGXFSZ: number, SIGVTALRM: number, SIGPROF: number, SIGWINCH: number, SIGIO: number, SIGPOLL: number, SIGPWR: number, SIGSYS: number, SIGUNUSED: number}}
 */
os.constants.errno;

/**
 * @type {{E2BIG: number, EACCES: number, EADDRINUSE: number, EADDRNOTAVAIL: number, EAFNOSUPPORT: number, EAGAIN: number, EALREADY: number, EBADF: number, EBADMSG: number, EBUSY: number, ECANCELED: number, ECHILD: number, ECONNABORTED: number, ECONNREFUSED: number, ECONNRESET: number, EDEADLK: number, EDESTADDRREQ: number, EDOM: number, EDQUOT: number, EEXIST: number, EFAULT: number, EFBIG: number, EHOSTUNREACH: number, EIDRM: number, EILSEQ: number, EINPROGRESS: number, EINTR: number, EINVAL: number, EIO: number, EISCONN: number, EISDIR: number, ELOOP: number, EMFILE: number, EMLINK: number, EMSGSIZE: number, EMULTIHOP: number, ENAMETOOLONG: number, ENETDOWN: number, ENETRESET: number, ENETUNREACH: number, ENFILE: number, ENOBUFS: number, ENODATA: number, ENODEV: number, ENOENT: number, ENOEXEC: number, ENOLCK: number, ENOLINK: number, ENOMEM: number, ENOMSG: number, ENOPROTOOPT: number, ENOSPC: number, ENOSR: number, ENOSTR: number, ENOSYS: number, ENOTCONN: number, ENOTDIR: number, ENOTEMPTY: number, ENOTSOCK: number, ENOTSUP: number, ENOTTY: number, ENXIO: number, EOPNOTSUPP: number, EOVERFLOW: number, EPERM: number, EPIPE: number, EPROTO: number, EPROTONOSUPPORT: number, EPROTOTYPE: number, ERANGE: number, EROFS: number, ESPIPE: number, ESRCH: number, ESTALE: number, ETIME: number, ETIMEDOUT: number, ETXTBSY: number, EWOULDBLOCK: number, EXDEV: number}}
 */
os.constants.signals;


/**
 * @return {string}
 */
os.arch = function() {};

/**
 * @return {string}
 */
os.platform = function() {};

/**
 * @return {string}
 */
os.tmpdir = function() {};

/**
 * @type {string}
 */
os.EOL;

/**
 * @return {(string)}
 */
os.endianness = function() {};

module.exports.CpuInfo = os.CpuInfo;

module.exports.NetworkInterfaceInfo = os.NetworkInterfaceInfo;

module.exports.hostname = os.hostname;

module.exports.loadavg = os.loadavg;

module.exports.uptime = os.uptime;

module.exports.freemem = os.freemem;

module.exports.totalmem = os.totalmem;

module.exports.cpus = os.cpus;

module.exports.type = os.type;

module.exports.release = os.release;

module.exports.networkInterfaces = os.networkInterfaces;

module.exports.homedir = os.homedir;

module.exports.userInfo = os.userInfo;

module.exports.constants = os.constants;

module.exports.arch = os.arch;

module.exports.platform = os.platform;

module.exports.tmpdir = os.tmpdir;

module.exports.EOL = os.EOL;

module.exports.endianness = os.endianness;

/**
 * @return {string}
 */
os.tmpDir = function() {};

module.exports.tmpDir = os.tmpDir;


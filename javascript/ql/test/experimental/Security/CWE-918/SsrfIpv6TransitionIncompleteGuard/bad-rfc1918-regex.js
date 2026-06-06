const http = require('http');

// BAD: a hand-written RFC 1918 / loopback / metadata denylist matched against the
// host string. The embedded IPv4 inside `::ffff:10.0.0.1` is never seen.
function checkTargetHost(host) { // NOT OK
  if (
    host === '127.0.0.1' ||
    host === '169.254.169.254' ||
    host.startsWith('10.') ||
    host.startsWith('192.168') ||
    host.startsWith('172.16')
  ) {
    throw new Error('blocked internal host');
  }
  return http.get('http://' + host + '/');
}

module.exports = { checkTargetHost };

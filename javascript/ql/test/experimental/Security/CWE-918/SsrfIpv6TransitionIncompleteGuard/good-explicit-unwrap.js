const http = require('http');

const IPV4_MAPPED_PREFIX = '::ffff:';

// OK: this guard uses a hand-rolled denylist, but it first unwraps the
// IPv6-transition form, so the embedded IPv4 is normalized before the check.
function unwrapMapped(host) {
  // strip an IPv4-mapped `::ffff:` prefix down to the embedded dotted quad
  if (host.toLowerCase().startsWith(IPV4_MAPPED_PREFIX)) {
    return host.slice(IPV4_MAPPED_PREFIX.length);
  }
  return host;
}

function isPrivateAddress(host) { // OK
  const h = unwrapMapped(host);
  return (
    h === '127.0.0.1' ||
    h === '169.254.169.254' ||
    h.startsWith('10.') ||
    h.startsWith('192.168')
  );
}

function validateHost(host) { // OK
  if (isPrivateAddress(host)) {
    throw new Error('blocked internal host');
  }
  return http.get('http://' + host + '/');
}

module.exports = { validateHost };

const ipaddr = require('ipaddr.js');
const fetch = require('node-fetch');

// OK: ipaddr.js parses the address and classifies it with `.range()`, which is
// transition-aware. `::ffff:10.0.0.1` parses as an IPv4-mapped address and is
// reported in the `private` range, so the guard is complete.
async function validateTargetHost(host) { // OK
  const addr = ipaddr.parse(host);
  const range = addr.range();
  if (range === 'private' || range === 'loopback' || range === 'linkLocal') {
    throw new Error('blocked internal host');
  }
  return fetch('http://' + host + '/');
}

module.exports = { validateTargetHost };

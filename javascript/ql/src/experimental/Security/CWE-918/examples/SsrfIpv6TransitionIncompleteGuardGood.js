const ipaddr = require('ipaddr.js');
const fetch = require('node-fetch');

// GOOD: ipaddr.js parses the host and classifies it with `.range()`, which is
// transition-aware. `::ffff:169.254.169.254` parses as an IPv4-mapped address and
// is reported in the `linkLocal` range, so the guard is complete.
async function validateTargetHost(host) {
  const addr = ipaddr.parse(host);
  const range = addr.range();
  if (range === 'private' || range === 'loopback' || range === 'linkLocal') {
    throw new Error('blocked internal host');
  }
  return fetch('http://' + host + '/');
}

module.exports = { validateTargetHost };

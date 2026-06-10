const isPrivate = require('private-ip');
const fetch = require('node-fetch');

// BAD: `private-ip` classifies the textual IPv4 form only. It returns false for
// `::ffff:169.254.169.254`, so a transition-wrapped internal address slips past.
async function validateUrlHost(host) { // NOT OK
  if (isPrivate(host)) {
    throw new Error('blocked private host');
  }
  return fetch('http://' + host + '/');
}

module.exports = { validateUrlHost };

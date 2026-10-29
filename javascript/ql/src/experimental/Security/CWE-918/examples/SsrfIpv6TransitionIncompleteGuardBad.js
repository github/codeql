const isPrivate = require('private-ip');
const fetch = require('node-fetch');

// BAD: `private-ip` classifies the textual IPv4 form only, so it returns false
// for `::ffff:169.254.169.254`. The guard treats the wrapped internal address as
// public, but the request still reaches the metadata endpoint.
async function validateUrlHost(host) {
  if (isPrivate(host)) {
    throw new Error('blocked private host');
  }
  return fetch('http://' + host + '/');
}

module.exports = { validateUrlHost };

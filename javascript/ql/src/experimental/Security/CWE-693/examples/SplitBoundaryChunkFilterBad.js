const { Transform } = require('stream');
const EMAIL = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g;

// BAD: each chunk is matched on its own; an address split across two chunks is forwarded as is
const redact = new Transform({
  transform(chunk, encoding, callback) {
    callback(null, chunk.toString().replace(EMAIL, '[REDACTED]'));
  },
});

const { Transform } = require('stream');
const EMAIL = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g;
const HOLD = 64; // longer than any address the pattern can match

// GOOD: the last HOLD characters are carried into the next chunk and released at the end
class Redact extends Transform {
  constructor() {
    super();
    this.tail = '';
  }
  _transform(chunk, encoding, callback) {
    const joined = this.tail + chunk.toString();
    const out = joined.replace(EMAIL, '[REDACTED]');
    this.tail = out.slice(-HOLD);
    callback(null, out.slice(0, -HOLD));
  }
  _flush(callback) {
    callback(null, this.tail.replace(EMAIL, '[REDACTED]'));
  }
}

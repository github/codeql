const { Transform } = require('stream');
const EMAIL = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g;

// --- positives: a multi-character pattern applied to one chunk, no state carried ---

// P1 Node Transform subclass
class RedactA extends Transform {
  _transform(chunk, enc, cb) {
    cb(null, chunk.toString().replace(EMAIL, '[REDACTED]')); // $ Alert
  }
}

// P2 Transform options object
const t2 = new Transform({
  transform(chunk, enc, cb) {
    const text = chunk.toString('utf8');
    cb(null, text.replace(/\b\d{3}-\d{2}-\d{4}\b/g, '[SSN]')); // $ Alert
  },
});

// P3 Web TransformStream
const t3 = new TransformStream({
  transform(chunk, controller) {
    controller.enqueue(chunk.replaceAll(EMAIL, '[REDACTED]')); // $ Alert
  },
});

// P4 for await over an LLM stream, delta field
async function* redactDeltas(stream) {
  for await (const chunk of stream) {
    const delta = chunk.choices[0].delta.content;
    yield delta.replace(EMAIL, '[REDACTED]'); // $ Alert
  }
}

// P5 'data' event listener
function pipe(src, dst) {
  src.on('data', (data) => {
    dst.write(String(data).replace(/sk-[A-Za-z0-9]{20,}/g, '[KEY]')); // $ Alert
  });
}

// P6 detection only (test/exec) still a per-chunk decision
const t6 = new Transform({
  transform(chunk, enc, cb) {
    if (/-----BEGIN [A-Z ]*PRIVATE KEY-----/.test(chunk.toString())) return cb(new Error('blocked')); // $ Alert
    cb(null, chunk);
  },
});

// P7 TextDecoder in a TransformStream
const dec = new TextDecoder();
const t7 = new TransformStream({
  transform(chunk, controller) {
    const s = dec.decode(chunk, { stream: true });
    controller.enqueue(s.replace(EMAIL, '[REDACTED]')); // $ Alert
  },
});

// P8 new RegExp from a string with a quantifier
const t8 = new Transform({
  transform(chunk, enc, cb) {
    cb(null, chunk.toString().replace(new RegExp('[0-9]{9,}', 'g'), '#')); // $ Alert
  },
});

// --- negatives ---

// N1 buffer to the end, pattern applied once in flush
class BufferAll extends Transform {
  constructor() { super(); this.buf = ''; }
  _transform(chunk, enc, cb) { this.buf += chunk; cb(); }
  _flush(cb) { cb(null, this.buf.replace(EMAIL, '[REDACTED]')); }
}

// N2 bounded hold-back: the pattern runs on tail + chunk and the tail is carried
class HoldBack extends Transform {
  constructor() { super(); this.tail = ''; }
  _transform(chunk, enc, cb) {
    const joined = this.tail + chunk.toString();
    const out = joined.replace(EMAIL, '[REDACTED]');
    this.tail = out.slice(-64);
    cb(null, out.slice(0, -64));
  }
  _flush(cb) { cb(null, this.tail); }
}

// N3 single-character pattern cannot straddle
const n3 = new Transform({
  transform(chunk, enc, cb) { cb(null, chunk.toString().replace(/\n/g, ' ')); },
});

// N4 not a stream callback: whole string
function redactWhole(text) {
  return text.replace(EMAIL, '[REDACTED]');
}

// N5 chunk used but the pattern runs on something else
const n5 = new Transform({
  transform(chunk, enc, cb) {
    const label = 'chunk';
    cb(null, label.replace(/un/, 'UN') + chunk);
  },
});

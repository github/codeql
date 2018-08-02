var q = { ...o, x: 42, ...p };
let { x, ...r } = q, { z } = {};

// semmle-extractor-options: --experimental
function createCached(fn) {
  return async function (...args) {
    return fn(...args);
  };
}

module.exports = { createCached };

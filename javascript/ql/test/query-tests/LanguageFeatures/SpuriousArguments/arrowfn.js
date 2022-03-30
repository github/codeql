function makeMultiplier() {
  // `arguments` should refer to `makeMultiplier`'s arguments.
  return (n) => [].slice.call(arguments).reduce((a, b) => a * b) * n;
}

makeMultiplier(3, 4)(5);
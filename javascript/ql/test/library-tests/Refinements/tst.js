var global;

function f(x, y) {
  (typeof x) === 'function';  // refinement
  typeof global === 'object'; // not a refinement
  x === y;                    // not a refinement
  true;                       // refinement
  (typeof x)[0] === 'u';      // refinement
}
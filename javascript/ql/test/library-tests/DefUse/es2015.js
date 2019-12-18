for (let fn in fns)
  fn();

function getSquares() {
  return [for (i of [0, 1, 2]) i*i];
}

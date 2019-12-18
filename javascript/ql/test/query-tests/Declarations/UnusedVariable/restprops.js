function f(o) {
  let { x, ...ys } = o;
  return ys;
}

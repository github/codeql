new (x => x);

(function(x) {
  return x+19;
})(23);

/x/;

function foo(array) {
  for (let key of array) { key; }
  for (let { key } of array) { key; }
}

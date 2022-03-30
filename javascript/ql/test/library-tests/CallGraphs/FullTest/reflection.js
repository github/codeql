function add(x, y) {
  return x+y;
}
if (sneaky())
  add.apply = function() { return 56; };

add.call(null, 23, 19);
add.apply(null, [23, 19]);

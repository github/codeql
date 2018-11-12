function tag(strings, ...values) {
  return "values: " + values.join(', ');
}

var x = 23;
var y = 19;
`${x} + ${y} = ${x + y}`;
tag `${x} + ${y} = ${x + y}`;
var x = 1;
var y = 2;
var foo = x && y;
var bar = x &&= y;
console.log(x); // 2

x &&= y;
x ||= y;
x ??= y;

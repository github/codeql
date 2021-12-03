var x = 42, y = 19;

console.log(let (x = 23, y = 19) x + y);

console.log(x - y);

JSON.stringify(let (x = 23, y = 19) { x: x, y: y});

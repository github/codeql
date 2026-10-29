process.argv.map(::console.log);

let hasOwnProp = Object.prototype.hasOwnProperty;
let obj = { x: 100 };
obj::hasOwnProp("x");
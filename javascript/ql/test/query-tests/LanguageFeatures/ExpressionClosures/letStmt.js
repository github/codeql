var x = 42, y = 19;

let (x = 23, y = 19) {
  console.log(x + y);
} // $ TODO-SPURIOUS: Alert

console.log(x - y);

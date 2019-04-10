function foo() {
  let obj = { x: source() };
  
  sink(obj.x); // NOT OK

  if (isSafe(obj.x)) {
    sink(obj.x); // OK
  }

  if (typeof obj === "object" && isSafe(obj.x)) {
    sink(obj.x); // OK
  }

  if (isSafe(obj.x) && typeof obj === "object") {
    sink(obj.x); // OK
  }
}

function f() {
  let y = false;
  for (const x of [1, 2, 3]) {
    if (x > 0) {
        y = true; // OK
        continue;
    }
    return;
  }
  if (!y) {
    console.log("Hello");
  }
}

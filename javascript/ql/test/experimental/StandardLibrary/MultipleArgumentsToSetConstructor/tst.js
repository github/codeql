let xs = [1, 2, 3];
let ys = [4, 5, 6];
new Set(...xs, ...ys); // NOT OK
new Set([...xs, ...ys]); // OK
new Set(xs); // OK
new Set(); // OK
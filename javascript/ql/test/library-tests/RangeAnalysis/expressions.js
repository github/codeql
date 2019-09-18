function f(arr) {
  if (arr.length > 2) {} // OK
  
  let x = arr.length || 0;
  if (x > 2) {} // OK
  
  let y = arr.length && 3;
  if (y > 2) {} // OK
}

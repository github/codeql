// BAD: Loop upper bound is off-by-one
for (var i = 0; i <= args.length; i++) {
  console.log(args[i]);
}

// BAD: Loop upper bound is off-by-one
for (var i = 0; args.length >= i; i++) {
  console.log(args[i]);
}

// GOOD: Loop upper bound is correct
for (var i = 0; i < args.length; i++) {
  console.log(args[i]);
}

var j = 0;
// BAD: Off-by-one on index validity check
if (j <= args.length) {
  console.log(args[j]);
}

// BAD: Off-by-one on index validity check
if (args.length >= j) {
  console.log(args[j]);
}

// GOOD: Correct terminating value
if (args.length > j) {
  console.log(args[j]);
}

// BAD: incorrect upper bound
function badContains(a, elt) {
  for (let i = 0; i <= a.length; ++i)
    if (a[i] === elt)
      return true;
  return false;
}

// GOOD: correct upper bound
function goodContains(a, elt) {
  for (let i = 0; i < a.length; ++i)
    if (a[i] === elt)
      return true;
  return false;
}

// this is arguably OK, but we flag it
function same(a, b) {
  for (var i=0; i < a.length || i < b.length ; ++i)
    if (i <= a.length && i <= b.length && a[i] !== b[i])
      return false;
  return true;
}

// GOOD: incorrect upper bound, but extra check
function badContains(a, elt) {
  for (let i = 0; i <= a.length; ++i)
    if (i !== a.length && a[i] === elt)
      return true;
  return false;
}

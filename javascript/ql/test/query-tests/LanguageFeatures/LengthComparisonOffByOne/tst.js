for (var i = 0; i <= args.length; i++) { // $ Alert - Loop upper bound is off-by-one
  console.log(args[i]);
}

for (var i = 0; args.length >= i; i++) { // $ Alert - Loop upper bound is off-by-one
  console.log(args[i]);
}

// OK - Loop upper bound is correct
for (var i = 0; i < args.length; i++) {
  console.log(args[i]);
}

var j = 0;
if (j <= args.length) { // $ Alert - Off-by-one on index validity check
  console.log(args[j]);
}

if (args.length >= j) { // $ Alert - Off-by-one on index validity check
  console.log(args[j]);
}

// OK - Correct terminating value
if (args.length > j) {
  console.log(args[j]);
}

function badContains(a, elt) { // incorrect upper bound
  for (let i = 0; i <= a.length; ++i) // $ Alert
    if (a[i] === elt)
      return true;
  return false;
}

// OK - correct upper bound
function goodContains(a, elt) {
  for (let i = 0; i < a.length; ++i)
    if (a[i] === elt)
      return true;
  return false;
}

// this is arguably OK, but we flag it
function same(a, b) {
  for (var i=0; i < a.length || i < b.length ; ++i)
    if (i <= a.length && i <= b.length && a[i] !== b[i]) // $ Alert
      return false;
  return true;
}

// OK - incorrect upper bound, but extra check
function badContains(a, elt) {
  for (let i = 0; i <= a.length; ++i)
    if (i !== a.length && a[i] === elt)
      return true;
  return false;
}

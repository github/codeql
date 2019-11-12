// NOT OK
[1, 2, 3].map(function(x) x * x);

// OK
[1, 2, 3].map(function(x) { return x * x; });

// OK
[1, 2, 3].map((x) => x * x);

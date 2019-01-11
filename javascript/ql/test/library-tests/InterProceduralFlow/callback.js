function call(f, x) {
  return f(x);
}

function map(f, xs) {
  const res = [];
  for (let i=0;i<xs.length;++i)
    res[i] = f(xs[i]);
  return res;
}

function store(x) {
  let sink = x;
}

let source = "source";
let source2 = "source2";
call(store, source);
call(store, confounder); // call with different argument to make sure the call graph builder
                         // doesn't resolve the call on line 2 for us
map(store, [source2]);

// semmle-extractor-options: --source-type module

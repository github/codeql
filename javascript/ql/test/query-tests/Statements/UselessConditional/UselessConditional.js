function getLastLine(input) {
  var lines = [], nextLine;
  while ((nextLine = readNextLine(input)))
    lines.push(nextLine);
  if (!lines)
    throw new Error("No lines!");
  return lines[lines.length-1];
}

function lookup(cache, k) {
  var v;
  return k in cache ? cache[k] : (v = new Entry(recompute())) && (cache[k] = v);
}

function test(a, b) {
  if (!a && !b) {
    if (a);
    if (b);
  }
  if (!(a || b)) {
    if (a);
    if (b);
  }

  var x = new X();
  if(x){}
  if (new X()){}
  if((x)){}
  if(((x))){}
  if ((new X())){}

  x = 0n;
  if (x) // NOT OK
    ;
}

async function awaitFlow(){
    var v;

    if (y)
        v = await f()

    if (v) { // OK
    }
}

(function(){
    function knownF() {
        return false;
    }
    var known = knownF();
    if (known)
        return;
    if (known)
        return;

    var unknown = unknownF();
    if (unknown)
        return;
    if (unknown) // NOT OK
        return;
});

(function (...x) {
    x || y // NOT OK
});

(function() {
    function f1(x) {
        x || y // NOT OK, but whitelisted
    }
    f1(true);

    function f2(x) {
        while (true)
            x || y // NOT OK
    }
    f2(true);

    function f3(x) {
        (function(){
            x || y // NOT OK
        });
    }
    f3(true);
});

(function() {
    if ((x, true));
});

(function (x, y) {
    if (!x) {
        while (x) { // NOT OK
            f();
        }
        while (true) { // OK
            break;
        }
        if (true && true) {} // NOT OK
        if (y && x) {} // NOT OK
        if (y && (x)) {} // NOT OK
        do { } while (x); // NOT OK
    }
});

// semmle-extractor-options: --experimental

(function() {
  var source = "tainted";
  let a = [source];
  let [tainted] = a;
  let sink = tainted;

  let b = { p: source };
  let { p: tainted2 } = b;
  let sink2 = tainted2;
})();

function f({ p, q: r }, o) {
  let { s } = o;
  let sink1 = p;
  let sink2 = r;
  let sink3 = s;
}

var source1 = "tainted";
var source2 = "also tainted";
var source3 = "still tainted";
f({ p: source1, q: source2 }, { s: source3 });

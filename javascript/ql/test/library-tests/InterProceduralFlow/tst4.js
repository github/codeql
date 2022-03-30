(function(p) {
  let source = "tainted";

  function id(x) {
    return x;
  }

  function substr(x) {
    return x.substring(2);
  }

  var still_tainted = source.substring(2);
  p.also_tainted = still_tainted;

  let sink1 = id(still_tainted);
  let sink2 = p.also_tainted;
  let sink3 = substr(source);
});

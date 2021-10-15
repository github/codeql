(function() {
  var source1 = "src1";
  var sink1 = String(source1),
      sink2 = RegExp(source1),
      sink3 = new String(source1),
      sink4 = new String(source1),
      sink5 = RegExp("test", source1);

  var m = /.*\?(.*)/.exec(source1);
  if (m) {
    var sink6 = m[0];
  }

  var sink6 = decodeURI(source1),
      sink7 = decodeURIComponent(source1),
      sink8 = encodeURI(source1),
      sink9 = encodeURIComponent(source1);

  var sink10 = JSON.parse(source1),
      sink11 = JSON.stringify(sink10);

  var foo = source1;
  foo += ";";
  var sink12 = foo;

  var a = [ source1 ];
  a.forEach(function(elt, i, ary) {
      var sink13 = elt,
          sink14 = i,
          sink15 = ary;
  });

  var dict = {};
  var key = computeKey();
  dict[key] = source1;
  var sink16 = dict[key];

  function f(x) {
    var sink1 = x;
    if (x) {
      var sink2 = x;
    } else {
      x = {};
    }
    var sink3 = x;
    function inner() {
      var sink4 = x;
    }
    inner();
  }
  f(source1);

  var o = {
    p: source1,
    q: "not tainted"
  };
  o.r = source1;
  var sink17 = o;
  var sink18 = o.p;
  var sink19 = o.q;
  var sink20 = o.r;
  var sink21 = o.foo;

  function g(src) {
    function inner() {
      return src;
    }
    var sink = inner();
  }
  g(source1);

  function h(hSrc) {
    function outer() {
      function inner() {
        return outerSrc;
      }
      var outerSrc = hSrc;
      return inner();
    }
    var sink = outer();
  }
  h(source1);

  o.notTracked = source1;
  var sink22 = o.notTracked;

  var sink23 = source1.replaceAll(/f/g, ""); 
  var sink24 = "foo".replaceAll(/f/g, source1); 
})();

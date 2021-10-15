(function() {
  var source = "tainted";
  var a = new A();
  a.someProp = source;
  var sink = a.someProp;
  var sink2 = a.b.someProp;

  f(a);
});

function f(x) {
  var sink3 = x.someProp;
  var tmp1 = x, tmp2 = x + "";
  var sink4 = tmp1.someProp; // `source` flows here...
  var sink5 = tmp2.someProp; // ...but not here
}

var yet_another_source = "tainted as well";
window.foo = yet_another_source;
var yet_another_sink = window.foo;

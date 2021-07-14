function foo() { return "noopener noreferrer"; }
var o = { rel: "noopener noreferrer "};

// OK
<a href="http://example.com" target="_blank" rel="noopener noreferrer">Example</a>;
<a href="http://example.com" target="_blank" rel="noreferrer">Example</a>;
<a href="http://example.com" target="_blank" rel="noopener">Example</a>;
<a href="http://example.com" target="_blank" rel={foo()}>Example</a>;
<a href="http://example.com" target="_blank" {...o}>Example</a>;
<a data-ng-href="https://example.com" target="_blank" rel="noopener">Example</a>;

// OK, because of constant URL
<a href="http://example.com" target="_blank">Example</a>;
<a href="http://example.com" target="_blank" rel="nopoener">Example</a>;
<a data-ng-href="https://example.com" target="_blank">Example</a>;

// NOT OK, because of dynamic URL
<a href="{{X}}" target="_blank">Example</a>;
<a href="{{X}}" target="_blank" rel="nopoener">Example</a>;
<a data-ng-href="{{X}}" target="_blank">Example</a>;

function f() {
  // OK
  var a1 = $("<a/>", { href: "http://example.com" });
  a1.attr("target", "_blank");

  // OK
  var a2 = $("<a/>", { href: "http://example.com" });
  a2.attr("target", "_blank");
  a2.attr(computedName(), "noopener");

  // NOT OK
  var a3 = $("<a/>", { href: "{{X}}" });
  a3.attr("target", "_blank");

  // OK
  var a4 = $("<a/>");
  a4[f()] = g();
  a4.attr("target", "_blank");

  // NOT OK
  var a5 = $("<a/>");
  a5.attr("href", g());
  a5.attr("target", "_blank");
}

// OK, because of dynamic URL with fixed host
<a href="https://example.com/{{X}}" target="_blank">Example</a>;
<a href="https://ex-ample.com/{{X}}" target="_blank">Example</a>;
<a href="HTTPS://EXAMPLE.COM/{{X}}" target="_blank">Example</a>;
<a href="http://example.com/{{X}}" target="_blank">Example</a>;
<a href="//example.com/{{X}}" target="_blank">Example</a>;
<a href="//www.example.com/{{X}}" target="_blank">Example</a>;

// OK, because of dynamic URL with relative path
<a href="./{{X}}" target="_blank">Example</a>;
<a href="../{{X}}" target="_blank">Example</a>;
<a href="index.html/{{X}}" target="_blank">Example</a>;
<a href="../index.html/{{X}}" target="_blank">Example</a>;
<a href="/{{X}}" target="_blank">Example</a>;

// OK, Flask application with internal links
<a href="{{url_for('foo.html', 'foo')}}" target="_blank">Example</a>;
<a href="{{ url_for('foo.html', 'foo')}}" target="_blank">Example</a>;
<a href="{{ 	url_for('foo.html', 'foo')}}" target="_blank">Example</a>;
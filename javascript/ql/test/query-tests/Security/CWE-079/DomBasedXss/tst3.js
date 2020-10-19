var foo = document.getElementById("foo");
var data = JSON.parse(decodeURIComponent(window.location.search.substr(1)));

foo.setAttribute("src", data.src); // NOT OK
foo.setAttribute("HREF", data.p);  // NOT OK
foo.setAttribute("width", data.w); // OK
foo.setAttribute("xlink:href", data.p) // NOT OK

foo.setAttributeNS('xlink', 'href', data.p); // NOT OK
foo.setAttributeNS('foobar', 'href', data.p); // NOT OK
foo.setAttributeNS('baz', 'width', data.w); // OK


for (var p in data)
  foo.setAttribute(p, data[p]); // not flagged since attribute name is unknown

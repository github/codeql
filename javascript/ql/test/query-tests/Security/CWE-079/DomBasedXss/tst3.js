var foo = document.getElementById("foo");
var data = JSON.parse(decodeURIComponent(window.location.search.substr(1))); // $ Source

foo.setAttribute("src", data.src); // $ Alert
foo.setAttribute("HREF", data.p);  // $ Alert
foo.setAttribute("width", data.w);
foo.setAttribute("xlink:href", data.p) // $ Alert

foo.setAttributeNS('xlink', 'href', data.p); // $ Alert
foo.setAttributeNS('foobar', 'href', data.p); // $ Alert
foo.setAttributeNS('baz', 'width', data.w);


for (var p in data)
  foo.setAttribute(p, data[p]); // not flagged since attribute name is unknown

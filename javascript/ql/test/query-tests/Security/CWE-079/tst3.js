var foo = document.getElementById("foo");
var data = JSON.parse(decodeURIComponent(window.location.search.substr(1)));
for (var p in data)
  foo.setAttribute(p, data[p]);

function test() {
  var tainted = document.location.search

  $(tainted);                        // OK - location.search starts with '?'
  $("body", tainted);                // OK
  $("." + tainted);                  // OK
  $("<div id=\"" + tainted + "\">"); // NOT OK
  $("body").html("XSS: " + tainted); // NOT OK
  $(window.location.hash);           // OK - location.hash starts with '#'
  $("<b>" + location.toString() + "</b>"); // NOT OK

  // Not related to jQuery, but the handling of $() should not affect this sink
  let elm = document.getElementById('x');
  elm.innerHTML = decodeURIComponent(window.location.hash); // NOT OK
  elm.innerHTML = decodeURIComponent(window.location.search); // NOT OK
  elm.innerHTML = decodeURIComponent(window.location.toString()); // NOT OK
}

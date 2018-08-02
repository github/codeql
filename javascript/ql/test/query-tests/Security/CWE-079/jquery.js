function test() {
  var tainted = document.location.search

  $(tainted);                        // NOT OK
  $("body", tainted);                // OK
  $("." + tainted);                  // OK
  $("<div id=\"" + tainted + "\">"); // NOT OK
  $("body").html("XSS: " + tainted); // NOT OK
  $(window.location.hash);           // OK
}

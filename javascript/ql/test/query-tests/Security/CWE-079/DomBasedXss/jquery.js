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

  let hash = window.location.hash;
  $(hash); // OK - start with '#'

  $(hash.substring(1)); // NOT OK
  $(hash.substring(1, 10)); // NOT OK
  $(hash.substr(1)); // NOT OK
  $(hash.slice(1)); // NOT OK
  $(hash.substring(0, 10)); // OK

  $(hash.replace('#', '')); // NOT OK
  $(window.location.search.replace('?', '')); // NOT OK
  $(hash.replace('!', '')); // OK
  $(hash.replace('blah', '')); // OK

  $(hash + 'blah'); // OK
  $('blah' + hash); // OK - does not start with '<'
  $('<b>' + hash + '</b>'); // NOT OK

  $('#foo').replaceWith(tainted); // NOT OK
  $('#foo').replaceWith(() => tainted); // NOT OK
}

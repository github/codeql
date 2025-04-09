function test() {
  var tainted = document.location.search // $ Source

  $(tainted);                        // OK - location.search starts with '?'
  $("body", tainted);
  $("." + tainted);
  $("<div id=\"" + tainted + "\">"); // $ Alert
  $("body").html("XSS: " + tainted); // $ Alert
  $(window.location.hash);           // OK - location.hash starts with '#'
  $("<b>" + location.toString() + "</b>"); // $ Alert

  // Not related to jQuery, but the handling of $() should not affect this sink
  let elm = document.getElementById('x');
  elm.innerHTML = decodeURIComponent(window.location.hash); // $ Alert
  elm.innerHTML = decodeURIComponent(window.location.search); // $ Alert
  elm.innerHTML = decodeURIComponent(window.location.toString()); // $ Alert

  let hash = window.location.hash; // $ Source
  $(hash); // OK - start with '#'

  $(hash.substring(1)); // $ Alert
  $(hash.substring(1, 10)); // $ Alert
  $(hash.substr(1)); // $ Alert
  $(hash.slice(1)); // $ Alert
  $(hash.substring(0, 10));

  $(hash.replace('#', '')); // $ Alert
  $(window.location.search.replace('?', '')); // $ Alert
  $(hash.replace('!', ''));
  $(hash.replace('blah', ''));

  $(hash + 'blah');
  $('blah' + hash); // OK - does not start with '<'
  $('<b>' + hash + '</b>'); // $ Alert

  $('#foo').replaceWith(tainted); // $ Alert
  $('#foo').replaceWith(() => tainted); // $ Alert
}

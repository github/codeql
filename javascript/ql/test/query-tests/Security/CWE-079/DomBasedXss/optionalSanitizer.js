function test() {
  var target = document.location.search // $ Source

  $('myId').html(sanitize ? DOMPurify.sanitize(target) : target);

  $('myId').html(target); // $ Alert

  var tainted = target;
  $('myId').html(tainted); // $ Alert
  if (sanitize) {
    tainted = DOMPurify.sanitize(tainted);
  }
  $('myId').html(tainted);

  inner(target);
  function inner(x) {
    $('myId').html(x); // $ Alert
    if (sanitize) {
      x = DOMPurify.sanitize(x);
    }
    $('myId').html(x);
  }
}

function badSanitizer() {
  var target = document.location.search // $ Source

  function sanitizeBad(x) {
    return x; // No sanitization;
  }
  var tainted2 = target;
  $('myId').html(tainted2); // $ Alert
  if (sanitize) {
    tainted2 = sanitizeBad(tainted2);
  }
  $('myId').html(tainted2); // $ Alert

  var tainted3 = target;
  $('myId').html(tainted3); // $ Alert
  if (sanitize) {
    tainted3 = sanitizeBad(tainted3);
  }
  $('myId').html(tainted3); // $ Alert

  $('myId').html(sanitize ? sanitizeBad(target) : target); // $ Alert
}

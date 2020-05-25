function test() {
  var target = document.location.search

  $('myId').html(sanitize ? DOMPurify.sanitize(target) : target); // OK

  $('myId').html(target); // NOT OK

  var tainted = target;
  $('myId').html(tainted); // NOT OK
  if (sanitize) {
    tainted = DOMPurify.sanitize(tainted);
  }
  $('myId').html(tainted); // OK

  inner(target);
  function inner(x) {
    $('myId').html(x); // NOT OK
    if (sanitize) {
      x = DOMPurify.sanitize(x);
    }
    $('myId').html(x); // OK
  }
}

function badSanitizer() {
  var target = document.location.search

  function sanitizeBad(x) {
    return x; // No sanitization;
  }
  var tainted2 = target;
  $('myId').html(tainted2); // NOT OK
  if (sanitize) {
    tainted2 = sanitizeBad(tainted2);
  }
  $('myId').html(tainted2); // NOT OK

  var tainted3 = target;
  $('myId').html(tainted3); // NOT OK
  if (sanitize) {
    tainted3 = sanitizeBad(tainted3);
  }
  $('myId').html(tainted3); // NOT OK

  $('myId').html(sanitize ? sanitizeBad(target) : target); // NOT OK
}

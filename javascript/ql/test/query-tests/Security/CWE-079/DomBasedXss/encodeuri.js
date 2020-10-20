function test() {
  let loc = window.location.href;
  $('<a href="' + encodeURIComponent(loc) + '">click</a>'); // OK
}

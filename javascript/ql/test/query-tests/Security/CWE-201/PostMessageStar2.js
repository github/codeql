window.parent.postMessage(password, '*'); // $ Alert

(function() {
  var data = {};
  data.foo = password; // $ Source
  data.bar = "unproblematic";

  window.parent.postMessage(data, '*');     // $ Alert
  window.parent.postMessage(data.foo, '*'); // $ Alert
  window.parent.postMessage(data.bar, '*');
})();

window.parent.postMessage(authKey, '*'); // $ Alert

window.setTimeout(";"); // $ Alert
setInterval("update();"); // $ Alert
setInterval(update);
document.write("alert('Hi!');"); // $ Alert
window.execScript("debugger;"); // $ Alert

(function(global) {
  var document = global.document;
  document.write("undefined = 2"); // $ Alert
})(this);

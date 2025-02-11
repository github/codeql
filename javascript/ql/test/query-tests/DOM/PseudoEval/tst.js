window.setTimeout(";"); // $ TODO-SPURIOUS: Alert
setInterval("update();"); // $ TODO-SPURIOUS: Alert
setInterval(update);
document.write("alert('Hi!');"); // $ TODO-SPURIOUS: Alert
window.execScript("debugger;"); // $ TODO-SPURIOUS: Alert

(function(global) {
  var document = global.document;
  document.write("undefined = 2"); // $ TODO-SPURIOUS: Alert
})(this);

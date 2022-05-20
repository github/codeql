window.setTimeout(";");
setInterval("update();");
setInterval(update);
document.write("alert('Hi!');");
window.execScript("debugger;");

(function(global) {
  var document = global.document;
  document.write("undefined = 2");
})(this);

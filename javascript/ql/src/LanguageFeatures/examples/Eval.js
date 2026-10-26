function Point(x, y) {
	this.x = x;
	this.y = y;
}

["x", "y"].forEach(function(p) {
	eval("Point.prototype.get_" + p + " = function() {" +
	     "  return this." + p + ";" +
	     "}");
	eval("Point.prototype.set_" + p + " = function(v) {" +
	     "  if (typeof v !== 'number')" +
	     "    throw Error('number expected');" +
	     "  this." + p + " = v;" +
	     "}");
});
function Point(x, y) {
	this.x = x;
	this.y = y;
}

["x", "y"].forEach(function(p) {
	Point.prototype["get_" + p] = new Function("",
		"return this." + p + ";");
	Point.prototype["set_" + p] = new Function("v",
		"if (typeof v !== 'number')" +
		"  throw Error('number expected');" +
	    "  this." + p + " = v;");
});
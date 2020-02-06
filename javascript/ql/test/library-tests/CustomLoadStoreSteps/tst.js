// When the source code states that "foo" is being read, "bar" is additionally being read.

(function () {
	var source = "source";
	var tainted = { bar: source };
	function readTaint(x) {
		return x.foo;
	}
	sink(readTaint(tainted));
})();
// When the source code states that "foo" is being read, "bar" is additionally being read.

(function () {
	var source = "source";
	var tainted = { bar: source };
	function readTaint(x) {
		return x.foo;
	}
	sink(readTaint(tainted)); // NOT OK
	
	
	var tainted2 = {myProp: source};
	
	var tainted3 = tainted2.copy("myProp", "other");
	sink(tainted3.other); // NOT OK.
	
	var tainted4 = tainted2.copy("other", "myProp"); // does nothing, there is no "other" on tainted2.
	sink(tainted4.other); // OK. 
	
})();
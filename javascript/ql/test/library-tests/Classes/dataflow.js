(function () {
	var source = "source";
	
	class Foo {
		#priv = source;
		getPriv() {
			return this.#priv;
		}
		
		getFalsePrivate() {
			return this["#priv"]; // not the same field as above. But we currently don't distinguish private and "public" fields.  
		}
	}
	sink(new Foo().getPriv()); // NOT OK.
	
	sink(new Foo().getFalsePrivate()); // OK [FP: Is FP because we do nothing special about dataflow for private fields.]
})();
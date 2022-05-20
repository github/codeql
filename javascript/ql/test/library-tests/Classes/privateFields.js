class Foo {
	#privDecl = 3;
	#if = "if"; // "keywords" are ok.
	reads() {
		var foo = this.#privUse;
		var bar = this["#publicComputed"]
		var baz = this.#if;
	}
	
	equals(o) {
		return this.#privDecl === o.#privDecl;
	}
	
	writes() {
		this.#privDecl = 4;		
		this["#public"] = 5;
	}
	
	#privSecond; // is a PropNode, not a PropRef. Doesn't matter.
	
	["#publicField"] = 6;
	
	calls() {
		this.#privDecl();
		new this.#privDecl();
	}
}

class C {
  #brand;

  #method() {}

  get #getter() {}

  static isC(obj) {
    return #brand in obj && #method in obj && #getter in obj;
  }
}
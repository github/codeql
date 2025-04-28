class Baz {
  baz() {
    /** calls:Baz.greet */
    this.greet();
  }
  /** name:Baz.greet */
  greet() {}
}

/** name:Baz.shout */
Baz.prototype.shout = function() {};
/** name:Baz.staticShout */
Baz.staticShout = function() {};

function foo(baz){
  /** calls:Baz.greet */
  baz.greet();
  /** calls:Baz.shout */
  baz.shout();
  /** calls:Baz.staticShout */
  Baz.staticShout();
}

const baz = new Baz();
foo(baz);

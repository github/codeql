import 'dummy'

class Baz {
  baz() {
    console.log("Baz baz");
    /** calls:Baz.greet calls:Derived.greet1 calls:BazExtented.greet2 */
    this.greet();
  }
  /** name:Baz.greet */
  greet() { console.log("Baz greet"); }
}

/** name:Baz.shout */
Baz.prototype.shout = function() { console.log("Baz shout"); };
/** name:Baz.staticShout */
Baz.staticShout = function() { console.log("Baz staticShout"); };

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

class Derived extends Baz {
  /** name:Derived.greet1 */
  greet() {
    console.log("Derived greet");
    super.greet();
  }

  /** name:Derived.shout1 */
  shout() {
    console.log("Derived shout");
    super.shout();
  }
}

function bar(derived){
  /** calls:Derived.greet1 */
  derived.greet();
  /** calls:Derived.shout1 */
  derived.shout();
}

bar(new Derived());

class BazExtented {
  constructor() {
    console.log("BazExtented construct");
  }

  /** name:BazExtented.greet2 */
  greet() { 
    console.log("BazExtented greet");
    /** calls:Baz.greet */
    Baz.prototype.greet.call(this); 
  };
}

BazExtented.prototype = Object.create(Baz.prototype);
BazExtented.prototype.constructor = BazExtented;
BazExtented.staticShout = Baz.staticShout;

/** name:BazExtented.talk */
BazExtented.prototype.talk = function() { console.log("BazExtented talk"); };

/** name:BazExtented.shout2 */
BazExtented.prototype.shout = function() { 
  console.log("BazExtented shout");
  /** calls:Baz.shout */
  Baz.prototype.shout.call(this); 
};

function barbar(bazExtented){
  /** calls:BazExtented.talk */
  bazExtented.talk();
  /** calls:BazExtented.shout2 */
  bazExtented.shout();
  /** calls:BazExtented.greet2 */
  bazExtented.greet();
  /** calls:Baz.staticShout */
  BazExtented.staticShout();
}

barbar(new BazExtented());

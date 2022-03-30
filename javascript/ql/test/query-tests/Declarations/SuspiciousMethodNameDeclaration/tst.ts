var foo: MyInterface = 123 as any;

interface MyInterface {
  function (): number; // OK. Highly unlikely that it is an accident when there are other named methods in the interface.
  (): number; // OK: What was probably meant above. 
  new:() => void; // OK! This is a property, not a method, we ignore those.
  constructor(): string; // NOT OK! This a called "constructor"
  new(): Date; // OK! This a constructor signature.

  myNumber: 123; 
}

var a : MyFunction = null as any;

interface MyFunction {
  function(): number; // NOT OK!
}


class Foo {
  new(): number { // OK! Highly unlikely that a developer confuses "constructor" and "new" when both are present. 
    return 123;
  }
  constructor() { // OK! This is a constructor.

  }
  myString = "foobar"
  
  myMethod(): boolean {
    return Math.random() > 0.5;
  }
}

var b : FunctionClass = new FunctionClass();

declare class FunctionClass {
  function(): number; // NOT OK:
}

class Baz {
    new(): Baz { // OK! When there is a method body I assume the developer knows what they are doing.
        return null as any;
    }
}


declare class Quz {
  new(): Quz; // NOT OK! The developer likely meant to write constructor.
}

var bla = new Foo();
var blab = new Baz();

var foo: MyInterface = 123 as any;

interface MyInterface {
  function (): number; // OK - Highly unlikely that it is an accident when there are other named methods in the interface.
  (): number; // OK - What was probably meant above.
  new:() => void; // OK - This is a property, not a method, we ignore those.
  constructor(): string; // $ Alert - This a called "constructor"
  new(): Date; // OK - This a constructor signature.

  myNumber: 123; 
}

var a : MyFunction = null as any;

interface MyFunction {
  function(): number; // $ Alert
}


class Foo {
  new(): number { // OK - Highly unlikely that a developer confuses "constructor" and "new" when both are present.
    return 123;
  }
  constructor() { // OK - This is a constructor.

  }
  myString = "foobar"
  
  myMethod(): boolean {
    return Math.random() > 0.5;
  }
}

var b : FunctionClass = new FunctionClass();

declare class FunctionClass {
  function(): number; // $ Alert
}

class Baz {
    new(): Baz { // OK - When there is a method body I assume the developer knows what they are doing.
        return null as any;
    }
}


declare class Quz {
  new(): Quz; // $ Alert - The developer likely meant to write constructor.
}

var bla = new Foo();
var blab = new Baz();


interface X {
  constructor: () => string; // Just a property, not a method.
}

type A = {
  function(): number; // $ Alert
};

type B = {
  constructor(): number; // $ Alert
  new(): number;
};

class StaticMethods {
  static function(): void {}
  static new(): void {}
}

interface Overloaded {
  function(x: string): string; // $Alert
  function(x: number): number; // $Alert
  function(x: any): any; // $Alert
}

abstract class AbstractFoo {
  abstract new(): void; // $Alert
}

abstract class AbstractFooFunction {
  abstract function(): number; // $Alert
}

abstract class AbstractFooConstructor {
  constructor(){}
}

declare module "some-module" {
  interface ModuleInterface {
    function(): void;  // $Alert
  }
}

type Intersection = {
  function(): number; // $Alert
} & {
  other(): string;
};

type Union = {
  new(): number;
} | {
  valid(): string;
};

type Union2 = {
  constructor(): number; // $Alert
} | {
  valid(): string;
};

type Intersection2 = {
  constructor(): number; // $Alert
} & {
  other(): string;
};

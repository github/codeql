abstract class C {
  abstract (x: number): number; // Note: Method named 'abstract'
  abstract new (x: number): C;  // Note: Abstract method named 'new'
}

interface I {
  (x: number): number;
  new (x: number): C;
  [x: number]: string;
}

var x : {
  (x: number): number;
  new (x: number): C;
  [x: number]: string;
}

interface IOverloads {
  foo(x: number);
  foo(x: string);
  bar();
  foo(x: number);
}

abstract class COverloads {
  abstract foo(x: number);
  abstract foo(x: string);
  abstract foo(x: number);

  bar(x: number);
  bar(x: string);
  x = 45;
  bar(x) {};
}

declare class ConstructorOverloads {
  constructor(x: number);
  constructor(x: string);
  x: number;
  constructor(x: number);

  ["constructor"](x: string);
  ["constructor"](x: number);
}

interface ICallSigOverloads {
  (x: number);
  new(x: number);
  (x: string);
  new(x: string);
  field: number;
  new(x: number);
  (x: number);
}

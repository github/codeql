interface Callable {
  (x: number): string;
}

interface OverloadedCallable {
  (x: number): number;
  (x: string): string;
  (x: any): any;
}

interface Newable {
  new (x: number): any; 
}

interface OverloadedNewable {
  new (x: number): OverloadedNewable;
  new (x: any): any; 
}

interface Method {
  method(x: number): string;
  
  overloadedMethod(x: number): number;
  overloadedMethod(x: string): string;
  overloadedMethod(x: any): any;
}

let m: Method;
m.method(42);
m.overloadedMethod("foo");

interface FunctionTypeField {
  callback: (x: number) => string;
}

interface Generic<T> {
  method(x: T): T;
}

function foo(g: Generic<string>) {
  return g.method("foo");
}

declare class C {
  constructor(x: string);
  constructor(x: number);
}

interface WithRestParams {
  method(x: number, ...y: string[]);
  (x: number, ...y: string[]);
  new(x: number, ...y: string[]);

  method2(x: number, y: string[]);
  method3(x: number, y: string);
}

interface OnlyRestParams {
  method(...y: string[]);
  (...y: string[]);
  new(...y: string[]);

  method2(y: string[]);
  method3(y: string);
}

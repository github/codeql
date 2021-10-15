interface Box<T> { x: T }

interface TestInterface {
  simpleMethod(x: string): number;
  
  genericMethod<T>(x: T): T;
  
  overloadedMethod(x: number): number;
  overloadedMethod(x: string): string;
  overloadedMethod(x: any): any;
  
  genericOverloadedMethod<T>(x: T[]): T;
  genericOverloadedMethod<T>(x: Box<T>): T;
  genericOverloadedMethod(x: any): any; 
}

class TestClass {
  simpleMethod(x: string): number { return x.length }
  
  genericMethod<T>(x: T): T { return x; }
  
  overloadedMethod(x: number): number;
  overloadedMethod(x: string): string;
  overloadedMethod(x: any): any { return x; }
  
  genericOverloadedMethod<T>(x: T[]): T;
  genericOverloadedMethod<T>(x: Box<T>): T;
  genericOverloadedMethod(x: any): any { return x.x || x[0] || null; }
}

class SimpleConstructor {
  constructor(x: string) {}
}

class GenericConstructor<T> {
  constructor(x: T) {}
}

class OverloadedConstructor {
  constructor(x: number, y: number);
  constructor(x: string, y: string);
  constructor(x: any, y: any) {}
}

class GenericOverloadedConstructor<T> {
  constructor(x: T[], y: T[]);
  constructor(x: Box<T>, y: Box<T>);
  constructor(x: any, y: any) {}
}

function useTestInterface(obj: TestInterface, str: string, num: number) {
  obj.simpleMethod(str);
  obj.genericMethod(str);
  obj.genericMethod(num);
  obj.overloadedMethod(num);
  obj.overloadedMethod(str);
  obj.overloadedMethod([]);
  obj.genericOverloadedMethod([num]);
  obj.genericOverloadedMethod({x: str});
  obj.genericOverloadedMethod(num);
}

function useTestClass(obj: TestClass, str: string, num: number) {
  obj.simpleMethod(str);
  obj.genericMethod(str);
  obj.genericMethod(num);
  obj.overloadedMethod(num);
  obj.overloadedMethod(str);
  obj.genericOverloadedMethod([num]);
  obj.genericOverloadedMethod({x: str});
}

function testConstructors(str: string, num: number) {
  new SimpleConstructor(str);
  new GenericConstructor(str);
  new GenericConstructor(num);
  new OverloadedConstructor(num, num);
  new OverloadedConstructor(str, str);
  new GenericOverloadedConstructor([str], [str]);
  new GenericOverloadedConstructor({x: num}, {x: num});
}

function testCallback<U>(callback: (x: string) => U): U {
  return callback("str");
}

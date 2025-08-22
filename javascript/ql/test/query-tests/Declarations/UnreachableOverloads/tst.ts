declare class Foobar {
  method(foo: number): string;
  method(foo: number): number; // $ MISSING: Alert

  types1<T>(): T[]
  types1(): any[] // $ Alert

  types2(): any[]
  types2<T>(): T[]

  types3<T extends Array<T>>(t: T): number;
  types3<T extends string>(t: T): number

  on(event: string, fn?: (event?: any, ...args: any[]) => void): Function;
  on(event: string, fn?: (event?: any, ...args: any[]) => void): Function; // $ MISSING: Alert

  foo(this: string): string;
  foo(this: number): number;

  bar(this: number): string;
  bar(this: number): number; // $ Alert

}

declare class Base {
  method(foo: number): string;
  method(foo: number): number; // $ MISSING: Alert

  overRiddenInSub(): string;
  overRiddenInSub(): number;

  existsInBase(): string;
}


declare class Sub extends Base {
  overRiddenInSub(): string;
  overRiddenInSub(): number;

  existsInBase(): string;
  existsInBase(): number;
}

interface Base1 {
    method(): "foo";
}

interface Base2 {
    method(): "bar";
}


interface MultiInheritanceI extends Base1, Base2 {
    method(): "foo";
    method(): "bar";
}


declare class MultiInheritanceC implements Base1, Base2 {
    method(): "foo";
    method(): "bar";
}
declare class Foobar {
  method(foo: number): string;
  method(foo: number): number; // NOT OK.

  types1<T>(): T[]
  types1(): any[] // NOT OK.

  types2(): any[]
  types2<T>(): T[] // OK!

  types3<T extends Array<T>>(t: T): number;
  types3<T extends string>(t: T): number // OK!

  on(event: string, fn?: (event?: any, ...args: any[]) => void): Function;
  on(event: string, fn?: (event?: any, ...args: any[]) => void): Function; // NOT OK.

  foo(this: string): string;
  foo(this: number): number; // OK

  bar(this: number): string;
  bar(this: number): number; // NOT OK

}

declare class Base {
  method(foo: number): string;
  method(foo: number): number; // NOT OK.

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

// OK.
interface MultiInheritanceI extends Base1, Base2 {
    method(): "foo";
    method(): "bar";
}

// OK.
declare class MultiInheritanceC implements Base1, Base2 {
    method(): "foo";
    method(): "bar";
}
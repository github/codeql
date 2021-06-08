import * as dummy from "./dummy";

var numVar: number;

var num1 = numVar;
var num2 = 5;
var num3 = num1 + num2;

var strVar: string;
var hello = "hello";
var world = "world";
var msg = hello + " " + world;

function concat(x: string, y: string): string { return x + y; }

function add(x: number, y: number): number { return x + y; }

function untyped(x, y) { return x + y; }

function partialTyped(x, y: string) { return x + y; }

for (let numFromLoop of [1, 2]) {}

let array: number[];

let voidType: () => void;
let undefinedType: undefined;
let nullType: null = null;
let neverType: () => never;
let symbolType: symbol;
const uniqueSymbolType: unique symbol = null;
let objectType: object;
let intersection: string & {x: string};
let tuple: [number, string];

let tupleWithOptionalElement: [number, string, number?];
let emptyTuple: [];
let tupleWithRestElement: [number, ...string[]];
let tupleWithOptionalAndRestElements: [number, string?, ...number[]];
let unknownType: unknown;

let constArrayLiteral = [1, 2] as const;
let constObjectLiteral = { foo: "foo" } as const;


try { }
catch (e: unknown) {
  if (typeof e === "string") {
      let b : string = e;
  }
}


interface NonAbstractDummy {
  getArea(): number;
}

interface HasArea {
  getArea(): number;
}

// abstract construct signature!
let Ctor: abstract new () => HasArea = Shape;

type MyUnion = {myUnion: true} | {stillMyUnion: true};
let union1: MyUnion = {myUnion: true};

type MyUnion2 = MyUnion | {yetAnotherType: true};
let union2: MyUnion2 = {yetAnotherType: true};

module TS43 {
  // TypeScript 4.3 setter/getter types
  interface ThingI {
    get size(): number
    set size(value: number | string | boolean);
  }

  export class Thing implements ThingI {
    #size = 0;

    get size(): number {
      return this.#size;
    }

    set size(value: string | number | boolean) {
      this.#size = Number(value);
    }
  }

  // overrides
  class Super {
    random(): number {
      return 4;
    }
  }

  class Sub extends Super {
    override random(): number {
      return super.random() * 10;
    }
  }

  // inference of template strings.
  function bar(s: string): `hello ${string}` {
    // Previously an error, now works!
    return `hello ${s}`;
  }

  declare let s1: `${number}-${number}-${number}`;
  declare let s2: `1-2-3`;
  declare let s3: `${number}-2-3`;
  s1 = s2;
  s1 = s3;

  // private methods
  class Foo {
    #someMethod(): number {
      return 42;
    }

    get #someValue(): number {
      return 100;
    }

    publicMethod() {
      this.#someMethod();
      return this.#someValue;
    }
  } 
}
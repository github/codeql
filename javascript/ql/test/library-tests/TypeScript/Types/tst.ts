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
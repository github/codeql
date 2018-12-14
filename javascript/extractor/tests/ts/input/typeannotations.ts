interface Point { x: number; y: number }

namespace N {
  export interface I {}
  export interface J<T> {}
}

var anyVar:             any;
var objectVar:          object;
var numberVar:          number;
var stringVar:          string;
var booleanVar:         boolean;
var nullVar:            null;
var undefinedVar:       undefined;
var voidVar:            void;
var neverVar:           never;
var symbolVar:          symbol;
var objectVar:          { x: number; }
var nestedObjectVar:    { x: { y: number } }
var arrayVar:           number[]
var stringObjectVar:    String
var pointVar:           Point
var rawFunctionVar:     Function
var varVar:             x11
var genericArrayVar:    Array<number>
var nestedGenericVar:   Foo<Foo<number>>
var callSigVar:         () => number;
var constructSigVar:    new () => Point;
var callSigVoidVar:     () => void;
var callSigNeverVar:    () => never;
var unionVar:           number | string;
var stringLiteralVar:   "literal";
var trueVar:            true;
var falseVar:           false;
var intLiteralVar:      100;
var doubleLiteralVar:   100.50;
var tupleVar:           [string, number]
var longUnionVar:       null | 1 | "two" | [3]
var intersectVar:       Foo & Bar;
var genericCallSigVar:  <T>(x: T) => T;
var genericConstructSigVar: new <T>(x: T) => T;
var keyofVar:           keyof Point
var indexedVar:         Point["x"]
var typeofVar:          typeof x31
var mappedVar:          { [K in keyof Point]: any }
var parenthesizedVar:   (number);
var namespaceTypeVar:   N.I;
var namespaceGenericTypeVar: N.J<number>;

interface GenericInterface<T> {
  field: T;
  method(x: T): T;
}
abstract class GenericClass<T> implements GenericInterface<T> {
  field: T
  abstract method(x:T): T;
}

class Fish {}
class Bird {}
function isFish(pet : Fish | Bird): pet is Fish {}

class ThisTypes {
  foo(x: number): this { return this; }
}

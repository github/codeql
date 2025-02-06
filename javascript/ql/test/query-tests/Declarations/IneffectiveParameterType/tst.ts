import { MyType, x } from 'somewhere';

function join<T>(items: T[], callback: (T) => string) { // $ Alert - (T) should be (x:T)
  return items.map(callback).join(", ")
}

var box : <T>(T) => T[] = (x) => [x]; // $ Alert - (T) should be (x:T)

interface EventEmitter<T> {
  addListener(listener: (T) => void): void; // $ Alert - (T) should be (x:T)
  forwardFrom<S>(other: EventEmitter<S>, converter: (S) => T); // $ Alert - (S) should be (x:S)
}

interface NumberFormatter {
  format(number): string;  // $ Alert - (number) should be (x:number)
  (number): string; // $ Alert - (number) should be (x:number)
}

type TextFormatter = (NumberFormatter) => string; // $ Alert - (NumberFormatter) should be (x:NumberFormatter)

var myGlobal : MyType;
var myCallback: (MyType) => void; // $ Alert - (MyType) should be (x:MyType)

var myOtherCallback : (x) => void; // OK - nothing indicates that 'x' is a type name.

interface Repeated { x: number; }
interface Repeated { y: number; }
interface Repeated { z: number; }

type Callback = (Repeated) => void; // $ Alert - but should only be reported once

class C {
  getName(string) { // OK - parameter name is not part of signature
    return null;
  }
}
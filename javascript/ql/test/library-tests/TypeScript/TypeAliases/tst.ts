type A = number;
type B<T> = T[];

var x: A;
var y: B<number>;

namespace Q {
  export type C = A;
}
var z: Q.C;

interface One { a: number }
interface Two { b: number }

type Union = One | Two;

type Union2 = Union & { x: number };
type Union3 = Union2;
type Union4 = Union3;
type Union5 = Union4 | number;

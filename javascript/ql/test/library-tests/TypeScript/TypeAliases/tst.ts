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

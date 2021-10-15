// There should only be one canonical type variable for `T` below.

interface Repeated<T> {
  x: T;
}

interface Repeated<T> {
  y: T;
}


function genericFunction<D>(x: D): D {
  return x;
}

function overloaded<E>(x: E[]): E;
function overloaded<E>(x: () => E): E;
function overloaded<E>(x: E[] | (() => E)): E {
  return null;
}

interface GenericMethods<T> {
  method<S extends any[]>(x: S, y: T[]): S;
  method<S>(x: S, y: T): [S, T];
  method<S>(x: S, y: S): S;
  method(x: any, y: any): any;
}

interface Banana {
  getThisBanana(): this;
}
interface Apple {
  getThisApple(): this;
}

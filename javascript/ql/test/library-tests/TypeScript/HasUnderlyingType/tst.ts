interface Base<T> {
  x: T;
}
interface Sub<S> extends Base<string> {
  y: S;
}

function foo(arg: (Sub<number> & {w: number}) | string) {
}

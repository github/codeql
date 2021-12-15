export function foo(x: number): number {
  let y : A = x;
  return y;
  type A = number; // OK.
}

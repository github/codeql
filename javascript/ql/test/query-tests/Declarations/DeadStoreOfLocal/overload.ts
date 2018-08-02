export function foo() {
  function bar(x: number): number; // OK
  function bar(x: string): string; // OK
  function bar(x: any) { // OK
    return x;
  }
  
  function baz(x: number): number; // OK
  function baz(x: string): string; // OK
  function baz(x: any) { // NOT OK, overwritten before use
    return x;
  }
  baz = (x) => x;
  
  return {bar: bar, baz: baz};
}

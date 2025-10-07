export function foo() {
  function bar(x: number): number;
  function bar(x: string): string;
  function bar(x: any) {
    return x;
  }
  
  function baz(x: number): number;
  function baz(x: string): string;
  function baz(x: any) { // $ Alert - overwritten before use
    return x;
  }
  baz = (x) => x;
  
  return {bar: bar, baz: baz};
}

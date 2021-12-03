namespace N1 {
  var x;
  let y;
}

namespace N2 {
  var x;
  let y;
}

namespace N2 { // OK
  var w;
}

function f(x: number): number;
function f(x: string): string; // OK
function f(x: any): any { // OK
  return x;
}

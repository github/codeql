namespace N1 {
  var x;
  let y;
}

namespace N2 {
  var x;
  let y;
}

namespace N2 {
  var w;
}

function f(x: number): number;
function f(x: string): string;
function f(x: any): any {
  return x;
}

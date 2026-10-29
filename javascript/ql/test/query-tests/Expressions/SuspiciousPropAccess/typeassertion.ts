class Base {}
class Sub extends Base {
  field: number = 5;
}

function f(x: Base[]) {
  var y;
  if (x) {
    y = x[0] as Sub;
  }
  y.field;
  
  var z = null as Sub;
  z.field; // $ Alert
}

f([new Sub()]);
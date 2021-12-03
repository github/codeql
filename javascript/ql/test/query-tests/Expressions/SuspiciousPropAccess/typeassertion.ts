class Base {}
class Sub extends Base {
  field: number = 5;
}

function f(x: Base[]) {
  var y;
  if (x) {
    y = x[0] as Sub;
  }
  y.field; // OK
  
  var z = null as Sub;
  z.field; // NOT OK
}

f([new Sub()]);
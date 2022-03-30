namespace X {
  export class C {}
}

namespace Y {
  import A = X;
  import D = X.C;
  
  var foo : A.C;
  var bar : D;
}

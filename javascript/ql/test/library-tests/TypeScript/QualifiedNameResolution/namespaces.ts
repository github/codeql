import * as dummylib from './dummy'; // ensure file is treated as a module

namespace A {
  namespace B {
    export namespace Bx {}
  }
  export namespace C {;}
}

namespace A {
  namespace B { // distinct from previous `B`
    export namespace Bx {} // distinct from previous `Bx`
  }
  export namespace C {;} // same as previous `C`
}

export namespace D {
  namespace E {;}
  export namespace F {;}
}

export namespace D {
  namespace E {;} // distinct from previous `E`
  export namespace F {;} // same as previous `F`
}

export namespace G {
  namespace H {
    export namespace I {}
  }
  namespace H { // same as previous `H`
    export namespace I {} // same as previous `I`
  }
  export class C {}
  export namespace J {
    export class C {}
  }
}

namespace X.Y.Z {;}
namespace X {
  export namespace Y.Z {;}
}

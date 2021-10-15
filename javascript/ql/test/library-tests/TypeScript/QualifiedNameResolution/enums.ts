import * as dummylib from './dummy'; // ensure file is treated as a module

namespace A {
  export enum E {
    x, y
  }
}

var x: A.E.x;
var y: A.E;

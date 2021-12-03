import * as dummylib from './dummy'; // ensure file is treated as a module

namespace N {
  export class C {}
}
namespace D {
  export class C {}
}

class C {}

export {N, C};
export default D;

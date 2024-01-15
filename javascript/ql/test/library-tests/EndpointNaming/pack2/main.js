class AmbiguousClass {
    instanceMethod() {} // $ method=(pack2).MainClass.prototype.instanceMethod
} // $ class=(pack2).MainClass instance=(pack2).MainClass.prototype

export default AmbiguousClass;
export { AmbiguousClass as MainClass }

import * as lib from "./lib";
export { lib }

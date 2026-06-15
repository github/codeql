class AmbiguousClass {
    instanceMethod() {} // $ name=(pack2).MainClass.prototype.instanceMethod
} // $ name=(pack2).MainClass

export default AmbiguousClass; // $ alias=(pack2).default==(pack2).MainClass
export { AmbiguousClass as MainClass }

import * as lib from "./lib";
export { lib }

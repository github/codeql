class AmbiguousClass {
    instanceMethod(foo) {} // $ method=(pack2).lib.LibClass.prototype.instanceMethod
} // $ class=(pack2).lib.LibClass instance=(pack2).lib.LibClass.prototype

export default AmbiguousClass;
export { AmbiguousClass as LibClass }

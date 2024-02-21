class AmbiguousClass {
    instanceMethod(foo) {} // $ name=(pack2).lib.LibClass.prototype.instanceMethod
} // $ name=(pack2).lib.LibClass

export default AmbiguousClass; // $ alias=(pack2).lib.default==(pack2).lib.LibClass
export { AmbiguousClass as LibClass }

AmbiguousClass.foo = function() {} // $ name=(pack2).lib.LibClass.foo

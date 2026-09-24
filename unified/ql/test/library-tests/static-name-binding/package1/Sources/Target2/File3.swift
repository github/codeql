import Target1

public class A {} // name=Target2.A

public class B { // name=Target2.B
    public class C {} // name=Target2.B.C
}

extension ScopedExtensionTarget { // $ access=ScopedExtensionTarget
    func target2ExtensionMethod() {} // name=Target1.ScopedExtensionTarget.target2ExtensionMethod
}

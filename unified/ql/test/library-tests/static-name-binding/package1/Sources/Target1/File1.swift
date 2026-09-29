let x: A; // $ access=Target1.A
let y: Target2.A; // not a valid reference

public class ScopedExtensionTarget {
    func useExtensionFromUnimportedModule() {
        target2ExtensionMethod() // $ SPURIOUS: access=Target1.ScopedExtensionTarget.target2ExtensionMethod
    }
}

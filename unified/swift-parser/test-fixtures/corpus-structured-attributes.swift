@_effects(notEscaping self.**)
@_specialize(exported: true, where @_noMetadata T: _Class)
func effects<T>(_ value: T) {}
@_effects(escaping s0 => %r)
func escapingEffects() {}
@_implements(Collection, custom(_:))
func implemented(_ index: Int) {}
@_dynamicReplacement(for: original(_:))
func replacement(_ value: Int) {}
@backDeployed(before: iOS 17.0, macOS 14.0)
func backDeployed() {}
@_originallyDefinedIn(module: "Original", iOS 17.0, macOS 14.0)
func originalModule() {}
@specialized(where T == Int)
func specialized<T>(_ value: T) {}
@objc(renamed::)
func emptySelectorComponent(_ first: Int, _ second: Int) {}

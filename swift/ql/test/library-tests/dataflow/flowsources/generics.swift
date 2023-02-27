
class MySimpleClass
{
    let source1: Int = 0
    var source2: Int { get { return 0 } }
    func source3() -> Int { return 0 }
}

func useMySimpleClass(simple: MySimpleClass) {
    _ = simple.source1 // $ source=remote
    _ = simple.source2 // $ source=remote
    _ = simple.source3() // $ source=remote
}

// ---

class MyGeneric<T> {
    let source1: Int = 0
    var source2: T? { get { return nil } }
    func source3() -> Int { return 0 }
}

class MyDerived<T> : MyGeneric<T> {
    let source4: Int = 0
    var source5: T? { get { return nil } }
    func source6() -> Int { return 0 }
}

extension MyDerived
{
    var source7: Int { get { return 0 } }
    func source8() -> Int { return 0 }
}

class MyDerived2 : MyGeneric<Int> {
    let source9: Int = 0
    var source10: Int { get { return 0 } }
    func source11() -> Int { return 0 }
}

extension MyDerived2
{
    var source12: Int { get { return 0 } }
    func source13() -> Int { return 0 }
}

func useDerived(generic: MyGeneric<Int>, generic2: MyGeneric<Any>, derived: MyDerived<Int>, derived2: MyDerived2) {
    _ = generic.source1 // $ source=remote
    _ = generic.source2 // $ source=remote
    _ = generic.source3() // $ source=remote
    _ = generic2.source1 // $ source=remote
    _ = generic2.source2 // $ source=remote
    _ = generic2.source3() // $ source=remote
    _ = derived.source1 // $ source=remote
    _ = derived.source2 // $ source=remote
    _ = derived.source3() // $ source=remote
    _ = derived.source4 // $ source=remote
    _ = derived.source5 // $ source=remote
    _ = derived.source6() // $ source=remote
    _ = derived.source7 // $ source=remote
    _ = derived.source8() // $ source=remote
    _ = derived2.source1 // $ source=remote
    _ = derived2.source2 // $ source=remote
    _ = derived2.source3() // $ source=remote
    _ = derived2.source9 // $ source=remote
    _ = derived2.source10 // $ source=remote
    _ = derived2.source11() // $ source=remote
    _ = derived2.source12 // $ source=remote
    _ = derived2.source13() // $ source=remote
}

// ---

protocol MyParentProtocol {
    var source0: Int { get }
}

protocol MyProtocol : MyParentProtocol {
    var source1: Int { get }
    var source2: Int { get }
}

class MyImpl<T> : MyProtocol {
    var source1: Int { get { return 0 } }
}

extension MyImpl {
    var source0: Int { get { return 0 } }
    var source2: Int { get { return 0 } }
}

func useProtocol(proto: MyProtocol, impl: MyImpl<Int>, impl2: MyImpl<Any>) {
    _ = proto.source0 // $ source=remote
    _ = proto.source1 // $ source=remote
    _ = proto.source2 // $ source=remote
    _ = impl.source0 // $ source=remote
    _ = impl.source1 // $ source=remote
    _ = impl.source2 // $ source=remote
    _ = impl2.source0 // $ source=remote
    _ = impl2.source1 // $ source=remote
    _ = impl2.source2 // $ source=remote
}

// ---

protocol MyParentProtocol2 {
    var source0: Int { get }
}

protocol MyProtocol2 : MyParentProtocol2 {
    var source1: Int { get }
    var source2: Int { get }
}

class MyImpl2<T> {
    var source1: Int { get { return 0 } }
}

extension MyImpl2 : MyProtocol2 {
    var source0: Int { get { return 0 } }
    var source2: Int { get { return 0 } }
}

func useProtocol2(proto: MyProtocol2, impl: MyImpl2<Int>, impl2: MyImpl2<Any>) {
    _ = proto.source0 // $ source=remote
    _ = proto.source1 // $ source=remote
    _ = proto.source2 // $ source=remote
    _ = impl.source0 // $ source=remote
    _ = impl.source1 // $ source=remote
    _ = impl.source2 // $ source=remote
    _ = impl2.source0 // $ source=remote
    _ = impl2.source1 // $ source=remote
    _ = impl2.source2 // $ source=remote
}

// ---

protocol MyProtocol3 {
    func source1() -> Int
    func source2() -> Int
    func source3() -> Int
}

class MyParentClass3 {
    func source1() -> Int { return 0 }
}

class MyClass3 : MyParentClass3 {
    func source2() -> Int { return 0 }
    func source3() -> Int { return 0 }
}

extension MyClass3 : MyProtocol3 {
}

class MyChildClass3: MyClass3 {
    override func source3() -> Int { return 0 }
}

func useProtocol3(impl: MyChildClass3) {
    _ = impl.source1() // not a source (`MyProtocol3.source1` is the declared source and `MyParentClass3` doesn't extend it)
    _ = impl.source2() // $ source=remote
    _ = impl.source3() // $ source=remote
}

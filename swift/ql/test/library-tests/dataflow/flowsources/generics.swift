
class MySimpleClass
{
    let source1: Int = 0
    var source2: Int { get { return 0 } }
    func source3() -> Int { return 0 }
}

func useMySimpleClass(simple: MySimpleClass) {
    _ = simple.source1 // SOURCE
    _ = simple.source2 // SOURCE
    _ = simple.source3() // SOURCE
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
    _ = generic.source1 // SOURCE
    _ = generic.source2 // SOURCE
    _ = generic.source3() // SOURCE
    _ = generic2.source1 // SOURCE
    _ = generic2.source2 // SOURCE
    _ = generic2.source3() // SOURCE
    _ = derived.source1 // SOURCE
    _ = derived.source2 // SOURCE
    _ = derived.source3() // SOURCE
    _ = derived.source4 // SOURCE
    _ = derived.source5 // SOURCE
    _ = derived.source6() // SOURCE
    _ = derived.source7 // SOURCE
    _ = derived.source8() // SOURCE
    _ = derived2.source1 // SOURCE
    _ = derived2.source2 // SOURCE
    _ = derived2.source3() // SOURCE
    _ = derived2.source9 // SOURCE
    _ = derived2.source10 // SOURCE
    _ = derived2.source11() // SOURCE
    _ = derived2.source12 // SOURCE
    _ = derived2.source13() // SOURCE
}

// ---

protocol MyProtocol {
    var source1: Int { get }
    var source2: Int { get }
}

class MyImpl<T> : MyProtocol {
    var source1: Int { get { return 0 } }
}

extension MyImpl {
    var source2: Int { get { return 0 } }
}

func useProtocol(proto: MyProtocol, impl: MyImpl<Int>, impl2: MyImpl<Any>) {
    _ = proto.source1 // SOURCE
    _ = proto.source2 // SOURCE
    _ = impl.source1 // SOURCE
    _ = impl.source2 // SOURCE
    _ = impl2.source1 // SOURCE
    _ = impl2.source2 // SOURCE
}

// ---

protocol MyProtocol2 {
    var source1: Int { get }
    var source2: Int { get }
}

class MyImpl2<T> {
    var source1: Int { get { return 0 } }
}

extension MyImpl2 : MyProtocol2 {
    var source2: Int { get { return 0 } }
}

func useProtocol2(proto: MyProtocol2, impl: MyImpl2<Int>, impl2: MyImpl2<Any>) {
    _ = proto.source1 // SOURCE
    _ = proto.source2 // SOURCE
    _ = impl.source1 // SOURCE [NOT DETECTED]
    _ = impl.source2 // SOURCE [NOT DETECTED]
    _ = impl2.source1 // SOURCE [NOT DETECTED]
    _ = impl2.source2 // SOURCE [NOT DETECTED]
}

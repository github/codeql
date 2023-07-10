// stubs



// tests

func arrayTest() {
    let ints = [1,2,3]
    ints.withUnsafeBytes{ // BAD
        return $0
    }

    print(ints.withUnsafeBytes({(p: UnsafeRawBufferPointer) -> UnsafeRawBufferPointer in return p})) // BAD

    print(ints.withUnsafeBytes({(p: UnsafeRawBufferPointer) -> UnsafeRawBufferPointer in return id(pointer: p)})) // BAD

    ints.withUnsafeBytes({(p: UnsafeRawBufferPointer) in print(p)}) // GOOD

    var v = PointerHolder()
    ints.withUnsafeBytes({(p: UnsafeRawBufferPointer) in v.field = p}) // BAD
    print(v.field)

    ints.withUnsafeBytes(myPrint) // GOOD

    myPrint(p: ints.withUnsafeBytes(id)) // BAD
}

func id<T>(pointer: T) -> T {
    return pointer
}

struct PointerHolder {
    var field: UnsafeRawBufferPointer?
}

func myPrint(p: UnsafeRawBufferPointer) {
    print(p)
}

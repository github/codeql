func use_before() {
    print(x) // $ MISSING: access=top.x
    B(); // $ MISSING: access=top.B
    let b: B = nil // $ MISSING: access=top.B
    let c: C = nil // $ MISSING: access=top.C
}

let x = 123 // name=top.x
class B {} // name=top.B
typealias C = B // $ MISSING: access=top.B // name=top.C

func use_after() {
    print(x) // $ access=top.x
    B(); // $ MISSING: access=top.B
    let b: B = nil // $ MISSING: access=top.B
    let c: C = nil // $ MISSING: access=top.C
}

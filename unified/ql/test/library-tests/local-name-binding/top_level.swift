func use_before() {
    print(x) // $ access=top.x
    B(); // $ access=top.B
    let b: B = nil // $ access=top.B
    let c: C = nil // $ access=top.C
}

let x = 123 // name=top.x
class B {} // name=top.B
typealias C = B // $ access=top.B // name=top.C

func use_after() {
    print(x) // $ access=top.x
    B(); // $ access=top.B
    let b: B = nil // $ access=top.B
    let c: C = nil // $ access=top.C
}

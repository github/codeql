func t1() -> Int {
    let x = 42 // name=x1
    return x // $ access=x1
}

func t2() -> Int {
    let x = 42 // name=x1

    if case let x = x + 10 { // $ access=x1 // name=x2
        print(x) // $ access=x2
    }
    print(x) // $ access=x1
}

func t3() -> Int {
    guard let x = foo() else { // name=x1
        return 0
    }
    print(x) // $ access=x1
}

// Function parameters
func t4(x: Int) -> Int { // name=x1
    return x // $ access=x1
}

// Multiple parameters
func t5(x: Int, // name=x1
        y: Int) -> Int { // name=y1
    let z = x + // $ access=x1 // name=z1
            y // $ access=y1
    return z // $ access=z1
}

// Parameter shadowed by local variable
func t6(x: Int) -> Int { // name=x1
    let x = x * 2 // $ access=x1 // name=x2
    return x // $ access=x2
}

// Nested blocks
func t7() {
    let x = 1; // name=x1
    do {
        print(x) // $ access=x1
        let x = 2 // name=x2
        print(x) // $ access=x2
    }
    print(x) // $ access=x1
}

// For-in loop
func t8() {
    let array = [1, 2, 3] // name=array1
    for x in array { // $ access=array1 // name=x1
        print(x) // $ access=x1
    }
}

// For-in loop with shadowing
func t9() {
    let x = 0 // name=x1
    let array = [1, 2, 3] // name=array1
    for x in array { // $ access=array1 // name=x2
        print(x) // $ access=x2
    }
    print(x) // $ access=x1
}

// Switch statement with case bindings
func t10(value: Int) { // name=value1
    switch value { // $ access=value1
    case let x: // name=x1
        print(x) // $ access=x1
    default:
        break
    }
}

// Switch with multiple cases
func t11(value: Int) { // name=value1
    switch value { // $ access=value1
    case let x where x > 0: // name=x1
        print(x) // $ access=x1
    case let x: // name=x2
        print(x) // $ access=x2
    }
}

// Tuple unpacking
func t12() {
    let tuple = (1, 2) // name=tuple1
    let (x, // name=x1
         y) = tuple // $ access=tuple1 // name=y1
    print(x) // $ access=x1
    print(y) // $ access=y1
}

// Tuple unpacking with underscore
func t13() {
    let tuple = (1, 2, 3) // name=tuple1
    let (x, // name=x1
         _,
         y) = tuple // $ access=tuple1 // name=y1
    print(x) // $ access=x1
    print(y) // $ access=y1
}

// Optional binding (if let)
func t14(optional: Int?) { // name=optional1
    if let x = optional { // $ access=optional1 // name=x1
        print(x) // $ access=x1
    }
}

// Multiple optional bindings
func t15(opt1: Int?, // name=opt11
         opt2: String?) { // name=opt21
    if let x = opt1, // $ access=opt11 // name=x1
       let y = opt2 { // $ access=opt21 // name=y1
        print(x) // $ access=x1
        print(y) // $ access=y1
    }
}

// Do-catch blocks
func t16() throws {
    do {
        let x = try foo() // name=x1
        print(x) // $ access=x1
    } catch let error { // name=error1
        print(error) // $ access=error1
    }
}

// Closure captures
func t17() {
    let x = 1 // name=x1
    let closure = { // name=closure1
        print(x) // $ access=x1
    }
    closure() // $ access=closure1
}

// Closure with parameter shadowing
func t18() {
    let x = 1 // name=x1
    let closure =
        { (x: Int) -> Void in // name=x2
            print(x) // $ access=x2
        }
    closure(2) // $ access=closure
    print(x) // $ access=x1
}

// While loop
func t19() {
    var x = 0 // name=x1
    while x < 10 { // $ access=x1
        x = x + 1 // $ access=x1
        print(x) // $ access=x1
    }
}

// Repeat-while loop
func t20() {
    var x = 0 // name=x1
    repeat {
        x = x + 1 // $ access=x1
        print(x) // $ access=x1
    } while x < 10 // $ access=x1
}

// Property shadowing (var)
func t21() {
    var x = 1 // name=x1
    var x = 2 // name=x2
    print(x) // $ access=x2
}

// Nested functions
func t22() {
    let x = 1 // name=x1
    func inner() { // name=inner1
        let x = 2 // name=x2
        print(x) // $ access=x2
    }
    inner() // $ access=inner1
    print(x) // $ access=x1
}

// Three levels of shadowing
func t23() {
    let x = 1 // name=x1
    {
        let x = 2 // name=x2
        {
            let x = 3 // name=x3
            print(x) // $ access=x3
        }
        print(x) // $ access=x2
    }
    print(x) // $ access=x1
}

// If-let followed by regular if
func t24(optional: Int?) { // name=optional1
    if let x = optional { // $ access=optional1 // name=x1
        print(x) // $ access=x1
    }
    if true {
        let x = 5 // name=x2
        print(x) // $ access=x2
    }
}

// Switch with same variable name in different cases
func t25(value: Int) { // name=value1
    switch value { // $ access=value1
    case let x: // name=x1
        print(x) // $ access=x1
        let x = 10 // name=x2
        print(x) // $ access=x2
    }
}

func t26() -> Int {
    let x = 42 // name=x1
    guard let x = foo() else { // name=x2
        return x // $ access=x1
    }
    print(x) // $ access=x2
}

// if with multiple conditions, mixing boolean and optional binding
func t27(opt: Int?) { // name=opt1
    if opt != nil, // $ access=opt1
       let x = opt { // $ access=opt1
        print(x) // $ access=x
    }
}

// if with multiple let bindings and a boolean condition
func t28(a: Int?, b: Int?) {
    if let x = a, // $ access=a
       let y = b, // $ access=b
       x < y { // $ access=x access=y
        print(x) // $ access=x
        print(y) // $ access=y
    }
}

// if with multiple conditions where a later binding shadows an outer variable
func t29(opt: Int?) { // name=opt1
    let x = 0 // name=x1
    if opt != nil, // $ access=opt1
       let x = opt { // $ access=opt1
        print(x) // $ access=x
    }
    print(x) // $ access=x1
}

// guard with multiple conditions, mixing boolean and optional binding
func t30(opt: Int?) { // name=opt1
    guard opt != nil, // $ access=opt1
          let x = opt else { // $ access=opt1
        return
    }
    print(x) // $ access=x
}

// guard with multiple let bindings and a boolean condition
func t31(a: Int?, b: Int?) {
    guard let x = a, // $ access=a
          let y = b, // $ access=b
          x < y else { // $ access=x access=y
        return
    }
    print(x) // $ access=x
    print(y) // $ access=y
}

// guard with multiple conditions where bound variable is used in later condition
func t32(opt: Int?) { // name=opt1
    guard let x = opt, // $ access=opt1
          x > 0 else { // $ access=x
        return
    }
    print(x) // $ access=x
}

func t33() {
    let x = 1 // name=x1
    guard x > 0, // $ access=x1
          let x = x, // $ access=x1 // name=x2
          x > 0 else { // $ access=x2
        return
    }
    print(x) // $ access=x2
}

func t34() {
    let x = 1 // name=x1
    if x > 0, // $ access=x1
       let x = x, // $ access=x1 // name=x2
       x > 0 { // $ access=x2
        print(x) // $ access=x2
    }
}

// While-let optional binding
func t35(optional: Int?) { // name=optional1
    while let x = optional { // $ access=optional1 // name=x1
        print(x) // $ access=x1
    }
}

// While with a sequence of variable bindings in the condition
func t36(a: Int?, b: Int?) {
    while let x = a, // $ access=a
          let y = b, // $ access=b
          x < y { // $ access=x access=y
        print(x) // $ access=x
        print(y) // $ access=y
    }
}

// While-let with a sequence of shadowing variable declarations
func t37() {
    let x = 1 // name=x1
    while let x = x, // $ access=x1 // name=x2
          let x = x, // $ access=x2 // name=x3
          x > 0 { // $ access=x3
        print(x) // $ access=x3
    }
}

enum E38 {
    case a(Int)
    case b(Int)
}

// Switch with a multi-pattern case that binds 'x' in each pattern
// Note: the testing framework does not make it possible to name the 'x' variable in this case.
func t38(value: E38) {
    switch value { // $ access=value
    case .a(let x), // $ access=x
         .b(let x): // $ access=x
        print(x) // $ access=x
    }
}

func bindings() {
    inout alias = global
    _borrowing borrowed = global
    if let inout value = optional { use(value) }
    if let _borrowing value = optional { use(value) }
    for inout element in values { use(element) }
    switch value {
    case _borrowing x: use(x)
    case borrowing x: use(x)
    case inout y: use(y)
    case borrowing: use(value)
    }
}

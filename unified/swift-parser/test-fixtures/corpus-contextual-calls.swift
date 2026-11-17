func combine() {
    any(parser).flatMap { $0.values }
    let some = some(parser)
    let inverted = values.map(!)
    let compared = values.map(==)
}

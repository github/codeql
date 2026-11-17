struct Range {
    var acquireRange: InstructionRange { consuming get { range } }
    var borrowed: Value { borrowing get { value } }
    var legacy: Value { __consuming get { value } }
}

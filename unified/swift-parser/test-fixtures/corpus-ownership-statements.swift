struct Resource: ~Copyable {
    consuming func take() {
        discard self
    }
}
let borrowed = borrow resource
let copied = copy resource
let consumed = consume resource
let result = unsafe .init()
let invoked = unsafe()
let operand = unsafe (lhs + rhs)
let inverted = copy !flag
let reference = copy(resource)
let indexed = borrow[0]
let member = consume.value

switch value {
case let .some(item): print(item)
case .some(let error as Error): print(error)
case let .pair(first, second): print(first, second)
default: break
}
if case let .some(value) = optional { print(value) }
let projected = $sessionState
let implicit = values.map { $0 }
let copy = value
let consume = value
let result = copy
install(action: #selector(copy(_:)))
let member = tuple.0.1
let forced = optional!!.value

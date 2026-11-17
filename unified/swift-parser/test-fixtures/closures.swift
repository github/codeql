let mapped = values.map { value in value + 1 }
let typed = values.map { (value: Int) -> Int in return value + 1 }
let captured = { [weak owner, unowned delegate = self.delegate] value in
    owner?.update(value)
}
let wildcard = values.map { (_) in 0 }

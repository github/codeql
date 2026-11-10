func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: Any) -> String { return "" }

func t1() {
    func getValue() -> String { source("t1.1") }
    sink(getValue())  // $ hasValueFlow=t1.1
}

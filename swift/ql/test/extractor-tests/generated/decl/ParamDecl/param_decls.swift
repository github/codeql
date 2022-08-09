func foo(_: Int, x y: inout Double) {}
func bar(_: Int, x y: inout Double) {}

struct S {
    subscript(x: Int, y: Int) -> Int? {
        get { nil }
        set {}
    }
}

func closures() {
  let x = {(s: inout String) -> String in s}
  let y = {(s: inout String) -> String in ""}
  let z : (Int) -> Int = { $0 + 1 }
}

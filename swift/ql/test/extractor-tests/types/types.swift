let x = 42

print(x + 10)

struct X {}

let instance = X()

class C {
class Nested {}
}

let cinstance = C()
let nestedinstance = C.Nested()

func f(x: Int, y: Int) -> Int {
  return x + y
}

func g(_ f: (Int) -> Int, _ x: Int) -> Int {
  return f(x)
}

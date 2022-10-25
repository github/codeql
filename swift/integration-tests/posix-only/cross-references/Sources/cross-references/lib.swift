func f() {}

class C {
    init() {}
    deinit {}
}

enum E { case e }

let X = 42

protocol P {}

struct S : P {}

prefix operator ~
prefix func ~ (v: Int) -> Int {
  return v
}

postfix operator ~
postfix func ~(v: Int) -> Int {
  return v
}

infix operator ~
func ~(lhs: Int, rhs: Int) -> Int {
    return lhs
}

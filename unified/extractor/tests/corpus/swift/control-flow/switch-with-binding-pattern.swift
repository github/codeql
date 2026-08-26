switch shape {
case .circle(let r):
  print(r)
case .square(let s):
  print(s)
case .foo:
  print("foo")
case T.foo:
  print("foo")
// Ambiguous reference to a static property on the Array<T> type, or an instance property on Array<S> where S is the type of the expression T.
// The parser can't tell the difference.
case [T].foo:
  print("foo")
}

func makeTuple<each T>(_ t: repeat each T) -> (repeat each T) {
  return (repeat each t)
}
let _ = makeTuple("A", 2)

struct Packs<each C> {
  func a() -> (repeat each C) {
    fatalError()
  }
  public func b() -> (repeat Optional<each C>) {
    return (repeat each a())
  }
}

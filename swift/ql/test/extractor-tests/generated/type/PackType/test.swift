func makeTuple<each T>(_ t: repeat each T) -> (repeat each T) {
  return (repeat each t)
}

let _ = makeTuple("A", 2)
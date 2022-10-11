struct X {}
struct Y {
  init() {}
  init(_: Int) {}
}

let x = X()
let y1 = Y(42)
let y2 = Y()

struct Outer {
  struct Inner {
    struct Deep {}
  }
}

let value: Outer.Inner
let nested: Outer.Inner.Deep

// code inspired by https://github.com/apple/swift-evolution/blob/main/proposals/0352-implicit-open-existentials.md

protocol P1 {}

func isFoo<T: P1>(_: T) -> Bool {
  return true
}

protocol P2 {}

class C {}

// will be ok with swift 5.7
// func test(value: any P1 & P2 & C) -> Bool { return isFoo(value) }

extension P1 {
  var isFooMember: Bool {
    isFoo(self)
  }
}


func testMember(value: any P1 & P2 & C) -> Bool {
  return value.isFooMember  // here the existential type is implicitly "opened"
}

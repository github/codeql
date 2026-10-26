struct Bar {
    var value : Int
    var opt : Int?
}

struct Foo {
    var value : Int
    var opt : Bar?
}

let prop = \Foo.value
let arrElement = \[Int][0]
let dictElement = \[String : Int]["a"]
let optForce = \Optional<Int>.self!
let optChain = \Foo.opt?.opt
let optChainWrap = \Foo.opt?.value
let slf = \Int.self
let tupleElement = \(Int, Int).0

let index = 42
switch index {
   case 1:
      print("1")
      fallthrough
   case 5, 10:
      print("5, 10")
   case let x where x >= 42:
      print("big")
   default:
      print("default")
}

enum X {
  case one
  case two(_: Int, _: String)
  case three(s: String)
}

let x = X.two(42, "foo")
switch x {
  case .one:
    break
  case .two(let a, let b) where a == b.count:
    break
  case .two(let c, let d):
    break
  case .three(s: let e):
    break
}

outer: switch x {
  case .two(let a, _):
    inner: switch a {
       case 0:
         break outer
       default:
         break inner
    }
  default:
    break
}

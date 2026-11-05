switch n {
case let x where x > 0:
  print("positive")
case let y where y < 0, 0:
  print("non-positive")
default:
  print("other")
}

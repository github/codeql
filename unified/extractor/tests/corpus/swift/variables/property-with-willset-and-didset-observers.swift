class C {
  var x: Int = 0 {
    willSet { print(newValue) }
    didSet { print(oldValue) }
  }
}

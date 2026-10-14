class Base {
  var value = 0

  func update() {}
}

class Derived: Base {
  override func update() {
    _ = super.value
    super.update()
  }
}

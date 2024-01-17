public class A {
  fun action() { }

  fun always_dom1() {
    action()
  }

  fun always_dom2(b: Boolean) {
    if (b) { } else { }
    action()
  }

  fun always_path(b: Boolean) {
    if (b) {
      action()
    } else {
      action()
    }
  }

  fun always_w_call(b1: Boolean, b2: Boolean) {
    if (b1) {
      action()
    } else if (b2) {
      always_dom2(b1)
    } else {
      always_path(b2)
    }
  }

  fun not_always_none() {
  }

  fun not_always_one(b: Boolean) {
    if (b) {
      action()
    }
  }

  fun not_always_two(b1: Boolean, b2: Boolean) {
    if (b1) {
      if (b2) {
        action()
      } else {
        action()
      }
    }
  }
}

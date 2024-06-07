open class A {

  open fun f(x: String) = x

}

interface B {

  fun g(x: String) = x

}

interface C {

  fun g(x: String) = x

}

class User : A(), B, C {

  override fun f(x: String) = super.f(x)

  override fun g(x: String) = super<B>.g(x)

  fun source() = "tainted"

  fun sink(s: String) { }

  fun test() {

    sink(this.f(source()))
    sink(this.g(source()))

  }

}

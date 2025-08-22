open class A {

  open fun f(x: Int = 0) = x

}

class B : A() {

  override fun f(x: Int) = x + 1

  fun user() = this.f()

}

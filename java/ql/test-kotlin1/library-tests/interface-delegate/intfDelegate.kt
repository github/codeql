interface Intf {

  fun f(i: Int)

}

class Concrete : Intf by object : Intf {
  override fun f(i: Int) { }
} {
}

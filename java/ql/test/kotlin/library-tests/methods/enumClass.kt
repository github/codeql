enum class EnumClass(val v: Int) {
    enum1(1),
    enum2(1)
}

enum class EnumWithFunctions {

  VAL {
    override fun f(i: Int) = i
    override fun g(i: Int) = this.f(i) + i
  };

  abstract fun f(i: Int): Int
  abstract fun g(i: Int): Int

}

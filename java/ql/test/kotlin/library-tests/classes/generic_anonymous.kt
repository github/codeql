private class Generic<T>(val t: T) {

  private val x = object {
      val member = t
  }

  fun get() = x.member

}

fun stringIdentity(s: String) = Generic<String>(s).get()

fun intIdentity(i: Int) = Generic<Int>(i).get()

class Outer<T0> {
    open interface C0<T0> {
        fun fn0(): T0? = null
    }

    open interface C1<T1> {
        fun fn1(): T1? = null
    }

    fun <U2> func1() {
        fun <U3> func2() {
            object: C0<U2>, C1<U3> {}
            object: C0<U2>, C1<U2> {}
            object: C0<U2>, C1<String> {}
            object: C0<U2> {}
            object: C0<String> {}
        }
    }
}

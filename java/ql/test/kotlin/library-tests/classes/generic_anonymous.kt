private class Generic<T>(val t: T) {

  private val x = object {
      val member = t
  }

  fun get() = x.member

}

fun stringIdentity(s: String) = Generic<String>(s).get()

fun intIdentity(i: Int) = Generic<Int>(i).get()

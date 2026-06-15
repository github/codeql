enum class A {
  A1, A2
}

fun test(a: A): Int = 
  when(a) {
    A.A1 -> 1
    A.A2 -> 2
  }


package testuser

class User {

  fun test() {

    val a = OuterGeneric<Int>().InnerGeneric<String>("hello")
    val a2 = OuterGeneric<Int>().InnerGeneric("hello")
    val b = OuterGeneric<Int>().InnerNotGeneric()
    val c = OuterNotGeneric().InnerGeneric<String>()

    val result1 = a.returnsecond(0, "hello")
    val result2 = b.identity(5)
    val result3 = c.identity("world")

  }

}

interface If<T> {

  val x : T

}

open class A<T>(t: T) {

  val anonType = object : If<T> {
    override val x = t
  }

  private val privateAnonType = object : If<T> {
    override val x = t
  }

}

fun user(x: A<String>)  = x.anonType.x

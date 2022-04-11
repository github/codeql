annotation class SomeAnnotation(@get:JvmName("abc") val x: Int = 5, val y: String = "")

annotation class ReplaceWith(val expression: String)

annotation class Deprecated(
    val message: String,
    val replaceWith: ReplaceWith = ReplaceWith(""))

@Deprecated("This class is deprecated", ReplaceWith("Y"))
@SomeAnnotation(y = "a")
class X

fun fn(a: SomeAnnotation) {
    println(a.x)
}


import java.awt.Polygon
import java.awt.Rectangle

fun topLevelMethod(x: Int, y: Int): Int {
    val i1 = 1
    val i2 = x + y
    val i3 = x - y
    val i4 = x / y
    val i5 = x % y
/*
TODO
    val i6 = x shl y
    val i7 = x shr y
    val i8 = x ushr y
    val i9 = x and y
    val i10 = x or y
    val i11 = x xor y
    val i12 = x.inv()
*/
    val i13 = x == y
    val i14 = x != y
    val i15 = x < y
    val i16 = x <= y
    val i17 = x > y
    val i18 = x >= y
    val i19 = x === y
    val i20 = x !== y
/*
TODO
    val i20 = x in x .. y
    val i21 = x !in x .. y
*/
    val b1 = true
    val b2 = false
/*
TODO
    val b3 = b1 && b2
    val b4 = b1 || b2
    val b5 = !b1
*/
    val c = 'x'
    val str = "string lit"
    val strWithQuote = "string \" lit"
    val b6 = i1 is Int
    val b7 = i1 !is Int
    val b8 = b7 as Boolean
    val str1: String = "string lit"
    val str2: String? = "string lit"
    val str3: String? = null
    val str4: String = "foo $str1 bar $str2 baz"
    // TODO val str5: String = "foo ${str1 + str2} bar ${str2 + str1} baz"
    val str6 = str1 + str2

    var variable = 10
    while (variable > 0) {
        variable--
    }

    return 123 + 456
}

fun getClass() {
    val d = true::class
}

class C(val n: Int) {
    fun foo(): C { return C(42) }
}

open class Root {}
class Subclass1: Root() {}
class Subclass2: Root() {}

fun typeTests(x: Root, y: Subclass1) {
    if(x is Subclass1) {
        val x1: Subclass1 = x
    }
    val y1: Subclass1 = if (x is Subclass1) { x } else { y }
    var q = 1
    if (x is Subclass1) { q = 2 } else { q = 3 }
}

fun foo(p: Polygon) {
    val r = p.getBounds()
    if(r != null) {
        val r2: Rectangle = r
        val height = r2.height
        r2.height = 3
    }
}

enum class Direction {
    NORTH, SOUTH, WEST, EAST
}

enum class Color(val rgb: Int) {
    RED(0xFF0000),
    GREEN(0x00FF00),
    BLUE(0x0000FF)
}

fun enums() {
    val south = Direction.SOUTH
    val green = Color.GREEN
}

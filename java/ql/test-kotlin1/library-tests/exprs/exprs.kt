import java.awt.Polygon
import java.awt.Rectangle
import kotlin.experimental.*
fun topLevelMethod(x: Int, y: Int,
                   byx: Byte, byy: Byte,
                   sx: Short, sy: Short,
                   lx: Long, ly: Long,
                   dx: Double, dy: Double,
                   fx: Float, fy: Float,
                   ): Int {
    val i1 = 1
    val i2 = x + y
    val i3 = x - y
    val i4 = x / y
    val i5 = x % y
    val i6 = x shl y
    val i7 = x shr y
    val i8 = x ushr y
    val i9 = x and y
    val i10 = x or y
    val i11 = x xor y
    val i12 = x.inv()
    val i13 = x == y
    val i14 = x != y
    val i15 = x < y
    val i16 = x <= y
    val i17 = x > y
    val i18 = x >= y
    val i19 = x === y
    val i20 = x !== y
    val i21 = x in x .. y
    val i22 = x !in x .. y

    val by1 = 1.0
    val by2 = byx + byy
    val by3 = byx - byy
    val by4 = byx / byy
    val by5 = byx % byy
    val by6 = byx == byy
    val by7 = byx != byy
    val by8 = byx < byy
    val by9 = byx <= byy
    val by10 = byx > byy
    val by11 = byx >= byy
    val by12 = byx === byy
    val by13 = byx !== byy
    val by14 = byx or byy
    val by15 = byx and byy
    val by16 = byx xor byy

    val s1 = 1.0
    val s2 = sx + sy
    val s3 = sx - sy
    val s4 = sx / sy
    val s5 = sx % sy
    val s6 = sx == sy
    val s7 = sx != sy
    val s8 = sx < sy
    val s9 = sx <= sy
    val s10 = sx > sy
    val s11 = sx >= sy
    val s12 = sx === sy
    val s13 = sx !== sy
    val s14 = sx or sy
    val s15 = sx and sy
    val s16 = sx xor sy

    val l1 = 1.0
    val l2 = lx + ly
    val l3 = lx - ly
    val l4 = lx / ly
    val l5 = lx % ly
    val l6 = lx shl y
    val l7 = lx shr y
    val l8 = lx ushr y
    val l9 = lx and ly
    val l10 = lx or ly
    val l11 = lx xor ly
    val l12 = lx.inv()
    val l13 = lx == ly
    val l14 = lx != ly
    val l15 = lx < ly
    val l16 = lx <= ly
    val l17 = lx > ly
    val l18 = lx >= ly
    val l19 = lx === ly
    val l20 = lx !== ly

    val d1 = 1.0
    val d2 = dx + dy
    val d3 = dx - dy
    val d4 = dx / dy
    val d5 = dx % dy
    val d6 = dx == dy
    val d7 = dx != dy
    val d8 = dx < dy
    val d9 = dx <= dy
    val d10 = dx > dy
    val d11 = dx >= dy
    val d12 = dx === dy
    val d13 = dx !== dy

    val f1 = 1.0
    val f2 = fx + fy
    val f3 = fx - fy
    val f4 = fx / fy
    val f5 = fx % fy
    val f6 = fx == fy
    val f7 = fx != fy
    val f8 = fx < fy
    val f9 = fx <= fy
    val f10 = fx > fy
    val f11 = fx >= fy
    val f12 = fx === fy
    val f13 = fx !== fy

    val b1 = true
    val b2 = false
    val b3 = b1 && b2
    val b4 = b1 || b2
    val b5 = !b1

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
    val str5: String = "foo ${str1 + str2} bar ${str2 + str1} baz"
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

interface Interface1 {}

class Class1 {
    val a1 = 1
    private fun getObject() : Any {
        val a2 = 2
        return object : Interface1 {
            val a3: String = (a1 + a2).toString()
        }
    }
}

fun notNullAssertion(x: Any?) {
    val y: Any = x!!
}

class Class2 {
    fun x(aa: Any?, s: String?) {

        val a = aa.toString()
        val b0  = s.plus(5)
        val b1  = s + 5
        val b2  = s!!.plus(5)
        val b3  = s!! + 5
        val c0 = enumValues<Color>()
        val c1 = Color.values()
        val d0 = enumValueOf<Color>("GREEN")
        val d1 = Color.valueOf("GREEN")
    }
}

fun todo() {
    TODO()
}

class SomeClass1 {}
fun fnClassRef() {
    val x = SomeClass1::class
}

fun equalityTests(notNullPrimitive: Int, nullablePrimitive: Int?, notNullReftype: String, nullableReftype: String?) {
  val b1 = notNullPrimitive == notNullPrimitive
  val b2 = notNullPrimitive == nullablePrimitive
  val b3 = nullablePrimitive == nullablePrimitive
  val b4 = notNullReftype == notNullReftype
  val b5 = notNullReftype == nullableReftype
  val b6 = nullableReftype == nullableReftype
  val b7 = notNullPrimitive != notNullPrimitive
  val b8 = notNullPrimitive != nullablePrimitive
  val b9 = nullablePrimitive != nullablePrimitive
  val b10 = notNullReftype != notNullReftype
  val b11 = notNullReftype != nullableReftype
  val b12 = nullableReftype != nullableReftype
  val b13 = notNullPrimitive == null
  val b14 = nullablePrimitive == null
  val b15 = notNullReftype == null
  val b16 = nullableReftype == null
  val b17 = notNullPrimitive != null
  val b18 = nullablePrimitive != null
  val b19 = notNullReftype != null
  val b20 = nullableReftype != null
}

fun mulOperators(x: Int, y: Int,
                 byx: Byte, byy: Byte,
                 sx: Short, sy: Short,
                 lx: Long, ly: Long,
                 dx: Double, dy: Double,
                 fx: Float, fy: Float) {

  val i = x * y
  val b = byx * byy
  val l = lx * ly
  val d = dx * dy
  val f = fx * fy

}

fun inPlaceOperators() {

  var updated = 0
  updated += 1
  updated -= 1
  updated *= 1
  updated /= 1
  updated %= 1

}

inline fun <reified T : Enum<T>> getEnumValues() = enumValues<T>()

fun callToEnumValues() {
    enumValues<Color>()
    getEnumValues<Color>()
}

fun unaryExprs(i: Int, d: Double, b: Byte, s: Short, l: Long, f: Float) {
    -i
    +i
    -d
    +d
    var i0 = 1
    val i1 = 1
    i0++
    ++i0
    i0--
    --i0
    i0.inc()
    i0.dec()
    i1.inc()
    i1.dec()
    i.inv()

    -b
    +b
    var b0: Byte = 1
    val b1: Byte = 1
    b0++
    ++b0
    b0--
    --b0
    b0.inc()
    b0.dec()
    b1.inc()
    b1.dec()
    b.inv()

    -s
    +s
    var s0: Short = 1
    val s1: Short = 1
    s0++
    ++s0
    s0--
    --s0
    s0.inc()
    s0.dec()
    s1.inc()
    s1.dec()
    s.inv()

    -l
    +l
    var l0: Long = 1
    val l1: Long = 1
    l0++
    ++l0
    l0--
    --l0
    l0.inc()
    l0.dec()
    l1.inc()
    l1.dec()
    l.inv()

    +f
    -f
}

// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Byte.dec in java.lang.Byte %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Byte.inc in java.lang.Byte %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Byte.toInt in java.lang.Byte %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Int.dec in java.lang.Integer %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Int.inc in java.lang.Integer %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Int.rangeTo in java.lang.Integer %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Short.inc in java.lang.Short %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Short.dec in java.lang.Short %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Short.toInt in java.lang.Short %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Long.dec in java.lang.Long %
// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Long.inc in java.lang.Long %

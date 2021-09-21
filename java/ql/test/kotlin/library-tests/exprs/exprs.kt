
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
    return 123 + 456
}

fun getClass() {
    val d = true::class
}
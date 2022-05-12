package test

class TestArrayCreation {
  fun test1() {
    val a0 = arrayOfNulls<Int>(1)
    val a1 = arrayOf(1, 2, 3, 4)
    val a2 = doubleArrayOf(1.0, 2.0, 3.0, 4.0)
    val a3 = floatArrayOf(1.0f, 2.0f, 3.0f, 4.0f)
    val a4 = longArrayOf(1, 2, 3, 4)
    val a5 = intArrayOf(1, 2, 3, 4)
    val a6 = charArrayOf('a', 'b')
    val a7 = shortArrayOf(1, 2, 3, 4)
    val a8 = byteArrayOf(1, 2, 3, 4)
    val a9 = booleanArrayOf(true, false, true, true)

    // TODO: These don't match the corresponding Java hierarchy
    val n0 = arrayOf(intArrayOf(1, 2, 3, 4), intArrayOf(1, 2, 3, 4))    // int[][]
    val n1 = arrayOf(intArrayOf(1, 2, 3, 4), arrayOf(1, 2, 3, 4))       // Object[]
    val n2 = arrayOf(arrayOf(1, 2, 3, 4), arrayOf(1, 2, 3, 4))          // Integer[][]

    // TODO: these are constructor calls:
    val a10 = Array<Int>(1) { 1 }
    val a11 = Array(5) { 1 }
    val a12 = IntArray(5)
    val a13 = IntArray(5) { 1 }
    var a14 = IntArray(5) { it * 1 }
    val a15 = Array(4) { IntArray(2) }

    val clone1 = arrayOf(*a1)
    val clone2 = doubleArrayOf(*a2)
    val clone3 = floatArrayOf(*a3)
    val clone4 = longArrayOf(*a4)
    val clone5 = intArrayOf(*a5)
    val clone6 = charArrayOf(*a6)
    val clone7 = shortArrayOf(*a7)
    val clone8 = byteArrayOf(*a8)
    val clone9 = booleanArrayOf(*a9)
  }
}

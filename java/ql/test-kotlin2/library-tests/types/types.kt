
class Foo {
    val propByte: Byte = 1
    val propShort: Short = 1
    val propInt: Int = 1
    val propLong: Long = 1

    val propUByte: UByte = 1u
    val propUShort: UShort = 1u
    val propUInt: UInt = 1u
    val propULong: ULong = 1u

    val propFloat: Float = 1.0f
    val propDouble: Double = 1.0

    val propBoolean: Boolean = true

    val propChar: Char = 'c'
    val propString: String = "str"

    val propNullableString: String? = "str"

    val propNullableNothing: Nothing? = null

    val propArray: Array<Int> = arrayOf(1, 2, 3)

    val propByteArray: ByteArray = byteArrayOf(1, 2, 3)
    val propShortArray: ShortArray = shortArrayOf(1, 2, 3)
    val propIntArray: IntArray = intArrayOf(1, 2, 3)
    val propLongArray: LongArray = longArrayOf(1, 2, 3)
}

class Gen<T> {
    fun fn1(a: T) {
        val x: Gen<Gen<Int>> = Gen<Gen<Int>>()
        class Local<U> {}
        val y: Gen<Local<Int>> = Gen<Local<Int>>()
        val z = object { }
    }

    fun fn2(a: Gen<out String>, b: Gen<in String>, c: Gen<in Nothing>, d: Gen<out Any?>) {
    }
}

fun arrayGetSet(
  a1: IntArray,
  a2: ShortArray,
  a3: ByteArray,
  a4: LongArray,
  a5: FloatArray,
  a6: DoubleArray,
  a7: BooleanArray,
  a8: CharArray,
  a9: Array<Any>) {

  a1[0] = a1[0]
  a2[0] = a2[0]
  a3[0] = a3[0]
  a4[0] = a4[0]
  a5[0] = a5[0]
  a6[0] = a6[0]
  a7[0] = a7[0]
  a8[0] = a8[0]
  a9[0] = a9[0]

}

fun arrayGetSetInPlace(
  a1: IntArray,
  //a2: ShortArray,
  //a3: ByteArray,
  a4: LongArray,
  a5: FloatArray,
  a6: DoubleArray) {

  a1[0] += 1
  // Short and Byte's arithmetic operators yield an Int,
  // so we don't have syntax to convert the result of the arithmetic op
  // back to the right type.
  //a2[0] %= 1.toShort()
  //a3[0] *= 1.toByte()
  a4[0] /= 1L
  a5[0] -= 1f
  a6[0] *= 1.0
}
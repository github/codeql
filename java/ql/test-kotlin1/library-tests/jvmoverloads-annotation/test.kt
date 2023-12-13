fun getString() = "Hello world"

object Test {

  @JvmOverloads @JvmStatic
  fun testStaticFunction(a: Int, b: String = getString(), c: Double, d: Float = 1.0f, e: Boolean): Int = a

  @JvmOverloads
  fun testMemberFunction(a: Int, b: String = getString(), c: Double, d: Float = 1.0f, e: Boolean): Int = a

  @JvmOverloads
  fun Test2.testMemberExtensionFunction(a: Int, b: String = getString(), c: Double, d: Float = 1.0f, e: Boolean): Int = a

}

public class Test2 @JvmOverloads constructor(a: Int, b: String = getString(), c: Double, d: Float = 1.0f, e: Boolean) {

  companion object {

    @JvmOverloads
    fun testCompanionFunction(a: Int, b: String = getString(), c: Double, d: Float = 1.0f, e: Boolean): Int = a

    @JvmOverloads @JvmStatic
    fun testStaticCompanionFunction(a: Int, b: String = getString(), c: Double, d: Float = 1.0f, e: Boolean): Int = a

  }

}

public class GenericTest<T> @JvmOverloads constructor(a: Int = 1, b: T, c: String = "Hello world", d: T) {

  @JvmOverloads
  fun testMemberFunction(a: Int = 1, b: T, c: String = "Hello world", d: T): Int = a

  fun useSpecialised(spec1: GenericTest<Float>, spec2: GenericTest<Double>) {

    spec1.testMemberFunction(1, 1.0f, "Hello world", 2.0f)
    spec2.testMemberFunction(1, 1.0, "Hello world", 2.0)

  }

}

@JvmOverloads
fun Test.testExtensionFunction(a: Int, b: String = getString(), c: Double, d: Float = 1.0f, e: Boolean): Int = a

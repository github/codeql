public class Kotlin {
	fun kotlinFun() {
		// TODO: Java().javaFun();
	}
}

open class Base {
    open fun fn0(x: Int) : String = ""
    open suspend fun fn1(x: Int) : String = ""
}

class Dkotlin : Base() {
    override fun fn0(x: Int): String = super.fn0(x)
    override suspend fun fn1(x: Int): String = super.fn1(x)
}

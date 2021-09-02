
class ClassOne { }

class ClassTwo (val arg: Int) {
    val x: Int = 3
}

abstract class ClassThree {
    abstract fun foo(arg: Int)
}

open class ClassFour: ClassThree() {
    override fun foo(arg: Int) {
    }
}

class ClassFive: ClassFour() {
}

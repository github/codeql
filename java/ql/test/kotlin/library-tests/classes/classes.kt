
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

interface IF1 {
    fun funIF1() {}
}

interface IF2 {
    fun funIF2() {}
}

class ClassSix(): ClassFour(), IF1, IF2 {
    constructor(i: Int): this(){ }
}


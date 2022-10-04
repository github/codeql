
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

fun f(s: String) {}

class ClassSeven {
    constructor(i: String) {
        f(i)
    }
    init {
        f("init1")
    }

    val x: Int = 3

    init {
        f("init2")
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

interface Interface1 {}
interface Interface2 {}
interface Interface3<T> {}

class Class1 {
    private fun getObject1(b: Boolean) : Any {
        if (b)
            return object : Interface1, Interface2 { }
        else
            return object : Interface1, Interface2, Interface3<String> { }
    }

    private fun getObject2() : Interface1 {
        return object : Interface1, Interface2 {
            val x = 1
            fun foo(): Any {
                return object { }
            }
         }
    }

    private fun getObject3() : Any {
        return object : Interface1 { }
    }

    private fun getObject4() : Any {
        return object { }
    }

    private fun getObject5() : Any {
        return object : Interface3<Int?> { }
    }
}

public class pulicClass {}
private class privateClass {}
internal class internalClass {}
class noExplicitVisibilityClass {}

class nestedClassVisibilities {
    public class pulicNestedClass {}
    protected class protectedNestedClass {}
    private class privateNestedClass {}
    internal class internalNestedClass {}
    class noExplicitVisibilityNestedClass {}
}

sealed class sealedClass {}
open class openClass {}

class C1 {
    fun fn1(p: Int) {
        class Local1<T1> {
            fun foo(p: Int) { }
        }
        Local1<Int>().foo(p)
    }

    fun fn2(p: Int) {
        fun localFn() {
            class Local2<T1> {
                fun foo(p: Int) { }
            }
            Local2<Int>().foo(p)
        }
    }

    fun fn3(p: Int): Any {
        return object {
            fun fn() {
                class Local3<T1> {
                    fun foo(p: Int) { }
                }
                Local3<Int>().foo(p)
            }
        }
    }
}

class Cl0<U0> {
    fun <U1> func1() {
        fun <U2> func2() {
            class Cl1<U3>{
                fun fn() {
                    val x = Cl1<U3>()
                }
            }
        }
    }
}

class Cl00<U0> {
    class Cl01<U1>{
        fun fn() {
            val x = Cl01<U1>()
        }
    }
}

fun fn1() {
    class X {}
}

fun fn2() = object { }

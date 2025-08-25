import java.awt.Rectangle

import kotlin.reflect.*

class Reflection {
    fun fn() {
        val ref: KFunction2<Ccc, Int, Double> = Ccc::m
        println(ref.name)

        val x0: KProperty1<C, Int> = C::p0
        val x1: Int = x0.get(C())
        val x2: String = x0.name
        val x3: KProperty1.Getter<C, Int> = x0.getter
        val x4: KFunction1<C, Int> = x0::get
        val x5: KProperty0<Int> = C()::p0

        val y0: KMutableProperty1<C, Int> = C::p1
        val y1: Unit = y0.set(C(), 5)
        val y2: String = y0.name
        val y3: KMutableProperty1.Setter<C, Int> = y0.setter
        val y4: KFunction2<C, Int, Unit> = y0::set
        val y5: KMutableProperty0<Int> = C()::p1

        val prop = (C::class).members.single { it.name == "p3" } as KProperty2<C, Int, Int>
        val z0 = prop.get(C(), 5)
    }

    class Ccc {
        fun m(i:Int):Double = 5.0
    }

    class C {
        val p0: Int = 1
        var p1: Int = 2
        var p2: Int
            get() = 1
            set(value) = Unit

        var Int.p3: Int         // this can't be referenced through a property reference
            get() = 1
            set(value) = Unit
    }
}


val String.lastChar: Char
    get() = this[length - 1]

fun fn2() {
    println(String::lastChar.get("abc"))
    println("abcd"::lastChar.get())
}

fun <T2> Class1.Generic<T2>.ext1() = this.toString()

fun Class1.Generic<Int>.ext2() = this.toString()

class Class1 {
    fun fn() {
        println(Generic<Int>::m1)
        println(Generic<Int>()::m1)
        println(Generic<Int>::ext1)
        println(Generic<Int>()::ext1)
        println(Generic<Int>::ext2)
        println(Generic<Int>()::ext2)

        println(Generic<Int>::p2)
        println(Generic<Int>()::p2)

        println(Int::MAX_VALUE)         // Companion object and property getter
        println(Integer::MAX_VALUE)     // Static field access, no getter
        println(Rectangle()::height)    // Field access, no getter, with dispatch receiver
    }

    class Generic<T1> {
        fun m1(i:T1) = this.toString()
        var p2: T1?
            get() = null
            set(value) = Unit
    }
}

class Class2<T>(val value: T) {

    inner class Inner<T1> {
        constructor(t: T1) { }
    }

    fun test() {
        fn11("", ::Inner)
    }
}

fun <T> fn(value: T) { }

fun test() {
    fn11("", ::Class2)
    fn11("", ::fn)
    fn12("", Class2(5)::Inner)
}

fun <T, R> fn11(l: T, transform: (T) -> R) { }
fun <T1, R> fn12(l: T1, l2: (T1) -> R) { }

open class Base1(var prop1: Int) {}

class Derived1(prop1: Int) : Base1(prop1) {
    fun fn() {
        println(this::prop1)
    }
}

class LocalFn {
    fun fn() {
        fun fn1(i: Int) { }
        val x: KFunction1<Int, Unit> = ::fn1
    }
}


fun fn1() = 5

fun fn2(f: () -> Unit) = f()

fun adapted() {
    fn2(::fn1)
}

fun expectsOneParam(f: (Int) -> Int) = f(0)

fun takesOptionalParam(x: Int, y: Int = 0) = x + y

fun adaptedParams() {
    expectsOneParam(::takesOptionalParam)
}

fun expectsOneParamAndReceiver(f: (MemberOptionalsTest, Int) -> Int) { }

class MemberOptionalsTest {
    fun takesOptionalParam(x: Int, y: Int = 0) = x + y
}

fun memberAdaptedParams(m: MemberOptionalsTest) {
    expectsOneParam(m::takesOptionalParam)
    expectsOneParamAndReceiver(MemberOptionalsTest::takesOptionalParam)
}

fun expectsOneParamAndExtension(f: (String, Int) -> Int) { }

fun String.extTakesOptionalParam(x: Int, y: Int = 0) = x + y

fun extensionAdaptedParams(s: String) {
    expectsOneParam(s::extTakesOptionalParam)
    expectsOneParamAndExtension(String::extTakesOptionalParam)
}

class ConstructorOptional(x: Int, y: Int = 0) { }

fun expectsOneParamCons(f: (Int) -> ConstructorOptional) = f(0)

fun constructorAdaptedParams() {
    expectsOneParamCons(::ConstructorOptional)
}

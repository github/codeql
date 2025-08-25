fun functionExpression0a(f: () -> Int) { f() }
fun functionExpression0b(f: () -> Any?) { f() }
fun functionExpression0c(f: () -> Any) { f() }
fun functionExpression1a(x: Int, f: (Int) -> Int) { f(x) }
fun functionExpression1b(x: Int, f: (Any?) -> Any?) { f(x) }
fun functionExpression1c(x: Int, f: (FuncRef, Int) -> Int) { f(FuncRef(), x) }
fun functionExpression2(x: Int, f: (Int, Int) -> Int) { f(x, x) }
fun functionExpression3(x: Int, f: Int.(Int) -> Int) { x.f(x) }
fun functionExpression4(x: Int, f: (Int) -> ((Int) -> Double)) { f(x)(x) }

fun functionExpression22(x: Int, f: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> Unit) {
    f(x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x)
}
fun functionExpression23(x: Int, f: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> String) {
    f(x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x)
}
fun functionExpression23c(x: Int, f: (FuncRef, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> String) {
    f(FuncRef(),x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x)
}

fun call() {
    functionExpression0a { -> 5 }
    functionExpression0b { -> 5 }
    functionExpression0c { -> 5 }
    functionExpression1a(5) { a -> 5 }
    functionExpression1a(5) { it }
    functionExpression1a(5, fun(_:Int) = 5)
    functionExpression1a(5, MyLambda())
    functionExpression1b(5) { a -> a}
    functionExpression2(5, fun(_: Int, _: Int) = 5)
    functionExpression2(5) { _, _ -> 5 }
    functionExpression3(5) { a -> this + a }
    functionExpression4(5) { a -> ( { b -> 5.0} ) }

    functionExpression22(5) {a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21 -> 5}
    functionExpression23(5) {a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22 -> ""}

    functionExpression0a(FuncRef()::f0)
    functionExpression0a(FuncRef::f0)
    functionExpression1a(5, FuncRef()::f1)
    functionExpression1c(5, FuncRef::f1)
    functionExpression1a(5, 3::f3)
    functionExpression3(5, Int::f3)
    functionExpression22(5, FuncRef()::f22)
    functionExpression23(5, FuncRef()::f23)
    functionExpression23c(5, FuncRef::f23)

    fun local(): Int = 5
    functionExpression0a(::local)

    fn(::FuncRef)
}

class MyLambda: (Int) -> Int {
    override operator fun invoke(x: Int): Int = 5
}

fun <T> fn(l: () -> T) {}
fun Int.f3(a: Int) = 5

class FuncRef {
    companion object {
        fun f0(): Int = 5
    }
    fun f0(): Int = 5
    fun f1(a: Int): Int = 5
    fun f22(a0: Int, a1: Int, a2: Int, a3: Int, a4: Int, a5: Int, a6: Int, a7: Int, a8: Int, a9: Int, a10: Int,
            a11: Int, a12: Int, a13: Int, a14: Int, a15: Int, a16:Int, a17: Int, a18: Int, a19: Int, a20: Int, a21: Int) {}
    fun f23(a0: Int, a1: Int, a2: Int, a3: Int, a4: Int, a5: Int, a6: Int, a7: Int, a8: Int, a9: Int, a10: Int,
            a11: Int, a12: Int, a13: Int, a14: Int, a15: Int, a16:Int, a17: Int, a18: Int, a19: Int, a20: Int, a21: Int, a22: Int) = ""
}

class Class3 {
    fun call() {
        fn { a -> "a"}
    }
    private fun fn(f: (Generic<Generic<Int>>) -> String) { }

    class Generic<T> { }
}

suspend fun fn() {
    val l1: (Int) -> String = { i -> i.toString() }
    l1.invoke(5)        // calls kotlin/jvm/functions/Function1.invoke

    val l2: suspend (Int) -> String = { i -> i.toString() }
    l2.invoke(5)        // calls kotlin/jvm/functions/Function2.invoke

    val l3: (Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int) -> String
            = { _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_ ->  ""}
    l3.invoke(1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3)    // 23 args, calls kotlin/jvm/functions/FunctionN.invoke

    val l4: suspend (Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int,Int) -> String
            = { _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_ ->  ""}
    l4.invoke(1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2)      // 22 args, calls kotlin/jvm/functions/FunctionN.invoke
}

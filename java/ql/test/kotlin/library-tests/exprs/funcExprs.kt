fun functionExpression0a(f: () -> Int) { }
fun functionExpression0b(f: () -> Any?) { }
fun functionExpression0c(f: () -> Any) { }
fun functionExpression1a(x: Int, f: (Int) -> Int) { }
fun functionExpression1b(x: Int, f: (Any?) -> Any?) { }
fun functionExpression2(x: Int, f: (Int, Int) -> Int) { }
fun functionExpression3(x: Int, f: Int.(Int) -> Int) { }
fun functionExpression4(x: Int, f: (Int) -> ((Int) -> Double)) { }

fun functionExpression22(x: Int, f: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> Unit) {}
fun functionExpression23(x: Int, f: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> String) {}

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
}

class MyLambda: (Int) -> Int {
    override operator fun invoke(x: Int): Int = 5
}
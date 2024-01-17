sealed interface DbAddexpr

class Label<T> {
}

fun <T> getFreshIdLabel(): Label<T> {
    return Label()
}

fun foo(): Label<DbAddexpr> {
    val x = getFreshIdLabel<DbAddexpr>()
    return x
}

fun main1() {
    print(foo())
}

class Foo {
    data class DC(val x: Int, val y: Int)

    fun foo() {
        val dc = DC(3, 4)
        print(dc.x)
        print(dc.y)
    }
}

fun main2() {
    Foo().foo()
}

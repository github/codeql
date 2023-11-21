
class MyClass<T> {}

typealias AliasInt = Int
typealias AliasX = MyClass<Int>
typealias AliasY = MyClass<AliasInt>

fun someFun(
    x1: Int,
    x2: AliasInt,
    x3: MyClass<Int>,
    x4: AliasX,
    x5: MyClass<AliasInt>,
    x6: AliasY) {
}


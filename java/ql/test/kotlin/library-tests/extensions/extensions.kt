
class SomeClass {
    fun someClassMethod() {}
}
class AnotherClass {
    fun anotherClassMethod() {}
}

fun SomeClass.someFun() {}
fun AnotherClass.anotherFun() {}

fun SomeClass.bothFun() {}
fun AnotherClass.bothFun() {}

fun SomeClass.bothFunDiffTypes(): Int { return 5 }
fun AnotherClass.bothFunDiffTypes(): String { return "Foo" }

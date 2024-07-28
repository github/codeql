
class SomeClass {
    fun someClassMethod(p1: String) {}
}
class AnotherClass {
    fun anotherClassMethod(p1: String) {}
}

fun SomeClass.someFun(p1: String) {}
fun AnotherClass.anotherFun(p1: String) {}

fun SomeClass.bothFun(p1: String) {}
fun AnotherClass.bothFun(p1: String) {}

fun SomeClass.bothFunDiffTypes(p1: Int): Int { return 5 }
fun AnotherClass.bothFunDiffTypes(p1: String): String { return "Foo" }

fun String.bar(p1: String): String { return "Bar" }

fun foo() {
    SomeClass().someClassMethod("foo")
    SomeClass().someFun("foo")
    SomeClass().bothFun("foo")
    SomeClass().bothFunDiffTypes(1)
    AnotherClass().anotherClassMethod("foo")
    AnotherClass().anotherFun("foo")
    AnotherClass().bothFun("foo")
    AnotherClass().bothFunDiffTypes("foo")
    "someString".bar("foo")
    fun String.baz(p1: String): String { return "Baz" }
    "someString".baz("bazParam")
}

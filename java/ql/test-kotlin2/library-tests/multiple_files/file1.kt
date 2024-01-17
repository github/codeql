
class Class1 {
    fun fun1() {
        Class2().fun2()
        fun3()
        fun4()

        // libraries/stdlib/jvm/runtime/kotlin/jvm/internal/CollectionToArray.kt
        // has a @file:JvmName("CollectionToArray") annotation, and contains
        // a function collectionToArray with a @JvmName("toArray") annotation.
        kotlin.jvm.internal.collectionToArray(listOf(1))
    }
}

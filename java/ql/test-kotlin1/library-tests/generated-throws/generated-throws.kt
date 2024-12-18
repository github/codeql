
sealed interface Foo {}
interface Bar: Foo {}
interface Baz: Foo {}

private fun someFun(v: Foo) {
    // This doesn't generate a throw statement in Kotlin 1 mode
    when (v) {
        is Bar -> {}
        is Baz -> {}
    }
}


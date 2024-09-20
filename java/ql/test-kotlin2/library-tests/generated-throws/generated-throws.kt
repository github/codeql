
sealed interface Foo {}
interface Bar: Foo {}
interface Baz: Foo {}

private fun someFun(v: Foo) {
    when (v) {
        is Bar -> {}
        is Baz -> {}
    }
}


// codeql-extractor-kotlin-options: -language-version 2.4 -Xcompanion-blocks-and-extensions

class Box(val value: String) {
    companion {
        fun empty() = Box("")
    }
}

companion fun Box.create(value: String) = Box(value)

companion val Box.default: Box
    get() = Box("")

fun source(): String = ""

fun sink(value: String) {}

fun test() {
    sink(Box.create(source()).value)
    sink(Box.default.value)
}

// codeql-extractor-kotlin-options: -language-version 2.4 -XXLanguage:+CollectionLiterals

class Words private constructor(val values: Array<out String>) {
    companion object {
        operator fun of(vararg values: String) = Words(values)
    }
}

fun source(): String = ""

fun sink(value: String) {}

fun test() {
    val words: Words = [source(), "two"]
    sink(words.values[0])
}

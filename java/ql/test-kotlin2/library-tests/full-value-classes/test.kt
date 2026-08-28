// codeql-extractor-kotlin-options: -XXLanguage:+FullValueClasses

abstract value class Base {
    abstract val value: Int
}

value class PairValue(override val value: Int, val label: String) : Base() {
    constructor(value: String) : this(value.length, value)
}

fun makePairValue(value: String): Base = PairValue(value)

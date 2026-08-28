// codeql-extractor-kotlin-options: -XXLanguage:+FullValueClasses

abstract value class Base {
    abstract val value: Int
}

value class PairValue(override val value: Int, val label: String) : Base() {
    constructor(value: Long) : this(value.toInt(), value.toString())
}

fun makePairValue(value: Long): Base = PairValue(value)

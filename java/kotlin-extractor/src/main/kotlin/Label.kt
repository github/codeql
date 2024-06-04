package com.github.codeql

/** This represents a label (`#...`) in a TRAP file. */
interface Label<T : AnyDbType> {
    fun <U : AnyDbType> cast(): Label<U> {
        @Suppress("UNCHECKED_CAST") return this as Label<U>
    }
}

/** The label `#i`, e.g. `#123`. Most labels we generate are of this form. */
class IntLabel<T : AnyDbType>(val i: Int) : Label<T> {
    override fun toString(): String = "#$i"
}

/**
 * The label `#name`, e.g. `#compilation`. This is used when labels are shared between different
 * components (e.g. when both the interceptor and the extractor need to refer to the same label).
 */
class StringLabel<T : AnyDbType>(val name: String) : Label<T> {
    override fun toString(): String = "#$name"
}

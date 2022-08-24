package com.github.codeql

/**
 * This behaves the same as Iterable<T>.find, but requires
 * that the value found is of the subtype S, and it casts
 * the result for you appropriately.
 */
inline fun <T,reified S: T> Iterable<T>.findSubType(
    predicate: (S) -> Boolean
): S? {
    return this.find { it is S && predicate(it) } as S?
}


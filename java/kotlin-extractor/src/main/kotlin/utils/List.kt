package com.github.codeql

/**
 * Turns this list of nullable elements into a list of non-nullable elements if they are all
 * non-null, or returns null otherwise.
 */
public fun <T : Any> List<T?>.requireNoNullsOrNull(): List<T>? {
    try {
        return this.requireNoNulls()
    } catch (e: IllegalArgumentException) {
        return null
    }
}

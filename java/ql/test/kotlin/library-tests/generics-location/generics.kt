package main

class B<T> {
    fun fn() {
        val a0 = A<String>()
        val a1 = A<Any>()

        val b0 = B<String>()
        val b1 = B<Any>()
    }
}

// Diagnostic Matches: Incomplete annotation: @kotlin.Metadata(%)
// Diagnostic Matches: Unknown location for kotlin.Metadata

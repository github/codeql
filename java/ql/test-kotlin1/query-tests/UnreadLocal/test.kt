fun fn0(size: Int) {
    for (idx in 1..size) {
        println()
    }
}

fun fn1(a: Array<Int>) {
    for (e in a) {
        println()
    }
}

fun fn2(a: Array<Int>) {
    for ((idx, e) in a.withIndex()) {
        println()
    }
}

fun fn3() {
    for (i in 1 until 10) {
        println()
    }
}

// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Int.rangeTo in java.lang.Integer%

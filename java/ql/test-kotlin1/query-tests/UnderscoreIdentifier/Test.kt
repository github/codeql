fun fn() {
    try {
        val l = listOf(1, 2, 3)
        l.forEachIndexed { index, _ -> println(index) }

        val p = Pair(1, 2)
        val (first, _) = p
    } catch (_: Exception) {
        // expected
    }
}

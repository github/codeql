fun interface Predicate {
    fun go(s: String): String
}

fun interface PredicateSusp {
    suspend fun go(s: String): String
}

class SamConversion {
    suspend fun test() {
        val p1 = Predicate { Helper.taint() }
        val p2 = Predicate { it -> it }

        Helper.sink(p1.go(""))
        Helper.sink(p2.go(Helper.taint()))

        val p3 = PredicateSusp { Helper.taint() }
        val p4 = PredicateSusp { it -> it }

        Helper.sink(p3.go(""))
        Helper.sink(p4.go(Helper.taint()))
    }
}

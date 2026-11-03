class Target

class KClassJavaArg {
    fun consume(c: Class<*>) {}

    fun test() {
        // `Target::class.java` must be extracted as the argument to `consume`.
        consume(Target::class.java)
    }
}

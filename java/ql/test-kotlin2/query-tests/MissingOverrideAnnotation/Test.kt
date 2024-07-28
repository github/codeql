open class A {
    open fun m(): Int {
        return 23
    }

    private fun n() {}

    open val p = 5
}

interface I {
    fun o()
}

class B : A(), I {
    override fun m(): Int {
        return 42
    }

    fun n() {}

    override fun o() { }

    override val p = 7
}
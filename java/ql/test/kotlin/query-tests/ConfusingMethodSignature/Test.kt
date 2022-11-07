class C {
    var p: Int
        get() = 1
        set(value) {}
    fun fn() {
        val prop = C::p
        prop(this)
    }
}

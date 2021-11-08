class MyClass {
    fun funInClass() {}
    companion object MyClassCompanion {
        fun funInCompanion() {}
    }
}

fun user() {
    MyClass.funInCompanion()
    MyClass().funInClass()
}


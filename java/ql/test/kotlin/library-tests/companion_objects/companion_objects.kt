class MyClass {
    fun funInClass() {}
    companion object MyClassCompanion {
        fun funInCompanion() {}
    }
}

interface MyInterface {
    fun funInInterface()
    companion object MyInterfaceCompanion {
        fun funInCompanion() {}
    }
}

class Imp : MyInterface {
    override fun funInInterface() {
        TODO("Not yet implemented")
    }

}

fun user() {
    MyClass.funInCompanion()
    MyClass().funInClass()
    MyInterface.funInCompanion()
    Imp().funInInterface()
}


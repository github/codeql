abstract class Base(func:() -> Unit = {}) { }

class Derived : Base({
    data class Dc(val foo: String)
})

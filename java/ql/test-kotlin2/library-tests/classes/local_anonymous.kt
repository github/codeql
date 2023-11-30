package LocalAnonymous

class Class1 {
    fun fn1(): Any {
        return object {
            fun fn() {}
        }
    }

    fun fn2() {
        fun fnLocal() {}
        fnLocal()
    }

    fun fn3() {
        val lambda1 = { a: Int, b: Int -> a + b }
        val lambda2 = fun(a: Int, b: Int) = a + b
    }

    fun fn4() {
        val fnRef = Class1::fn3
    }

    fun fn5() {
        class LocalClass {}
        LocalClass()
    }

    fun nullableAnonymous() = object {
        var x = 1

        fun member() {
            val maybeThis = if (x == 1) this else null // Expression with nullable anonymous type
        }
    }
}

interface Interface2 {}
class Class2 {
     var i = object: Interface2 {
        init {
            var answer: String = "42" // Local variable in anonymous class initializer
        }
    }
}

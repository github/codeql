class Processor {
    fun <R1> process(f: () -> R1) : R1 {
        return f()
    }

    fun <T, R2> process(f: (T) -> R2, arg: T) : R2 {
        return f(arg)
    }

    suspend fun <T, R2> processSusp(f: suspend (T) -> R2, arg: T) : R2 {
        return f(arg)
    }

    fun <T0, T1, R3> process(f: (T0, T1) -> R3, arg0: T0, arg1: T1) : R3 {
        return f(arg0, arg1)
    }

    fun <T, R4> process(
        f: (T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T) -> R4,
        a: T, b: T) : R4 {
        return f(a,b,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a)
    }

    fun <T, R5> processExt(f: T.(T) -> R5, ext: T, arg: T) : R5 {
        return ext.f(arg)
    }
}

class Helper {
    companion object {
        fun taint(): String = "taint"
        fun notaint(): String = "notaint"
        fun sink(a: Any?) { }
    }
}

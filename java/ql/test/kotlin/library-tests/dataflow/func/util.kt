class Processor {
    fun <R> process(f: () -> R) : R {
        return f()
    }

    fun <T, R> process(f: (T) -> R, arg: T) : R {
        return f(arg)
    }

    fun <T0, T1, R> process(f: (T0, T1) -> R, arg0: T0, arg1: T1) : R {
        return f(arg0, arg1)
    }

    fun <T, R> process(
        f: (T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T) -> R,
        a: T, b: T) : R {
        return f(a,b,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a)
    }

    fun <T, R> processExt(f: T.(T) -> R, ext: T, arg: T) : R {
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

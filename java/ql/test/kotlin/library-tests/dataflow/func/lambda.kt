class Lambda {
    suspend fun test() {
        Helper.sink(Processor().process({ it: String -> Helper.notaint() }, ""))
        Helper.sink(Processor().process({ it: String -> Helper.taint() }, ""))
        Helper.sink(Processor().processSusp({ it: String -> Helper.taint() }, ""))
        Helper.sink(Processor().process({ i -> i }, Helper.taint()))
        Helper.sink(Processor().process(fun (i: String) = i, Helper.taint()))

        Helper.sink(Processor().processExt({ i -> i }, Helper.taint(), Helper.notaint()))
        Helper.sink(Processor().processExt({ i -> i }, Helper.notaint(), Helper.taint()))
        Helper.sink(Processor().processExt({ i -> this }, Helper.taint(), Helper.notaint()))
        Helper.sink(Processor().processExt({ i -> this }, Helper.notaint(), Helper.taint()))

        Helper.sink(Processor().process({ i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23 -> i0 }, Helper.taint(), Helper.notaint()))
        Helper.sink(Processor().process({ i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23 -> i0 }, Helper.notaint(), Helper.taint())) // False positive
    }
}

class ManualBigLambda {
    fun invoke(s0: String, s1: String): String {
        return s0
    }
    fun invoke(a: Array<Any?>): String {
        return invoke(a[0] as String, a[1] as String)
    }

    fun call() {
        Helper.sink(invoke(Helper.taint(), Helper.notaint()))
        Helper.sink(invoke(Helper.notaint(), Helper.taint()))
        Helper.sink(invoke(arrayOf(Helper.taint(), Helper.notaint())))
        Helper.sink(invoke(arrayOf(Helper.notaint(), Helper.taint())))      // False positive
    }
}

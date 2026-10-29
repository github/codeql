public class LateInit {
    private lateinit var test0: LateInit

    fun f() = println("a")

    fun init() = LateInit()

    fun fn() {
        test0.f()                           // This is preceded by a null-check and a throw in bytecode, in IR it's a simple call
        if (this::test0.isInitialized) {    // This is converted to a null-check in bytecode, in IR it's a call to `LateinitKt.isInitialized`
        }

        lateinit var test1: LateInit
        test1.f()                           // This is replaced by `Intrinsics.throwUninitializedPropertyAccessException` in bytecode, in IR it's a simple call
    }
}

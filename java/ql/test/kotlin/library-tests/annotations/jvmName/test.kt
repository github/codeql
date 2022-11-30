class X {
    val x: Int
        @JvmName("getX_prop")
        get() = 15

    fun getX() = 10

    @get:JvmName("y")
    @set:JvmName("changeY")
    var y: Int = 23

    @JvmName("method")
    fun fn() {}
}

annotation class Ann(
    val p: Int,
    @get:JvmName("w") val q: Int)

// Diagnostic Matches: Incomplete annotation: @kotlin.jvm.JvmName(name="changeY")
// Diagnostic Matches: Incomplete annotation: @kotlin.jvm.JvmName(name="getX_prop")
// Diagnostic Matches: Incomplete annotation: @kotlin.jvm.JvmName(name="method")
// Diagnostic Matches: Incomplete annotation: @kotlin.jvm.JvmName(name="y")
// Diagnostic Matches: Unknown location for kotlin.jvm.JvmName

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

data class D(val x: Int) {}

data class E(val x: Int) {
    override fun equals(other: Any?): Boolean {
        return (other as? E)?.x == this.x
    }
}

data class F(val x: Int) {
    override fun equals(other: Any?): Boolean {
        return other != null && other::class == this::class
    }
}

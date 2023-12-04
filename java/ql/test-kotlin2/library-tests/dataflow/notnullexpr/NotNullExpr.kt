class NotNullExpr {
  fun taint() = Uri()

  fun sink(s: String) { }

  fun bad() {
    val s0 = taint()
    sink(s0!!.getQueryParameter())
  }
}

class Uri {
    fun getQueryParameter() = "tainted"
}

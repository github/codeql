class WhenExpr {
  fun taint() = Uri()

  fun sink(s: String?) { }

  fun bad(b: Boolean) {
    val s0 = if (b) taint() else null
    sink(s0?.getQueryParameter())
  }
}

class Uri {
    fun getQueryParameter() = "tainted"
}

class StringTemplateTests {
  fun taint() = "tainted"

  fun  sink(s: String) { }

  fun bad() {
    val s0 = taint()
    val s1 = "test $s0"
    sink(s1)
  }
}

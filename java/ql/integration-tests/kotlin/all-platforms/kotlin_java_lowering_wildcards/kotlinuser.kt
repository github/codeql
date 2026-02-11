
fun user() {
  val cs = ComparableCs()
  val acs = arrayOf(cs)

  JavaDefns.takesComparable(cs, cs)
  JavaDefns.takesArrayOfComparable(acs, acs)

  val constructed = JavaDefns(cs, cs)

  JavaDefns2.takesComparable(cs, cs)
}

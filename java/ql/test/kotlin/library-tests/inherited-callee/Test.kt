open class TestKt {

  fun inheritMe() { }

}

interface ParentIf {

  fun inheritedInterfaceMethodK()

}

interface ChildIf : ParentIf {


}

class ChildKt : TestKt() {

  fun user() {

    val c = ChildKt()
    c.toString()
    c.equals(c)
    c.hashCode()
    c.inheritMe()
    val c2: ParentIf? = null
    c2?.inheritedInterfaceMethodK()

  }

}


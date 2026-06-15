open class TestKt {

  fun inheritMe() { }

}

interface ParentIfK {

  fun inheritedInterfaceMethodK()

}

interface ChildIfK : ParentIfK {


}

class ChildKt : TestKt() {

  fun user() {

    val c = ChildKt()
    c.toString()
    c.equals(c)
    c.hashCode()
    c.inheritMe()
    val c2: ParentIfK? = null
    c2?.inheritedInterfaceMethodK()

  }

}


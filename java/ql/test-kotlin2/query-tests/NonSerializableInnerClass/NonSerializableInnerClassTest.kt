import java.io.Serializable

class A {
  class X : Serializable {
  }
}

class B {
  inner class X : Serializable {
  }
}

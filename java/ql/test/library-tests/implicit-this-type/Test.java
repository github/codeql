class Gen<T> {
  void m(T t) { }
}

class SubSpec extends Gen<String> {
  void foo() {
    m("direct implicit this");
    this.m("direct explicit this");
  }

  class Inner {
    void bar() {
      m("direct implicit this from inner");
      SubSpec.this.m("direct explicit this from inner");
    }
  }

  void hasLocal() {
    class Local {
      void baz() {
        m("direct implicit this from local");
        SubSpec.this.m("direct explicit this from local");
      }
    }
  }
}

class SubGen<S> extends Gen<S> {
  void foo() {
    m((S)"direct implicit this (generic sub)");
    this.m((S)"direct explicit this (generic sub)");
  }

  class Inner {
    void bar() {
      m((S)"direct implicit this from inner (generic sub)");
      SubGen.this.m((S)"direct explicit this from inner (generic sub)");
    }
  }
}

class Intermediate<S> extends Gen<S> { }

class GrandchildSpec extends Intermediate<String> {
  void foo() {
    m("indirect implicit this");
    this.m("indirect explicit this");
  }

  class Inner {
    void bar() {
      m("indirect implicit this from inner");
      GrandchildSpec.this.m("indirect explicit this from inner");
    }
  }
}

class GrandchildGen<R> extends Intermediate<R> {
  void foo() {
    m((R)"indirect implicit this (generic sub)");
    this.m((R)"indirect explicit this (generic sub)");
  }

  class Inner {
    void bar() {
      m((R)"indirect implicit this from inner (generic sub)");
      GrandchildGen.this.m((R)"indirect explicit this from inner (generic sub)");
    }
  }
}

class UninvolvedOuter {
  class InnerGen<T> {
    void m(T t) { }
  }
  
  class InnerSpec extends InnerGen<String> {
    void foo() {
      m("direct implicit this, from inner to inner");
      this.m("direct explicit this, from inner to inner");
    }
  }
}

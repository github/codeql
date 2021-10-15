class GlobalClass {
  globalFunction(){
    globalFunction(); // NOT OK
  }
  topNamespaceFunction(){
    topNamespaceFunction(); // NOT OK
  }
  childNamespaceFunction(){
    childNamespaceFunction(); // NOT OK
  }
}

namespace Top {
  class TopClass {
    globalFunction(){
      globalFunction(); // NOT OK
    }
    topNamespaceFunction(){
      topNamespaceFunction(); // OK
    }
    childNamespaceFunction(){
      childNamespaceFunction();  // NOT OK, but not flagged since the namespace resolution is ignored
    }
  }
}

namespace Top.Child {
  class ChildClass {
    globalFunction(){
      globalFunction(); // NOT OK
    }
    topNamespaceFunction(){
      topNamespaceFunction(); // OK
    }
    childNamespaceFunction(){
      childNamespaceFunction(); // OK
    }
  }
}
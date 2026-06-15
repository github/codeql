class GlobalClass {
  globalFunction() {
    globalFunction(); // $ Alert
  }
  topNamespaceFunction() {
    topNamespaceFunction(); // $ Alert
  }
  childNamespaceFunction() {
    childNamespaceFunction(); // $ Alert
  }
}

namespace Top {
  class TopClass {
    globalFunction() {
      globalFunction(); // $ Alert
    }
    topNamespaceFunction() {
      topNamespaceFunction();
    }
    childNamespaceFunction() {
      childNamespaceFunction();  // $ MISSING: Alert - not flagged since the namespace resolution is ignored
    }
  }
}

namespace Top.Child {
  class ChildClass {
    globalFunction() {
      globalFunction(); // $ Alert
    }
    topNamespaceFunction() {
      topNamespaceFunction();
    }
    childNamespaceFunction() {
      childNamespaceFunction();
    }
  }
}

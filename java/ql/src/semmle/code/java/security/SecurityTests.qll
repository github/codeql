/** Test detection for the security pack. */

import java

/** A test class that is not a Semmle class or a Juliet test suite class. */
class NonSecurityTestClass extends TestClass {
  NonSecurityTestClass() {
    not exists(RefType s | this.getASupertype*().getSourceDeclaration() = s and s.fromSource() |
      s.getLocation().getFile().getAbsolutePath().matches("%semmle%") or
      s.getLocation().getFile().getAbsolutePath().matches("%ql/java/ql/test/%") or
      s.getLocation().getFile().getAbsolutePath().matches("%CWE%")
    )
  }
}

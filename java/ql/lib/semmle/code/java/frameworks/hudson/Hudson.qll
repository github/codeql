/** Provides classes and predicates related to the Hudson framework. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.frameworks.stapler.Stapler
private import semmle.code.java.security.XSS

/** A method declared in a subtype of `hudson.model.Descriptor` that returns an `HttpResponse`. */
class HudsonWebMethod extends Method {
  HudsonWebMethod() {
    this.getReturnType().(RefType).getASourceSupertype*() instanceof HttpResponse and
    this.getDeclaringType().getASourceSupertype*().hasQualifiedName("hudson.model", "Descriptor")
  }
}

private class FilePathRead extends LocalUserInput {
  FilePathRead() {
    this.asExpr()
        .(MethodAccess)
        .getMethod()
        .hasQualifiedName("hudson", "FilePath",
          [
            "newInputStreamDenyingSymlinkAsNeeded", "openInputStream", "read", "readFromOffset",
            "readToString"
          ])
  }
}

private class HudsonUtilXssSanitizer extends XssSanitizer {
  HudsonUtilXssSanitizer() {
    this.asExpr()
        .(MethodAccess)
        .getMethod()
        // Not including xmlEscape because it only accounts for >, <, and &.
        // It does not account for ", or ', which makes it an incomplete XSS sanitizer.
        .hasQualifiedName("hudson", "Util", "escape")
  }
}

/** Provides classes and predicates for working with Android widgets. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources

private class EditableToStringStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodCall ma |
      ma.getMethod().hasName("toString") and
      ma.getReceiverType().getASourceSupertype*().hasQualifiedName("android.text", "Editable") and
      n1.asExpr() = ma.getQualifier() and
      n2.asExpr() = ma
      or
      ma.getMethod().hasQualifiedName("java.lang", "String", "valueOf") and
      ma.getArgument(0)
          .getType()
          .(RefType)
          .getASourceSupertype*()
          .hasQualifiedName("android.text", "Editable") and
      n1.asExpr() = ma.getArgument(0) and
      n2.asExpr() = ma
    )
  }
}

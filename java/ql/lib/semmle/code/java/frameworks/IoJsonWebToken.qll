/** Predicates and classes to reason about the `io.jsonwebtoken` library. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

private class JwsHeaderFieldsInheritTaint extends DataFlow::SyntheticFieldContent,
  TaintInheritingContent
{
  JwsHeaderFieldsInheritTaint() { this.getField().matches("io.jsonwebtoken.JwsHeader.%") }
}

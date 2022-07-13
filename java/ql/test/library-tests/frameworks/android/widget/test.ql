import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

query predicate valueOf(MethodAccess ma) {
  ma.getMethod().hasQualifiedName("java.lang", "String", "valueOf")
}

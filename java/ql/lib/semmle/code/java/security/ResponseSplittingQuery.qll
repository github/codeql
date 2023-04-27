/** Provides a taint tracking configuration to reason about response splitting vulnerabilities. */

import java
private import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ResponseSplitting

/**
 * A taint-tracking configuration for response splitting vulnerabilities.
 */
module ResponseSplittingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not source instanceof SafeHeaderSplittingSource
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof HeaderSplittingSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType
    or
    node.getType() instanceof BoxedType
    or
    exists(MethodAccess ma, string methodName, CompileTimeConstantExpr target |
      node.asExpr() = ma and
      ma.getMethod().hasQualifiedName("java.lang", "String", methodName) and
      target = ma.getArgument(0) and
      (
        methodName = "replace" and target.getIntValue() = [10, 13] // 10 == "\n", 13 == "\r"
        or
        methodName = "replaceAll" and
        target.getStringValue().regexpMatch(".*([\n\r]|\\[\\^[^\\]\r\n]*\\]).*")
      )
    )
  }
}

/**
 * Tracks flow from remote sources to response splitting vulnerabilities.
 */
module ResponseSplittingFlow = TaintTracking::Global<ResponseSplittingConfig>;

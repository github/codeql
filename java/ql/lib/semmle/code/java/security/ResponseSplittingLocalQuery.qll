/** Provides a taint-tracking configuration to reason about response splitting vulnerabilities from local user input. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.ResponseSplitting

/**
 * A taint-tracking configuration to reason about response splitting vulnerabilities from local user input.
 */
deprecated module ResponseSplittingLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof HeaderSplittingSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType
    or
    node.getType() instanceof BoxedType
    or
    exists(MethodCall ma, string methodName, CompileTimeConstantExpr target |
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
 * DEPRECATED: Use `ResponseSplittingFlow` instead and configure threat model sources to include `local`.
 *
 * Taint-tracking flow for response splitting vulnerabilities from local user input.
 */
deprecated module ResponseSplittingLocalFlow = TaintTracking::Global<ResponseSplittingLocalConfig>;

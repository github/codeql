/**
 * Provides a taint-tracking configuration for reasoning about javascript
 * evaluation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.UnsafeJsEvalExtensions

/**
 * A taint configuration from taint sources to sinks for this query.
 */
class UnsafeJsEvalConfig extends TaintTracking::Configuration {
  UnsafeJsEvalConfig() { this = "UnsafeJsEvalConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof Source }

  override predicate isSink(DataFlow::Node node) { node instanceof Sink }

  // TODO: convert to new taint flow models
  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(Argument arg |
      arg =
        any(CallExpr ce |
          ce.getStaticTarget().(MethodDecl).hasQualifiedName("String", "init(decoding:as:)")
        ).getArgument(0)
      or
      arg =
        any(CallExpr ce |
          ce.getStaticTarget()
              .(FreeFunctionDecl)
              .hasName([
                  "JSStringCreateWithUTF8CString(_:)", "JSStringCreateWithCharacters(_:_:)",
                  "JSStringRetain(_:)"
                ])
        ).getArgument(0)
    |
      nodeFrom.asExpr() = arg.getExpr() and
      nodeTo.asExpr() = arg.getApplyExpr()
    )
    or
    exists(CallExpr ce, Expr self, AbstractClosureExpr closure |
      ce.getStaticTarget()
          .getName()
          .matches(["withContiguousStorageIfAvailable(%)", "withUnsafeBufferPointer(%)"]) and
      self = ce.getQualifier() and
      ce.getArgument(0).getExpr() = closure
    |
      nodeFrom.asExpr() = self and
      nodeTo.(DataFlow::ParameterNode).getParameter() = closure.getParam(0)
    )
    or
    exists(MemberRefExpr e, Expr self, VarDecl member |
      self.getType().getName().matches(["Unsafe%Buffer%", "Unsafe%Pointer%"]) and
      member.getName() = "baseAddress"
    |
      e.getBase() = self and
      e.getMember() = member and
      nodeFrom.asExpr() = self and
      nodeTo.asExpr() = e
    )
  }
}

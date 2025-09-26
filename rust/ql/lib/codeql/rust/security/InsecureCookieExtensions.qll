/**
 * Provides classes and predicates for reasoning about insecure cookie
 * vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSource
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
private import codeql.rust.dataflow.internal.DataFlowImpl as DataFlowImpl
private import codeql.rust.dataflow.internal.Node
private import codeql.rust.controlflow.BasicBlocks

/**
 * Provides default sources, sinks and barriers for detecting insecure
 * cookie vulnerabilities, as well as extension points for adding your own.
 */
module InsecureCookie {
  /**
   * A data flow source for insecure cookie vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for insecure cookie vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "InsecureCookie" }
  }

  /**
   * A barrier for insecure cookie vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A source for insecure cookie vulnerabilities from model data.
   */
  private class ModelsAsDataSource extends Source {
    ModelsAsDataSource() { sourceNode(this, "cookie-create") }
  }

  /**
   * A sink for insecure cookie vulnerabilities from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "cookie-use") }
  }

  /**
   * Holds if a models-as-data optional barrier for cookies is specified for `summaryNode`,
   * with arguments `attrib` (`secure` or `partitioned`) and `arg` (argument index). For example,
   * if a summary has input:
   * ```
   * [..., Argument[self].OptionalBarrier[cookie-secure-arg0], ...]
   * ```
   * then `attrib` is `secure` and `arg` is `0`.
   *
   * The meaning here is that a call to the function summarized by `summaryNode` would set
   * the cookie attribute `attrib` to the value of argument `arg`. This may in practice be
   * interpretted as a barrier to flow (when the cookie is made secure) or as a source (when
   * the cookie is made insecure).
   */
  private predicate cookieOptionalBarrier(FlowSummaryNode summaryNode, string attrib, int arg) {
    exists(string barrierName |
      DataFlowImpl::optionalBarrier(summaryNode, barrierName) and
      attrib = barrierName.regexpCapture("cookie-(secure|partitioned)-arg([0-9]+)", 1) and
      arg = barrierName.regexpCapture("cookie-(secure|partitioned)-arg([0-9]+)", 2).toInt()
    )
  }

  /**
   * Holds if cookie attribute `attrib` (`secure` or `partitioned`) is set to `value`
   * (`true` or `false`) at `node`. For example, the call:
   * ```
   * cookie.secure(true)
   * ```
   * sets the `"secure"` attribute to `true`. A value that cannot be determined is treated
   * as `false`.
   */
  predicate cookieSetNode(DataFlow::Node node, string attrib, boolean value) {
    exists(FlowSummaryNode summaryNode, CallExprBase ce, int arg, DataFlow::Node argNode |
      // decode the models-as-data `OptionalBarrier`
      cookieOptionalBarrier(summaryNode, attrib, arg) and
      // find a call and arg referenced by this optional barrier
      ce.getStaticTarget() = summaryNode.getSummarizedCallable() and
      ce.getArg(arg) = argNode.asExpr().getExpr() and
      // check if the argument is always `true`
      (
        if
          forex(DataFlow::Node argSourceNode, BooleanLiteralExpr argSourceValue |
            DataFlow::localFlow(argSourceNode, argNode) and
            argSourceValue = argSourceNode.asExpr().getExpr()
          |
            argSourceValue.getTextValue() = "true"
          )
        then value = true // `true` flows to here
        else value = false // `false`, unknown, or multiple values
      ) and
      // and find the node where this happens (we can't just use the flow summary node, since its
      // shared across all calls to the modeled function, we need a node specific to this call)
      (
        node.asExpr().getExpr() = ce.(MethodCallExpr).getReceiver() // e.g. `a` in `a.set_secure(true)`
        or
        exists(BasicBlock bb, int i |
          // associated SSA node
          node.(SsaNode).asDefinition().definesAt(_, bb, i) and
          ce.(MethodCallExpr).getReceiver() = bb.getNode(i).getAstNode()
        )
      )
    )
  }
}

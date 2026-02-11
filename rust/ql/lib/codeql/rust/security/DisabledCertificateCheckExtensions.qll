/**
 * Provides classes and predicates for reasoning about disabled certificate
 * check vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
private import codeql.rust.dataflow.internal.Node as Node

/**
 * Provides default sinks for detecting disabled certificate check
 * vulnerabilities, as well as extension points for adding your own.
 */
module DisabledCertificateCheckExtensions {
  /**
   * A data flow sink for disabled certificate check vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "DisabledCertificateCheck" }
  }

  /**
   * A sink for disabled certificate check vulnerabilities from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "disable-certificate") }
  }

  /**
   * A heuristic sink for disabled certificate check vulnerabilities based on function names.
   */
  private class HeuristicSink extends Sink {
    HeuristicSink() {
      exists(Call call |
        call.getStaticTarget().getName().getText() =
          ["danger_accept_invalid_certs", "danger_accept_invalid_hostnames"] and
        call.getPositionalArgument(0) = this.asExpr() and
        // don't duplicate modeled sinks
        not exists(ModelsAsDataSink s | s.(Node::FlowSummaryNode).getSinkElement().getCall() = call)
      )
    }
  }
}

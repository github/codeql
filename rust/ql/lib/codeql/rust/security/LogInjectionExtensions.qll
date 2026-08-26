/**
 * Provides classes and predicates for reasoning about log injection
 * vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowBarrier
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
private import codeql.rust.security.Barriers as Barriers

/**
 * Provides default sources, sinks and barriers for detecting log injection
 * vulnerabilities, as well as extension points for adding your own.
 */
module LogInjection {
  /**
   * A data flow source for log injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for log injection vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "LogInjection" }
  }

  /**
   * A barrier for log injection vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A sink for log-injection from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "log-injection") }
  }

  /**
   * A sink for the logging macros of the `tracing` crate, such as
   * `tracing::info!`. The underlying function calls are difficult to
   * identify reliably, so we treat any expression inside the expansion
   * of such a macro call as a sink.
   */
  class TracingMacroSink extends Sink {
    TracingMacroSink() {
      exists(Crate c, MacroRules m, MacroCall mc |
        // `c` is a tracing macro of interest
        c.getName() = "tracing" and
        m.getName().getText() = ["event", "span"] and
        m.getLocation().getFile() = c.getASourceFile().getFile() and
        mc.resolveMacro() = m and
        this.asExpr().getParentNode*() = mc.getMacroCallExpansion()
      )
    }
  }

  /**
   * A barrier for log-injection from model data.
   */
  private class ModelsAsDataBarrier extends Barrier {
    ModelsAsDataBarrier() { barrierNode(this, "log-injection") }
  }

  /**
   * A barrier for log injection vulnerabilities for nodes whose type is a
   * numeric type, which is unlikely to expose any vulnerability.
   */
  private class NumericTypeBarrier extends Barrier instanceof Barriers::NumericTypeBarrier { }

  private class BooleanTypeBarrier extends Barrier instanceof Barriers::BooleanTypeBarrier { }

  private class FieldlessEnumTypeBarrier extends Barrier instanceof Barriers::FieldlessEnumTypeBarrier
  { }
}

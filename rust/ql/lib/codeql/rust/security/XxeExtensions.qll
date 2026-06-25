/**
 * Provides classes and predicates to reason about XML external entity (XXE)
 * vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowBarrier
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
private import codeql.rust.dataflow.internal.Node as Node

/**
 * Provides default sources, sinks and barriers for detecting XML external
 * entity (XXE) vulnerabilities, as well as extension points for adding your
 * own.
 */
module Xxe {
  /**
   * A data flow source for XXE vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for XXE vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "Xxe" }
  }

  /**
   * A barrier for XXE vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A sink for XXE from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() {
      exists(Call call |
        // an XML parse call
        sinkNode(this, "xxe") and
        call = this.(Node::FlowSummaryNode).getSinkElement().getCall() and
        // with an unsafe option
        hasXxeOption(call.getAnArgument(), _)
      )
    }
  }

  /**
   * A heuristic sink for XXE.
   */
  private class HeuristicSink extends Sink {
    HeuristicSink() {
      exists(Call call |
        // a call that looks it might do XML parsing (this is broad)
        call.getStaticTarget().getName().getText().regexpMatch("(?i).*(xml|parse).*") and
        // with an unsafe option; we require the option to be named (e.g. `XML_PARSE_NOENT`), not a literal value
        // (e.g. `2`), to provide additional confidence that we're actually looking at XML parsing)
        hasXxeOption(call.getAnArgument(), true) and
        // the sink is any input argument
        this.asExpr() = call.getAnArgument()
      )
    }
  }

  /**
   * A barrier for XXE vulnerabilities from model data.
   */
  private class ModelsAsDataBarrier extends Barrier {
    ModelsAsDataBarrier() { barrierNode(this, "xxe") }
  }
}

/**
 * Holds if `e` is an expression that includes an unsafe `xmlParserOption`,
 * specifically `XML_PARSE_NOENT` (value 2, enables entity substitution) or
 * `XML_PARSE_DTDLOAD` (value 4, loads external DTD subsets).
 *
 * `named` is true if the expression is a named constant, false if it is an
 * integer literal.
 */
private predicate hasXxeOption(Expr e, boolean named) {
  // named constant XML_PARSE_NOENT or XML_PARSE_DTDLOAD (or very similar)
  e.(PathExpr).getPath().getText().matches(["%_PARSE_NOENT", "%_PARSE_DTDLOAD"]) and
  named = true
  or
  // integer literal with XML_PARSE_NOENT (bit 1) or XML_PARSE_DTDLOAD (bit 2) set
  exists(string value |
    e.(IntegerLiteralExpr).getTextValue() = value + concat(e.(IntegerLiteralExpr).getSuffix()) and
    value.toInt().bitAnd(6) != 0 // 6 = 2 | 4 = XML_PARSE_NOENT | XML_PARSE_DTDLOAD
  ) and
  named = false
  or
  // bitwise OR expression
  hasXxeOption(e.(BinaryExpr).getLhs(), named)
  or
  hasXxeOption(e.(BinaryExpr).getRhs(), named)
  or
  // cast expression (e.g., `XML_PARSE_NOENT as i32`)
  hasXxeOption(e.(CastExpr).getExpr(), named)
}

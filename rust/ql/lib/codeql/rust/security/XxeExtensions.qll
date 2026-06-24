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
        hasXxeOption(call.getAnArgument())
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
 */
private predicate hasXxeOption(Expr e) {
  // Named constant XML_PARSE_NOENT or XML_PARSE_DTDLOAD
  e.(PathExpr).getPath().getText() =
    ["xmlParserOption_XML_PARSE_NOENT", "xmlParserOption_XML_PARSE_DTDLOAD"]
  or
  // Integer literal with XML_PARSE_NOENT (bit 1) or XML_PARSE_DTDLOAD (bit 2) set
  exists(int v |
    v = e.(IntegerLiteralExpr).getTextValue().regexpCapture("^([0-9]+).*$", 1).toInt()
  |
    v.bitAnd(6) != 0 // 6 = 2 | 4 = XML_PARSE_NOENT | XML_PARSE_DTDLOAD
  )
  or
  // Bitwise OR expression
  hasXxeOption(e.(BinaryExpr).getLhs())
  or
  hasXxeOption(e.(BinaryExpr).getRhs())
  or
  // Cast expression (e.g., `XML_PARSE_NOENT as i32`)
  hasXxeOption(e.(CastExpr).getExpr())
}

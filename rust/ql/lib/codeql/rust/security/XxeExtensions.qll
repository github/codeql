/**
 * Provides classes and predicates to reason about XML external entity (XXE)
 * vulnerabilities.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts

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
   * A libxml2 XML parsing call with unsafe parser options, considered as a
   * flow sink.
   */
  private class Libxml2XxeSink extends Sink {
    Libxml2XxeSink() {
      exists(Call call, int xmlArg, int optionsArg |
        libxml2ParseCall(call, xmlArg, optionsArg) and
        this.asExpr() = call.getPositionalArgument(xmlArg) and
        hasXxeOption(call.getPositionalArgument(optionsArg))
      )
    }
  }
}

/**
 * Holds if `call` is a call to a `libxml2` XML parsing function, where
 * `xmlArg` is the index of the XML content argument and `optionsArg` is the
 * index of the parser options argument.
 */
private predicate libxml2ParseCall(Call call, int xmlArg, int optionsArg) {
  exists(string fname | call.getStaticTarget().getName().getText() = fname |
    fname = "xmlCtxtUseOptions" and xmlArg = 0 and optionsArg = 1
    or
    fname = "xmlReadFile" and xmlArg = 0 and optionsArg = 2
    or
    fname = ["xmlReadDoc", "xmlReadFd"] and xmlArg = 0 and optionsArg = 3
    or
    fname = ["xmlCtxtReadFile", "xmlParseInNodeContext"] and xmlArg = 1 and optionsArg = 3
    or
    fname = ["xmlCtxtReadDoc", "xmlCtxtReadFd"] and xmlArg = 1 and optionsArg = 4
    or
    fname = "xmlReadMemory" and xmlArg = 0 and optionsArg = 4
    or
    fname = "xmlCtxtReadMemory" and xmlArg = 1 and optionsArg = 5
    or
    fname = "xmlReadIO" and xmlArg = 0 and optionsArg = 5
    or
    fname = "xmlCtxtReadIO" and xmlArg = 1 and optionsArg = 6
  )
}

/**
 * Holds if `e` is an expression that includes an unsafe `xmlParserOption`,
 * specifically `XML_PARSE_NOENT` (value 2, enables entity substitution) or
 * `XML_PARSE_DTDLOAD` (value 4, loads external DTD subsets).
 */
private predicate hasXxeOption(Expr e) {
  // Named constant XML_PARSE_NOENT or XML_PARSE_DTDLOAD
  e.(PathExpr).getPath().getText() = ["XML_PARSE_NOENT", "XML_PARSE_DTDLOAD"]
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

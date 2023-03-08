/**
 * Models the libxml2 XML library.
 */

import cpp
import XML
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * A call to a `libxml2` function that parses XML.
 */
class Libxml2ParseCall extends FunctionCall {
  int optionsArg;

  Libxml2ParseCall() {
    exists(string fname | this.getTarget().getName() = fname |
      fname = "xmlCtxtUseOptions" and optionsArg = 1
      or
      fname = "xmlReadFile" and optionsArg = 2
      or
      fname = ["xmlCtxtReadFile", "xmlParseInNodeContext", "xmlReadDoc", "xmlReadFd"] and
      optionsArg = 3
      or
      fname = ["xmlCtxtReadDoc", "xmlCtxtReadFd", "xmlReadMemory"] and optionsArg = 4
      or
      fname = ["xmlCtxtReadMemory", "xmlReadIO"] and optionsArg = 5
      or
      fname = "xmlCtxtReadIO" and optionsArg = 6
    )
  }

  /**
   * Gets the argument that specifies `xmlParserOption`s.
   */
  Expr getOptions() { result = this.getArgument(optionsArg) }
}

/**
 * An `xmlParserOption` for `libxml2` that is considered unsafe.
 */
class Libxml2BadOption extends EnumConstant {
  Libxml2BadOption() { this.getName() = ["XML_PARSE_NOENT", "XML_PARSE_DTDLOAD"] }
}

/**
 * The libxml2 XML library.
 */
class LibXml2Library extends XmlLibrary {
  LibXml2Library() { this = "LibXml2Library" }

  override predicate configurationSource(DataFlow::Node node, TXxeFlowState flowstate) {
    // source is an `options` argument on a libxml2 parse call that specifies
    // at least one unsafe option.
    //
    // note: we don't need to track an XML object for libxml2, so we don't
    // really need data flow. Nevertheless we jam it into this configuration,
    // with matching sources and sinks. This allows results to be presented by
    // the same query, in a consistent way as other results with flow paths.
    exists(Libxml2ParseCall call, Expr options |
      options = call.getOptions() and
      node.asExpr() = options and
      flowstate instanceof TLibXml2FlowState and
      exists(Libxml2BadOption opt |
        globalValueNumber(options).getAnExpr().getValue().toInt().bitAnd(opt.getValue().toInt()) !=
          0
      )
    )
  }

  override predicate configurationSink(DataFlow::Node node, TXxeFlowState flowstate) {
    // sink is the `options` argument on a `libxml2` parse call.
    exists(Libxml2ParseCall call, Expr options |
      options = call.getOptions() and
      node.asExpr() = options and
      flowstate instanceof TLibXml2FlowState
    )
  }
}

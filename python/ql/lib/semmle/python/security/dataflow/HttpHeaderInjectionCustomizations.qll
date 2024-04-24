/**
 * Provides default sources, sinks, and sanitizers for detecting
 * "HTTP Header injection" vulnerabilities, as well as extension
 * points for adding your own.
 */

import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Provides default sources, sinks, and sanitizers for detecting
 * "HTTP Header injection" vulnerabilities, as well as extension
 * points for adding your own.
 */
module HttpHeaderInjection {
  /**
   * A data flow source for "HTTP Header injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "HTTP Header injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A data flow sanitizer for "HTTP Header injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A HTTP header write, considered as a flow sink.
   */
  class HeaderWriteAsSink extends Sink {
    HeaderWriteAsSink() {
      exists(Http::Server::ResponseHeaderWrite headerWrite |
        headerWrite.nameAllowsNewline() and
        this = headerWrite.getNameArg()
        or
        headerWrite.valueAllowsNewline() and
        this = headerWrite.getValueArg()
      )
    }
  }

  /** A key-value pair in a literal for a bulk header update, considered as a single header update. */
  // TODO: We could instead consider bulk writes as sinks with an implicit read step of DictionaryKey/DictionaryValue content as needed.
  private class HeaderBulkWriteDictLiteral extends Http::Server::ResponseHeaderWrite::Range instanceof Http::Server::ResponseHeaderBulkWrite
  {
    KeyValuePair item;

    HeaderBulkWriteDictLiteral() {
      exists(Dict dict | DataFlow::localFlow(DataFlow::exprNode(dict), super.getBulkArg()) |
        item = dict.getAnItem()
      )
    }

    override DataFlow::Node getNameArg() { result.asExpr() = item.getKey() }

    override DataFlow::Node getValueArg() { result.asExpr() = item.getValue() }

    override predicate nameAllowsNewline() {
      Http::Server::ResponseHeaderBulkWrite.super.nameAllowsNewline()
    }

    override predicate valueAllowsNewline() {
      Http::Server::ResponseHeaderBulkWrite.super.valueAllowsNewline()
    }
  }

  /** A tuple in a list for a bulk header update, considered as a single header update. */
  // TODO: We could instead consider bulk writes as sinks with implicit read steps as needed.
  private class HeaderBulkWriteListLiteral extends Http::Server::ResponseHeaderWrite::Range instanceof Http::Server::ResponseHeaderBulkWrite
  {
    Tuple item;

    HeaderBulkWriteListLiteral() {
      exists(List list | DataFlow::localFlow(DataFlow::exprNode(list), super.getBulkArg()) |
        item = list.getAnElt()
      )
    }

    override DataFlow::Node getNameArg() { result.asExpr() = item.getElt(0) }

    override DataFlow::Node getValueArg() { result.asExpr() = item.getElt(1) }

    override predicate nameAllowsNewline() {
      Http::Server::ResponseHeaderBulkWrite.super.nameAllowsNewline()
    }

    override predicate valueAllowsNewline() {
      Http::Server::ResponseHeaderBulkWrite.super.valueAllowsNewline()
    }
  }

  /**
   * A call to replace line breaks, considered as a sanitizer.
   */
  class ReplaceLineBreaksSanitizer extends Sanitizer, DataFlow::CallCfgNode {
    ReplaceLineBreaksSanitizer() {
      this.getFunction().(DataFlow::AttrRead).getAttributeName() = "replace" and
      this.getArg(0).asExpr().(StringLiteral).getText() = "\n"
    }
  }
}

/**
 * Provides a model of `cheerio`, a server-side DOM manipulation library with a jQuery-like API.
 */

import javascript
private import semmle.javascript.security.dataflow.Xss as Xss

module Cheerio {
  /** Gets a reference to the `cheerio` function, possibly with a loaded DOM. */
  private API::Node cheerioApi() {
    result = API::moduleImport("cheerio")
    or
    result = cheerioApi().getMember(["load", "parseHTML"]).getReturn()
  }

  /** Gets a reference to the `cheerio` function, possibly with a loaded DOM. */
  DataFlow::SourceNode cheerioRef() { result = cheerioApi().getAUse() }

  /**
   * A creation of `cheerio` object, a collection of virtual DOM elements
   * with an interface similar to that of a jQuery object.
   */
  class CheerioObjectCreation extends DataFlow::SourceNode instanceof CheerioObjectCreation::Range {
  }

  module CheerioObjectCreation {
    /**
     * The creation of a `cheerio` object.
     */
    abstract class Range extends DataFlow::SourceNode { }

    private class DefaultRange extends Range {
      DefaultRange() {
        this = cheerioApi().getACall()
        or
        this = cheerioApi().getAMember().getACall()
      }
    }
  }

  /**
   * Gets a reference to a `cheerio` object, a collection of virtual DOM elements
   * with an interface similar to jQuery objects.
   */
  private DataFlow::SourceNode cheerioObjectRef(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof CheerioObjectCreation
    or
    // Chainable calls.
    t.start() and
    exists(DataFlow::MethodCallNode call, string name |
      call = cheerioObjectRef().getAMethodCall(name) and
      result = call
    |
      if name = ["attr", "data", "prop", "css"]
      then call.getNumArgument() = 2
      else
        if name = ["val", "html", "text"]
        then call.getNumArgument() = 1
        else (
          name != "toString" and
          name != "toArray" and
          name != "hasClass"
        )
    )
    or
    exists(DataFlow::TypeTracker t2 | result = cheerioObjectRef(t2).track(t2, t))
  }

  /**
   * Gets a reference to a `cheerio` object, a collection of virtual DOM elements
   * with an interface similar to jQuery objects.
   */
  DataFlow::SourceNode cheerioObjectRef() {
    result = cheerioObjectRef(DataFlow::TypeTracker::end())
  }

  /**
   * A definition of a DOM attribute through `cheerio`.
   */
  class AttributeDef extends DOM::AttributeDefinition {
    DataFlow::CallNode call;

    AttributeDef() {
      this = call.asExpr() and
      call = cheerioObjectRef().getAMethodCall("attr") and
      call.getNumArgument() >= 2
    }

    override string getName() { call.getArgument(0).mayHaveStringValue(result) }

    override DataFlow::Node getValueNode() { result = call.getArgument(1) }
  }

  /**
   * An XSS sink through `cheerio`.
   */
  class XssSink extends Xss::DomBasedXss::Sink {
    XssSink() {
      exists(string name | this = cheerioObjectRef().getAMethodCall(name).getAnArgument() |
        JQuery::isMethodArgumentInterpretedAsHtml(name)
      )
    }
  }
}

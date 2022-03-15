/**
 * Provides classes for working with jQuery code.
 */

import javascript

/**
 * Gets a data flow node that may refer to the jQuery `$` function.
 */
predicate jquery = JQuery::dollar/0;

/**
 * An internal version of `JQueryObject` that may be used to retain
 * backwards compatibility without triggering a deprecation warning.
 */
abstract private class JQueryObjectInternal extends Expr { }

/**
 * A jQuery object created from a jQuery method.
 *
 * This class is defined using the legacy API in order to retain the
 * behavior of `JQueryObject`.
 */
private class OrdinaryJQueryObject extends JQueryObjectInternal {
  OrdinaryJQueryObject() {
    exists(JQuery::MethodCall jq |
      this.flow().getALocalSource() = jq and
      returnsAJQueryObject(jq, jq.getMethodName())
    )
  }
}

/**
 * Holds if the jQuery method call `call`, with name `methodName`, returns a JQuery object.
 *
 * The `call` parameter has type `DataFlow::CallNode` instead of `JQuery::MethodCall` to avoid non-monotonic recursion.
 * The not is placed inside the predicate to avoid non-monotonic recursion.
 */
bindingset[methodName, call]
private predicate returnsAJQueryObject(DataFlow::CallNode call, string methodName) {
  not (
    neverReturnsJQuery(methodName)
    or
    methodName = "val" and call.getNumArgument() = 0 // `jQuery.val()`
    or
    methodName = ["html", "text"] and call.getNumArgument() = 0 // `jQuery.html()`/`jQuery.text()`
    or
    // `jQuery.attr(key)`/`jQuery.prop(key)`
    methodName = ["attr", "prop"] and
    call.getNumArgument() = 1 and
    call.getArgument(0).mayHaveStringValue(_)
  )
}

/**
 * Holds if a jQuery method named `name` never returns a JQuery object.
 */
private predicate neverReturnsJQuery(string name) {
  forex(ExternalMemberDecl decl |
    decl.getBaseName() = "jQuery" and
    decl.getName() = name
  |
    not decl.getDocumentation()
        .getATagByTitle("return")
        .getType()
        .getAnUnderlyingType()
        .hasQualifiedName("jQuery")
  )
}

/**
 * A call to `jQuery.parseXML`.
 */
private class JQueryParseXmlCall extends XML::ParserInvocation {
  JQueryParseXmlCall() { this.flow().(JQuery::MethodCall).getMethodName() = "parseXML" }

  override Expr getSourceArgument() { result = this.getArgument(0) }

  override predicate resolvesEntities(XML::EntityKind kind) { kind = XML::InternalEntity() }
}

/**
 * A call to `$(...)` that constructs a wrapped DOM element, such as `$("<div/>")`.
 */
private class JQueryDomElementDefinition extends DOM::ElementDefinition, @call_expr {
  string tagName;
  CallExpr call;

  JQueryDomElementDefinition() {
    this = call and
    call = jquery().getACall().asExpr() and
    exists(string s | s = call.getArgument(0).getStringValue() |
      // match an opening angle bracket followed by a tag name, followed by arbitrary
      // text and a closing angle bracket, potentially with whitespace in between
      tagName = s.regexpCapture("\\s*<\\s*(\\w+)\\b[^>]*>\\s*", 1).toLowerCase()
    )
  }

  override string getName() { result = tagName }

  /**
   * Gets a data flow node specifying the attributes of the constructed DOM element.
   *
   * For example, in `$("<a/>", { href: "https://semmle.com" })` the second argument
   * specifies the attributes of the new `<a>` element.
   */
  DataFlow::SourceNode getAttributes() { result.flowsToExpr(call.getArgument(1)) }

  override DOM::ElementDefinition getParent() { none() }
}

/**
 * An attribute defined using jQuery APIs.
 */
abstract private class JQueryAttributeDefinition extends DOM::AttributeDefinition { }

/**
 * An attribute definition supplied when constructing a DOM element using `$(...)`.
 *
 * For example, in `$("<script/>", { src: mySource })`, the property `src : mySource`
 * defines an attribute of the newly constructed `<script>` element.
 */
private class JQueryAttributeDefinitionInElement extends JQueryAttributeDefinition {
  JQueryDomElementDefinition elt;
  DataFlow::PropWrite pwn;

  JQueryAttributeDefinitionInElement() {
    this = pwn.getAstNode() and
    elt.getAttributes().flowsTo(pwn.getBase())
  }

  override string getName() { result = pwn.getPropertyName() }

  override DataFlow::Node getValueNode() { result = pwn.getRhs() }

  override DOM::ElementDefinition getElement() { result = elt }
}

/** Gets the `attr` or `prop` string. */
private string attrOrProp() { result = "attr" or result = "prop" }

/**
 * An attribute definition using `elt.attr(name, value)` or `elt.prop(name, value)`
 * where `elt` is a wrapped set.
 */
private class JQueryAttr2Call extends JQueryAttributeDefinition, @call_expr {
  JQueryAttr2Call() {
    exists(DataFlow::MethodCallNode call | this = call.asExpr() |
      call = JQuery::objectRef().getAMethodCall(attrOrProp()) and
      call.getNumArgument() = 2
    )
  }

  override string getName() { result = this.(CallExpr).getArgument(0).getStringValue() }

  override DataFlow::Node getValueNode() {
    result = DataFlow::valueNode(this.(CallExpr).getArgument(1))
  }

  override DOM::ElementDefinition getElement() {
    exists(DataFlow::MethodCallNode call | this = call.asExpr() |
      result = call.getReceiver().getALocalSource().asExpr().(DOM::Element).getDefinition()
    )
  }
}

/**
 * Holds if `mce` is a call to `elt.attr(attributes)` or `elt.prop(attributes)`.
 */
private predicate bulkAttributeInit(DataFlow::MethodCallNode mce, DataFlow::SourceNode attributes) {
  mce = JQuery::objectRef().getAMethodCall(attrOrProp()) and
  mce.getNumArgument() = 1 and
  attributes.flowsTo(mce.getArgument(0))
}

/**
 * A property stored on an object flowing to `elt.attr(attributes)` or `elt.prop(attributes)`
 * where `elt` is a wrapped set.
 *
 * To avoid spurious combinations of `getName()` and `getValueNode()`,
 * this class is tied to an individual property write, as opposed to the call itself.
 */
private class JQueryBulkAttributeProp extends JQueryAttributeDefinition {
  DataFlow::PropWrite pwn;

  JQueryBulkAttributeProp() {
    exists(DataFlow::SourceNode attributes |
      bulkAttributeInit(_, attributes) and
      pwn = attributes.getAPropertyWrite() and
      this = pwn.getAstNode()
    )
  }

  override string getName() { result = pwn.getPropertyName() }

  override DataFlow::Node getValueNode() { result = pwn.getRhs() }

  override DOM::ElementDefinition getElement() {
    exists(DataFlow::MethodCallNode mce |
      bulkAttributeInit(mce, pwn.getBase().getALocalSource()) and
      result = mce.getReceiver().asExpr().(DOM::Element).getDefinition()
    )
  }
}

/**
 * An attribute definition using `jQuery.attr(elt, name, value)` or `jQuery.prop(elt, name, value)`
 * where `elt` is a wrapped set or a plain DOM element.
 */
private class JQueryAttr3Call extends JQueryAttributeDefinition, @call_expr {
  MethodCallExpr mce;

  JQueryAttr3Call() {
    this = mce and
    mce = jquery().getAMemberCall(attrOrProp()).asExpr() and
    mce.getNumArgument() = 3
  }

  override string getName() { result = this.(CallExpr).getArgument(1).getStringValue() }

  override DataFlow::Node getValueNode() {
    result = DataFlow::valueNode(this.(CallExpr).getArgument(2))
  }

  override DOM::ElementDefinition getElement() {
    result = mce.getArgument(0).(DOM::Element).getDefinition()
  }
}

/**
 * A DOM element returned from a chained jQuery call.
 *
 * For example, the call `$("<script/>").attr("src", mySource)` returns
 * the DOM element constructed by `$("<script/>")`.
 */
private class JQueryChainedElement extends DOM::Element, InvokeExpr {
  JQueryChainedElement() {
    exists(JQuery::MethodCall call, DOM::Element inner | this = call.asExpr() |
      call.getReceiver().asExpr() = inner and
      defn = inner.getDefinition()
    )
  }
}

/**
 * Classes and predicates for modeling `ClientRequest`s in JQuery.
 */
private module JQueryClientRequest {
  /**
   * A model of a URL request made using the `jQuery.ajax`.
   */
  private class JQueryAjaxCall extends ClientRequest::Range {
    JQueryAjaxCall() { this = jquery().getAMemberCall("ajax") }

    override DataFlow::Node getUrl() {
      result = this.getArgument(0) and not exists(this.getOptionArgument(0, _))
      or
      result = this.getOptionArgument([0 .. 1], "url")
    }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { result = this.getOptionArgument([0 .. 1], "data") }

    private string getResponseType() {
      this.getOptionArgument([0 .. 1], "dataType").mayHaveStringValue(result)
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      (
        responseType = this.getResponseType()
        or
        not exists(this.getResponseType()) and responseType = ""
      ) and
      promise = false and
      (
        result =
          this.getOptionArgument([0 .. 1], "success")
              .getALocalSource()
              .(DataFlow::FunctionNode)
              .getParameter(0)
        or
        result =
          getAResponseNodeFromAnXHRObject(this.getOptionArgument([0 .. 1],
              any(string method | method = "error" or method = "complete"))
                .getALocalSource()
                .(DataFlow::FunctionNode)
                .getParameter(0))
        or
        result = getAnAjaxCallbackDataNode(this)
      )
    }
  }

  /**
   * Gets a response data node from a call to a method on jqXHR Object `request`.
   */
  private DataFlow::Node getAnAjaxCallbackDataNode(ClientRequest::Range request) {
    result =
      request
          .getAMemberCall(any(string s | s = "done" or s = "then"))
          .getCallback(0)
          .getParameter(0)
    or
    result =
      getAResponseNodeFromAnXHRObject(request.getAMemberCall("fail").getCallback(0).getParameter(0))
  }

  /**
   * Gets a node refering to the response contained in an `jqXHR` object.
   */
  private DataFlow::SourceNode getAResponseNodeFromAnXHRObject(DataFlow::SourceNode obj) {
    result =
      obj.getAPropertyRead(any(string s |
          s = "responseText" or
          s = "responseXML"
        ))
  }

  /**
   * A model of a URL request made using a `jQuery.ajax` shorthand.
   * E.g. `jQuery.getJSON`, `jQuery.post` etc.
   * See: https://api.jquery.com/category/ajax/shorthand-methods/.
   *
   * Models the following method signatures:
   * - `jQuery.get( url [, data ] [, success ] [, dataType ] )`
   * - `jQuery.getJSON( url [, data ] [, success ] )`
   * - `jQuery.getScript( url [, success ] )`
   * - `jQuery.post( url [, data ] [, success ] [, dataType ] )`
   * - `.load( url [, data ] [, complete ] )`
   */
  private class JQueryAjaxShortHand extends ClientRequest::Range {
    string name;

    JQueryAjaxShortHand() {
      name = ["get", "getJSON", "getScript", "post"] and
      this = jquery().getAMemberCall(name)
      or
      name = "load" and
      this = JQuery::objectRef().getAMethodCall(name)
    }

    override DataFlow::Node getUrl() { result = this.getArgument(0) }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() {
      result = this.getArgument(1) and
      not name = "getScript" and // doesn't have a data-node.
      not result.getALocalSource() instanceof DataFlow::FunctionNode // looks like the success callback.
    }

    private string getResponseType() {
      (name = "get" or name = "post") and
      this.getLastArgument().mayHaveStringValue(result) and
      this.getNumArgument() > 1
      or
      name = "getJSON" and result = "json"
      or
      (name = "getScript" or name = "load") and
      result = "text"
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      (
        responseType = this.getResponseType()
        or
        not exists(this.getResponseType()) and responseType = ""
      ) and
      promise = false and
      (
        // one of the two last arguments
        result =
          this.getCallback([this.getNumArgument() - 2 .. this.getNumArgument() - 1]).getParameter(0)
        or
        result = getAnAjaxCallbackDataNode(this)
      )
    }
  }
}

module JQuery {
  /**
   * Holds if method `name` on a jQuery object may interpret any of its
   * arguments as HTML.
   */
  predicate isMethodArgumentInterpretedAsHtml(string name) {
    name =
      [
        "after", "append", "wrap", "wrapAll", "wrapInner", "appendTo", "before", "html",
        "insertAfter", "insertBefore", "prepend", "prependTo", "replaceWith"
      ]
  }

  /**
   * Holds if method `name` on a jQuery object may interpret any of its
   * arguments as a selector.
   */
  predicate isMethodArgumentInterpretedAsSelector(string name) {
    name = ["appendTo", "insertAfter", "insertBefore", "prependTo", "wrap", "wrapAll", "wrapInner"]
  }

  module DollarSource {
    /** A data flow node that may refer to the jQuery `$` function. */
    abstract class Range extends DataFlow::Node { }

    private class DefaultRange extends Range {
      DefaultRange() {
        // either a reference to a global variable `$` or `jQuery`
        this = DataFlow::globalVarRef(any(string jq | jq = "$" or jq = "jQuery"))
        or
        // or imported from a module named `jquery` or `zepto`
        this = DataFlow::moduleImport(["jquery", "zepto"])
        or
        this.hasUnderlyingType("JQueryStatic")
      }
    }
  }

  /**
   * Gets a data flow node that may refer to the jQuery `$` function.
   *
   * This predicate can be extended by subclassing `JQuery::DollarSource::Range`.
   */
  DataFlow::SourceNode dollarSource() { result instanceof DollarSource::Range }

  /** Gets a data flow node referring to the jQuery `$` function. */
  private DataFlow::SourceNode dollar(DataFlow::TypeTracker t) {
    t.start() and
    result = dollarSource()
    or
    exists(DataFlow::TypeTracker t2 | result = dollar(t2).track(t2, t))
  }

  /**
   * Gets a data flow node referring to the jQuery `$` function.
   *
   * This predicate can be extended by subclassing `JQuery::DollarSource::Range`.
   */
  DataFlow::SourceNode dollar() { result = dollar(DataFlow::TypeTracker::end()) }

  /** Gets an invocation of the jQuery `$` function. */
  DataFlow::CallNode dollarCall() { result = dollar().getACall() }

  /** A call to the jQuery `$` function. */
  class DollarCall extends DataFlow::CallNode {
    DollarCall() { this = dollarCall() }
  }

  module ObjectSource {
    /**
     * A data flow node that should be considered a source of jQuery objects.
     */
    abstract class Range extends DataFlow::Node { }

    private class DefaultRange extends Range {
      DefaultRange() {
        this.asExpr() instanceof JQueryObjectInternal
        or
        this.hasUnderlyingType("JQuery")
        or
        this.hasUnderlyingType("jQuery")
      }
    }

    /**
     * A `this` node in a JQuery plugin function, which is a JQuery object.
     */
    private class JQueryPluginThisObject extends Range {
      JQueryPluginThisObject() {
        this = DataFlow::thisNode(any(JQueryPluginMethod method).getFunction())
      }
    }
  }

  /** Gets a source of jQuery objects from the AST-based `JQueryObject` class. */
  private DataFlow::SourceNode legacyObjectSource() {
    result = any(JQueryObjectInternal e).flow().getALocalSource()
  }

  /** Gets a source of jQuery objects. */
  private DataFlow::SourceNode objectSource(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof ObjectSource::Range
    or
    t.start() and
    result = legacyObjectSource()
  }

  /** Gets a data flow node referring to a jQuery object. */
  private DataFlow::SourceNode objectRef(DataFlow::TypeTracker t) {
    result = objectSource(t)
    or
    exists(DataFlow::TypeTracker t2 | result = objectRef(t2).track(t2, t))
  }

  /**
   * Gets a data flow node referring to a jQuery object.
   *
   * This predicate can be extended by subclassing `JQuery::ObjectSource::Range`.
   */
  DataFlow::SourceNode objectRef() { result = objectRef(DataFlow::TypeTracker::end()) }

  /** A data flow node that refers to a jQuery object. */
  class Object extends DataFlow::SourceNode {
    Object() { this = objectRef() }
  }

  /** A call to a method on a jQuery object or the jQuery dollar function. */
  class MethodCall extends DataFlow::CallNode {
    string name;

    MethodCall() {
      this = dollarCall() and name = "$"
      or
      this = ([dollar(), objectRef()]).getAMemberCall(name)
      or
      // Handle basic dynamic method dispatch (e.g. `$element[html ? 'html' : 'text'](content)`)
      exists(DataFlow::PropRead read | read = this.getCalleeNode() |
        read.getBase().getALocalSource() = [dollar(), objectRef()] and
        read.mayHavePropertyName(name)
      )
    }

    /**
     * Gets the name of the jQuery method this call invokes.
     */
    string getMethodName() { result = name }

    /**
     * Holds if `node` is an argument that this method may interpret as HTML.
     *
     * Note that some jQuery methods decide whether to interpret an argument
     * as HTML based on its syntactic shape, so this predicate and
     * `interpretsArgumentAsSelector` below overlap.
     */
    predicate interpretsArgumentAsHtml(DataFlow::Node node) {
      // some methods interpret all their arguments as (potential) HTML
      JQuery::isMethodArgumentInterpretedAsHtml(name) and
      node = this.getAnArgument()
      or
      // for `$, it's only the first one
      name = "$" and
      node = this.getArgument(0)
    }

    /**
     * Holds if `node` is an argument that this method may interpret as a selector.
     *
     * Note that some jQuery methods decide whether to interpret an argument
     * as a selector based on its syntactic shape, so this predicate and
     * `interpretsArgumentAsHtml` above overlap.
     */
    predicate interpretsArgumentAsSelector(DataFlow::Node node) {
      // some methods interpret all their arguments as (potential) selectors
      JQuery::isMethodArgumentInterpretedAsSelector(name) and
      node = this.getAnArgument()
      or
      // for `$, it's only the first one
      name = "$" and
      node = this.getArgument(0)
    }
  }

  /**
   * Holds for jQuery plugin definitions of the form `$.fn.<pluginName> = <plugin>` or `$.extend($.fn, {<pluginName>, <plugin>})`.
   */
  private predicate jQueryPluginDefinition(string pluginName, DataFlow::Node plugin) {
    exists(DataFlow::PropRead fn, DataFlow::PropWrite write |
      fn = jquery().getAPropertyRead("fn") and
      (
        write = fn.getAPropertyWrite()
        or
        exists(ExtendCall extend, DataFlow::SourceNode source |
          fn.flowsTo(extend.getDestinationOperand()) and
          source = extend.getASourceOperand() and
          write = source.getAPropertyWrite()
        )
      ) and
      plugin = write.getRhs() and
      write.mayHavePropertyName(pluginName)
    )
  }

  /**
   * Gets a node that is registered as a jQuery plugin method at `def`.
   */
  private DataFlow::SourceNode getAJQueryPluginMethod(
    DataFlow::TypeBackTracker t, DataFlow::Node def
  ) {
    t.start() and jQueryPluginDefinition(_, def) and result.flowsTo(def)
    or
    exists(DataFlow::TypeBackTracker t2 | result = getAJQueryPluginMethod(t2, def).backtrack(t2, t))
  }

  /**
   * Gets a function that is registered as a jQuery plugin method at `def`.
   */
  private DataFlow::FunctionNode getAJQueryPluginMethod(DataFlow::Node def) {
    result = getAJQueryPluginMethod(DataFlow::TypeBackTracker::end(), def)
  }

  /**
   * A function that is registered as a jQuery plugin method.
   */
  class JQueryPluginMethod extends DataFlow::FunctionNode {
    string pluginName;

    JQueryPluginMethod() {
      exists(DataFlow::Node def |
        jQueryPluginDefinition(pluginName, def) and
        this = getAJQueryPluginMethod(def)
      )
    }

    /**
     * Gets the name of this plugin.
     */
    string getPluginName() { result = pluginName }
  }
}

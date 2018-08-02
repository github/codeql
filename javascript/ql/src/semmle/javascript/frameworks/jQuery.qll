/**
 * Provides classes for working with jQuery code.
 */

import javascript

/**
 * Gets a data flow node that may refer to the jQuery `$` function.
 */
DataFlow::SourceNode jquery() {
  // either a reference to a global variable `$` or `jQuery`
  result = DataFlow::globalVarRef(any(string jq | jq = "$" or jq = "jQuery"))
  or
  // or imported from a module named `jquery`
  result = DataFlow::moduleImport("jquery")
}

/**
 * An expression that may refer to a jQuery object.
 *
 * Note that this class is an over-approximation: `nd instanceof JQueryObject`
 * may hold for nodes `nd` that cannot, in fact, refer to a jQuery object.
 */
abstract class JQueryObject extends Expr {

}

/**
 * A jQuery object created from a jQuery method.
 */
private class OrdinaryJQueryObject extends JQueryObject {
  OrdinaryJQueryObject() {
    exists (JQueryMethodCall jq |
      this.flow().getALocalSource().asExpr() = jq and
      // `jQuery.val()` does _not_ return a jQuery object
      jq.getMethodName() != "val"
    )
  }
}

/**
 * A (possibly chained) call to a jQuery method.
 */
class JQueryMethodCall extends CallExpr {
  string name;

  JQueryMethodCall() {
    this = jquery().getACall().asExpr() and name = "$"
    or
    // initial call
    this = jquery().getAMemberCall(name).asExpr() or
    // chained call
    this.(MethodCallExpr).calls(any(JQueryObject jq), name)
  }

  /**
   * Gets the name of the jQuery method this call invokes.
   */
  string getMethodName() {
    result = name
  }

  /**
   * DEPRECATED: Use `interpretsArgumentAsHtml` instead.
   *
   * Holds if this call interprets its arguments as HTML.
   */
  deprecated
  predicate interpretsArgumentsAsHtml() {
    name = "addClass" or
    name = "after" or
    name = "append" or
    name = "appendTo" or
    name = "before" or
    name = "html" or
    name = "insertAfter" or
    name = "insertBefore" or
    name = "parseHTML" or
    name = "prepend" or
    name = "prependTo" or
    name = "prop" or
    name = "replaceWith" or
    name = "wrap" or
    name = "wrapAll" or
    name = "wrapInner"
  }

  /**
   * Holds if `e` is an argument that this method may interpret as HTML.
   *
   * Note that some jQuery methods decide whether to interpret an argument
   * as HTML based on its syntactic shape, so this predicate and
   * `interpretsArgumentAsSelector` below overlap.
   */
  predicate interpretsArgumentAsHtml(Expr e) {
    // some methods interpret all their arguments as (potential) HTML
    (
     name = "after" or
     name = "append" or
     name = "appendTo" or
     name = "before" or
     name = "html" or
     name = "insertAfter" or
     name = "insertBefore" or
     name = "prepend" or
     name = "prependTo" or
     name = "replaceWith" or
     name = "wrap" or
     name = "wrapAll" or
     name = "wrapInner"
    ) and
    e = getAnArgument()
    or
    // for `$, it's only the first one
    name = "$" and
    e = getArgument(0)
  }

  /**
   * Holds if `e` is an argument that this method may interpret as a selector.
   *
   * Note that some jQuery methods decide whether to interpret an argument
   * as a selector based on its syntactic shape, so this predicate and
   * `interpretsArgumentAsHtml` above overlap.
   */
  predicate interpretsArgumentAsSelector(Expr e) {
    // some methods interpret all their arguments as (potential) selectors
    (
     name = "appendTo" or
     name = "insertAfter" or
     name = "insertBefore" or
     name = "prependTo" or
     name = "wrap" or
     name = "wrapAll" or
     name = "wrapInner"
    ) and
    e = getAnArgument()
    or
    // for `$, it's only the first one
    name = "$" and
    e = getArgument(0)
  }
}

/**
 * A call to `jQuery.parseXML`.
 */
private class JQueryParseXmlCall extends XML::ParserInvocation {
  JQueryParseXmlCall() {
    this.(JQueryMethodCall).getMethodName() = "parseXML"
  }

  override Expr getSourceArgument() {
    result = getArgument(0)
  }

  override predicate resolvesEntities(XML::EntityKind kind) {
    kind = XML::InternalEntity()
  }
}

/**
 * A call to `$(...)` that constructs a wrapped DOM element, such as `$("<div/>")`.
 */
private class JQueryDomElementDefinition extends DOM::ElementDefinition, @callexpr {
  string tagName;
  CallExpr call;

  JQueryDomElementDefinition() {
    this = call and
    call = jquery().getACall().asExpr() and
    exists (string s | s = call.getArgument(0).(Expr).getStringValue() |
      // match an opening angle bracket followed by a tag name, followed by arbitrary
      // text and a closing angle bracket, potentially with whitespace in between
      tagName = s.regexpCapture("\\s*<\\s*(\\w+)\\b[^>]*>\\s*", 1).toLowerCase()
    )
  }

  override string getName() {
    result = tagName
  }

  /**
   * Gets a data flow node specifying the attributes of the constructed DOM element.
   *
   * For example, in `$("<a/>", { href: "https://semmle.com" })` the second argument
   * specifies the attributes of the new `<a>` element.
   */
  DataFlow::SourceNode getAttributes() {
    result.flowsToExpr(call.getArgument(1))
  }

  override DOM::ElementDefinition getParent() { none() }
}

/**
 * An attribute defined using jQuery APIs.
 */
private abstract class JQueryAttributeDefinition extends DOM::AttributeDefinition {
}

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

  override string getName() {
    result = pwn.getPropertyName()
  }

  override DataFlow::Node getValueNode() {
    result = pwn.getRhs()
  }

  override DOM::ElementDefinition getElement() {
    result = elt
  }
}

/**
 * An attribute definition using `elt.attr(name, value)` or `elt.prop(name, value)`
 * where `elt` is a wrapped set.
 */
private class JQueryAttr2Call extends JQueryAttributeDefinition, @callexpr {
  JQueryDomElementDefinition elt;

  JQueryAttr2Call() {
    exists (MethodCallExpr mce | this = mce |
      mce.getReceiver().(DOM::Element).getDefinition() = elt and
      (mce.getMethodName() = "attr" or mce.getMethodName() = "prop") and
      mce.getNumArgument() = 2
    )
  }

  override string getName() {
    result = this.(CallExpr).getArgument(0).getStringValue()
  }

  override DataFlow::Node getValueNode() {
    result = DataFlow::valueNode(this.(CallExpr).getArgument(1))
  }

  override DOM::ElementDefinition getElement() {
    result = elt
  }
}

/**
 * Holds if `mce` is a call to `elt.attr(attributes)` or `elt.prop(attributes)`.
 */
private predicate bulkAttributeInit(MethodCallExpr mce, JQueryDomElementDefinition elt,
                                    DataFlow::SourceNode attributes) {
  mce.getReceiver().(DOM::Element).getDefinition() = elt and
  (mce.getMethodName() = "attr" or mce.getMethodName() = "prop") and
  mce.getNumArgument() = 1 and
  attributes.flowsToExpr(mce.getArgument(0))
}

/**
 * An attribute definition using `elt.attr(attributes)` or `elt.prop(attributes)`
 * where `elt` is a wrapped set and `attributes` is an object of attribute-value pairs
 * to set.
 */
private class JQueryAttrCall extends JQueryAttributeDefinition, @callexpr {
  JQueryDomElementDefinition elt;
  DataFlow::PropWrite pwn;

  JQueryAttrCall() {
    exists (DataFlow::SourceNode attributes |
      bulkAttributeInit(this, elt, attributes) and
      attributes.flowsTo(pwn.getBase())
    )
  }

  override string getName() {
    result = pwn.getPropertyName()
  }

  override DataFlow::Node getValueNode() {
    result = pwn.getRhs()
  }

  override DOM::ElementDefinition getElement() {
    result = elt
  }
}

/**
 * An attribute definition using `jQuery.attr(elt, name, value)` or `jQuery.prop(elt, name, value)`
 * where `elt` is a wrapped set or a plain DOM element.
 */
private class JQueryAttr3Call extends JQueryAttributeDefinition, @callexpr {
  DOM::ElementDefinition elt;

  JQueryAttr3Call() {
    exists (MethodCallExpr mce | this = mce |
      mce = jquery().getAMemberCall(any(string m | m = "attr" or m = "prop")).asExpr() and
      mce.getArgument(0).(DOM::Element).getDefinition() = elt and
      mce.getNumArgument() = 3
    )
  }

  override string getName() {
    result = this.(CallExpr).getArgument(1).getStringValue()
  }

  override DataFlow::Node getValueNode() {
    result = DataFlow::valueNode(this.(CallExpr).getArgument(2))
  }

  override DOM::ElementDefinition getElement() {
    result = elt
  }
}

/**
 * A DOM element returned from a chained jQuery call.
 *
 * For example, the call `$("<script/>").attr("src", mySource)` returns
 * the DOM element constructed by `$("<script/>")`.
 */
private class JQueryChainedElement extends DOM::Element {
  DOM::Element inner;

  JQueryChainedElement() {
    exists (JQueryMethodCall jqmc | this = jqmc |
      jqmc.(MethodCallExpr).getReceiver() = inner and
      this instanceof JQueryObject and
      defn = inner.getDefinition()
    )
  }
}

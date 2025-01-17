/**
 * Provides classes for working with DOM elements.
 */

import javascript
import semmle.javascript.frameworks.Templating
private import semmle.javascript.dataflow.InferredTypes

module DOM {
  /**
   * A definition of a DOM element, for instance by an HTML element in an HTML file
   * or a JSX element in a JavaScript file.
   */
  abstract class ElementDefinition extends Locatable {
    /**
     * Gets the name of the DOM element; for example, a `<p>` element has
     * name `p`.
     */
    abstract string getName();

    /**
     * Gets the `i`th attribute of this DOM element, if it can be determined.
     *
     * For example, the 0th (and only) attribute of `<a href="https://semmle.com">Semmle</a>`
     * is `href="https://semmle.com"`.
     */
    AttributeDefinition getAttribute(int i) { none() }

    /**
     * Gets an attribute of this DOM element with name `name`.
     *
     * For example, the DOM element `<a href="https://semmle.com">Semmle</a>`
     * has a single attribute `href="https://semmle.com"` with the name `href`.
     */
    AttributeDefinition getAttributeByName(string name) {
      result.getElement() = this and
      result.getName() = name
    }

    /**
     * Gets an attribute of this DOM element.
     */
    AttributeDefinition getAnAttribute() { result.getElement() = this }

    /**
     * Gets the parent element of this element.
     */
    abstract ElementDefinition getParent();

    /**
     * Gets the root element (i.e. an element without a parent) in which this element is contained.
     */
    ElementDefinition getRoot() {
      if not exists(this.getParent()) then result = this else result = this.getParent().getRoot()
    }

    /**
     * Gets the document element to which this element belongs, if it can be determined.
     */
    DocumentElementDefinition getDocument() { result = this.getRoot() }
  }

  /**
   * An HTML element, viewed as an `ElementDefinition`.
   */
  private class HtmlElementDefinition extends ElementDefinition, @xmlelement instanceof HTML::Element
  {
    override string getName() { result = HTML::Element.super.getName() }

    override AttributeDefinition getAttribute(int i) {
      result = HTML::Element.super.getAttribute(i)
    }

    override ElementDefinition getParent() { result = HTML::Element.super.getParent() }
  }

  /**
   * A JSX element, viewed as an `ElementDefinition`.
   */
  private class JsxElementDefinition extends ElementDefinition, @jsx_element instanceof JsxElement {
    override string getName() { result = JsxElement.super.getName() }

    override AttributeDefinition getAttribute(int i) { result = JsxElement.super.getAttribute(i) }

    override ElementDefinition getParent() { result = super.getJsxParent() }
  }

  /**
   * A DOM attribute as defined, for instance, by an HTML attribute in an HTML file
   * or a JSX attribute in a JavaScript file.
   */
  abstract class AttributeDefinition extends Locatable {
    /**
     * Gets the name of this attribute, if any.
     *
     * JSX spread attributes do not have a name.
     */
    abstract string getName();

    /**
     * Gets the data flow node whose value is the value of this attribute,
     * if any.
     *
     * This is undefined for HTML elements, where the attribute value is not
     * computed but specified directly.
     */
    DataFlow::Node getValueNode() { none() }

    /**
     * Gets the value of this attribute, if it can be determined.
     */
    string getStringValue() { result = this.getValueNode().getStringValue() }

    /**
     * Gets the DOM element this attribute belongs to.
     */
    ElementDefinition getElement() { this = result.getAttributeByName(_) }

    /**
     * Holds if the value of this attribute might be a template value
     * such as `{{window.location.url}}`.
     */
    predicate mayHaveTemplateValue() {
      this.getStringValue().regexpMatch(Templating::getDelimiterMatchingRegexp())
    }
  }

  /**
   * An HTML attribute, viewed as an `AttributeDefinition`.
   */
  private class HtmlAttributeDefinition extends AttributeDefinition, @xmlattribute instanceof HTML::Attribute
  {
    override string getName() { result = HTML::Attribute.super.getName() }

    override string getStringValue() { result = super.getValue() }

    override ElementDefinition getElement() { result = HTML::Attribute.super.getElement() }
  }

  /**
   * A JSX attribute, viewed as an `AttributeDefinition`.
   */
  private class JsxAttributeDefinition extends AttributeDefinition, @jsx_attribute instanceof JsxAttribute
  {
    override string getName() { result = JsxAttribute.super.getName() }

    override DataFlow::Node getValueNode() {
      result = DataFlow::valueNode(JsxAttribute.super.getValue())
    }

    override ElementDefinition getElement() { result = JsxAttribute.super.getElement() }
  }

  /**
   * An HTML `<document>` element.
   */
  class DocumentElementDefinition extends ElementDefinition {
    DocumentElementDefinition() { this.getName() = "html" }

    override string getName() { none() }

    override AttributeDefinition getAttribute(int i) { none() }

    override AttributeDefinition getAttributeByName(string name) { none() }

    override ElementDefinition getParent() { none() }
  }

  /**
   * Holds if the value of attribute `attr` is interpreted as a URL.
   */
  predicate isUrlValuedAttribute(AttributeDefinition attr) {
    exists(string eltName, string attrName |
      eltName = attr.getElement().getName() and
      attrName = attr.getName()
    |
      eltName = ["script", "iframe", "embed", "video", "audio", "source", "track"] and
      attrName = "src"
      or
      eltName = ["link", "a", "base", "area"] and
      attrName = "href"
      or
      eltName = "form" and
      attrName = "action"
      or
      eltName = ["input", "button"] and
      attrName = "formaction"
    )
  }

  /**
   * A data flow node or other program element that may refer to
   * a DOM element.
   */
  abstract class Element extends Locatable {
    ElementDefinition defn;

    /** Gets the definition of this element. */
    ElementDefinition getDefinition() { result = defn }

    /** Gets the tag name of this DOM element. */
    string getName() { result = defn.getName() }

    /** Gets the `i`th attribute of this DOM element, if it can be determined. */
    AttributeDefinition getAttribute(int i) { result = defn.getAttribute(i) }

    /** Gets an attribute of this DOM element with the given `name`. */
    AttributeDefinition getAttributeByName(string name) { result = defn.getAttributeByName(name) }
  }

  /**
   * The default implementation of `Element`, including both
   * element definitions and data flow nodes that may refer to them.
   */
  private class DefaultElement extends Element {
    DefaultElement() {
      defn = this
      or
      exists(Element that |
        this.(Expr).flow().getALocalSource().asExpr() = that and
        defn = that.getDefinition()
      )
    }
  }

  /**
   * Holds if `attr` is an invalid id attribute because of `reason`.
   */
  predicate isInvalidHtmlIdAttributeValue(DOM::AttributeDefinition attr, string reason) {
    attr.getName() = "id" and
    exists(string v | v = attr.getStringValue() |
      v = "" and
      reason = "must contain at least one character"
      or
      v.regexpMatch(".*\\s.*") and
      reason = "must not contain any space characters"
    )
  }

  /** Gets a call that queries the DOM for a collection of DOM nodes. */
  private DataFlow::SourceNode domElementCollection() {
    exists(string collectionName |
      collectionName =
        [
          "getElementsByClassName", "getElementsByName", "getElementsByTagName",
          "getElementsByTagNameNS", "querySelectorAll"
        ]
    |
      (
        result = documentRef().getAMethodCall(collectionName) or
        result = DataFlow::globalVarRef(collectionName).getACall()
      )
    )
  }

  /** Gets a call that creates a DOM node or queries the DOM for a DOM node. */
  private DataFlow::SourceNode domElementCreationOrQuery() {
    exists(string methodName |
      methodName =
        ["createElement", "createElementNS", "createRange", "getElementById", "querySelector"]
    |
      result = documentRef().getAMethodCall(methodName) or
      result = DataFlow::globalVarRef(methodName).getACall()
    )
  }

  module DomValueSource {
    /**
     * A data flow node that should be considered a source of DOM values.
     */
    abstract class Range extends DataFlow::Node { }

    private predicate isDomElementType(ExternalType type) { isDomRootType(type.getASupertype*()) }

    private string getADomPropertyName() {
      exists(ExternalInstanceMemberDecl decl |
        result = decl.getName() and
        isDomElementType(decl.getDeclaringType())
      )
    }

    private predicate isDomElementTypeName(string name) {
      exists(ExternalType type |
        isDomElementType(type) and
        name = type.getName()
      )
    }

    /** Gets a method name which, if invoked on a DOM element (possibly of a specific subtype), returns a DOM element. */
    private string getAMethodProducingDomElements() {
      exists(ExternalInstanceMemberDecl decl |
        result = decl.getName() and
        isDomElementType(decl.getDeclaringType()) and
        isDomElementTypeName(decl.getDocumentation()
              .getATagByTitle("return")
              .getType()
              .getAnUnderlyingType()
              .(JSDocNamedTypeExpr)
              .getName())
      )
    }

    /**
     * Gets a data flow node that might refer to some form.
     * Either by a read like `document.forms[0]`, or a property read from `document` with some constant property-name.
     * E.g. if `<form name="foobar">..</form>` exists, then `document.foobar` refers to that form.
     */
    private DataFlow::SourceNode forms() {
      result = documentRef().getAPropertyRead("forms").getAPropertyRead()
      or
      exists(DataFlow::PropRead read |
        read = documentRef().getAPropertyRead() and
        result = read
      |
        read.mayHavePropertyName(_) and
        not read.mayHavePropertyName(getADomPropertyName())
      )
    }

    private InferredType getArgumentTypeFromJQueryMethodGet(JQuery::MethodCall call) {
      call.getMethodName() = "get" and
      result = call.getArgument(0).analyze().getAType()
    }

    private class DefaultRange extends Range {
      DefaultRange() {
        this.asExpr().(VarAccess).getVariable() instanceof DomGlobalVariable
        or
        exists(DataFlow::PropRead read |
          this = read and
          read = domValueRef().getAPropertyRead()
        |
          not read.mayHavePropertyName(_)
          or
          read.mayHavePropertyName(getADomPropertyName())
          or
          read.mayHavePropertyName(any(string s | exists(s.toInt())))
        )
        or
        this = domElementCreationOrQuery()
        or
        this = domElementCollection()
        or
        this = domValueRef().getAMethodCall(getAMethodProducingDomElements())
        or
        this = forms()
        or
        // reading property `foo` - where a child has `name="foo"` - resolves to that child.
        // We only look for such properties on forms/document, to avoid potential false positives.
        exists(DataFlow::SourceNode form | form = [forms(), documentRef()] |
          this = form.getAPropertyRead(any(string s | not s = getADomPropertyName()))
        )
        or
        exists(JQuery::MethodCall call | this = call and call.getMethodName() = "get" |
          call.getNumArgument() = 1 and
          unique(InferredType t | t = getArgumentTypeFromJQueryMethodGet(call)) = TTNumber()
        )
        or
        // A `this` node from a callback given to a `$().each(callback)` call.
        // purposely not using JQuery::MethodCall to avoid `jquery.each()`.
        exists(DataFlow::CallNode eachCall | eachCall = JQuery::objectRef().getAMethodCall("each") |
          this = DataFlow::thisNode(eachCall.getCallback(0).getFunction()) or
          this = eachCall.getABoundCallbackParameter(0, 1)
        )
        or
        // A read of an array-element from a JQuery object. E.g. `$("#foo")[0]`
        exists(DataFlow::PropRead read |
          read = this and read = JQuery::objectRef().getAPropertyRead()
        |
          unique(InferredType t | t = read.getPropertyNameExpr().analyze().getAType()) = TTNumber()
        )
        or
        // A receiver node of an event handler on a DOM node
        exists(DataFlow::SourceNode domNode, DataFlow::FunctionNode eventHandler |
          // NOTE: we do not use `getABoundFunctionValue()`, since bound functions tend to have
          // a different receiver anyway
          eventHandler = domNode.getAPropertySource(any(string n | n.matches("on%")))
          or
          eventHandler =
            domNode.getAMethodCall("addEventListener").getArgument(1).getAFunctionValue()
        |
          domNode = domValueRef() and
          this = eventHandler.getReceiver()
        )
        or
        this = DataFlow::thisNode(any(EventHandlerCode evt))
      }
    }
  }

  /** A data flow node that is a source of DOM events. */
  class DomEventSource extends DataFlow::Node instanceof DomEventSource::Range { }

  /** Companion module to the `DomEventSource` class. */
  module DomEventSource {
    /**
     * A data flow node that should be considered a source of DOM events.
     */
    abstract class Range extends DataFlow::Node { }

    private class DefaultRange extends Range {
      DefaultRange() {
        // e.g. <form onSubmit={e => e.target}/>
        exists(JsxAttribute attr | attr.getName().matches("on%") |
          this = attr.getValue().flow().getABoundFunctionValue(0).getParameter(0)
        )
        or
        // node.addEventListener("submit", e => e.target)
        this = domValueRef().getAMethodCall("addEventListener").getABoundCallbackParameter(1, 0)
        or
        // node.onSubmit = (e => e.target);
        exists(DataFlow::PropWrite write | write = domValueRef().getAPropertyWrite() |
          write.getPropertyName().matches("on%") and
          this = write.getRhs().getAFunctionValue().getParameter(0)
        )
      }
    }
  }

  /** Gets a data flow node that refers directly to a value from the DOM. */
  DataFlow::SourceNode domValueSource() { result instanceof DomValueSource::Range }

  /** Gets a data flow node that may refer to a value from the DOM. */
  private DataFlow::SourceNode domValueRef(DataFlow::TypeTracker t) {
    t.start() and
    result = domValueSource()
    or
    t.start() and
    result = domValueRef().getAMethodCall(["item", "namedItem"])
    or
    t.startInProp("target") and
    result instanceof DomEventSource
    or
    t.startInProp(DataFlow::PseudoProperties::arrayElement()) and
    result = domElementCollection()
    or
    exists(DataFlow::TypeTracker t2 | result = domValueRef(t2).track(t2, t))
  }

  /** Gets a data flow node that may refer to a value from the DOM. */
  DataFlow::SourceNode domValueRef() {
    result = domValueRef(DataFlow::TypeTracker::end())
    or
    result.hasUnderlyingType("Element")
    or
    result.hasUnderlyingType(any(string s | s.matches("HTML%Element")))
    or
    exists(DataFlow::ClassNode cls |
      cls.getASuperClassNode().getALocalSource() =
        DataFlow::globalVarRef(any(string s | s.matches("HTML%Element"))) and
      result = cls.getAnInstanceReference()
    )
  }

  module LocationSource {
    /**
     * A data flow node that should be considered a source of the DOM `location` object.
     *
     * Can be subclassed to add additional such nodes.
     */
    abstract class Range extends DataFlow::Node { }

    private class DefaultRange extends Range {
      DefaultRange() {
        exists(string propName | this = documentRef().getAPropertyRead(propName) |
          propName = ["documentURI", "documentURIObject", "location", "referrer", "URL"]
        )
        or
        this = DOM::domValueRef().getAPropertyRead("baseUri")
        or
        this = DataFlow::globalVarRef("location")
        or
        this = any(DataFlow::Node n | n.hasUnderlyingType("Location")).getALocalSource() and
        not this = nonFirstLocationType(DataFlow::TypeTracker::end()) // only start from the source, and not the locations we can type-track to.
      }
    }
  }

  /**
   * Get a reference to a node of type `Location` that has gone through at least 1 type-tracking step.
   */
  private DataFlow::SourceNode nonFirstLocationType(DataFlow::TypeTracker t) {
    // One step inlined in the beginning.
    exists(DataFlow::TypeTracker t2 |
      result =
        any(DataFlow::Node n | n.hasUnderlyingType("Location")).getALocalSource().track(t2, t) and
      t2.start()
    )
    or
    exists(DataFlow::TypeTracker t2 | result = nonFirstLocationType(t2).track(t2, t))
  }

  /** Gets a data flow node that directly refers to a DOM `location` object. */
  DataFlow::SourceNode locationSource() { result instanceof LocationSource::Range }

  /** Gets a reference to a DOM `location` object. */
  private DataFlow::SourceNode locationRef(DataFlow::TypeTracker t) {
    t.start() and
    result = locationSource()
    or
    t.startInProp("location") and
    result = [DataFlow::globalObjectRef(), documentSource()]
    or
    exists(DataFlow::TypeTracker t2 | result = locationRef(t2).track(t2, t))
  }

  /** Gets a reference to a DOM `location` object. */
  DataFlow::SourceNode locationRef() { result = locationRef(DataFlow::TypeTracker::end()) }

  module DocumentSource {
    /**
     * A data flow node that should be considered a source of the `document` object.
     *
     * Can be subclassed to add additional such nodes.
     */
    abstract class Range extends DataFlow::Node { }

    private class DefaultRange extends Range {
      DefaultRange() { this = DataFlow::globalVarRef("document") }
    }
  }

  /**
   * Gets a direct reference to the `document` object.
   */
  DataFlow::SourceNode documentSource() { result instanceof DocumentSource::Range }

  /**
   * Gets a reference to the `document` object.
   */
  private DataFlow::SourceNode documentRef(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof DocumentSource::Range
    or
    exists(DataFlow::TypeTracker t2 | result = documentRef(t2).track(t2, t))
  }

  /**
   * Gets a reference to the 'document' object.
   */
  DataFlow::SourceNode documentRef() {
    result = documentRef(DataFlow::TypeTracker::end())
    or
    result.hasUnderlyingType("Document")
  }

  /**
   * Holds if a value assigned to property `name` of a DOM node can be interpreted as JavaScript via the `javascript:` protocol.
   */
  string getAPropertyNameInterpretedAsJavaScriptUrl() {
    result = ["action", "formaction", "href", "src", "data"]
  }
}

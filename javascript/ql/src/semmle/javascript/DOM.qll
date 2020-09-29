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
      if not exists(getParent()) then result = this else result = getParent().getRoot()
    }

    /**
     * Gets the document element to which this element belongs, if it can be determined.
     */
    DocumentElementDefinition getDocument() { result = getRoot() }
  }

  /**
   * An HTML element, viewed as an `ElementDefinition`.
   */
  private class HtmlElementDefinition extends ElementDefinition, @xmlelement {
    HtmlElementDefinition() { this instanceof HTML::Element }

    override string getName() { result = this.(HTML::Element).getName() }

    override AttributeDefinition getAttribute(int i) {
      result = this.(HTML::Element).getAttribute(i)
    }

    override ElementDefinition getParent() { result = this.(HTML::Element).getParent() }
  }

  /**
   * A JSX element, viewed as an `ElementDefinition`.
   */
  private class JsxElementDefinition extends ElementDefinition, @jsx_element {
    JsxElementDefinition() { this instanceof JSXElement }

    override string getName() { result = this.(JSXElement).getName() }

    override AttributeDefinition getAttribute(int i) { result = this.(JSXElement).getAttribute(i) }

    override ElementDefinition getParent() { result = this.(JSXElement).getJsxParent() }
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
    string getStringValue() { result = getValueNode().getStringValue() }

    /**
     * Gets the DOM element this attribute belongs to.
     */
    ElementDefinition getElement() { this = result.getAttributeByName(_) }

    /**
     * Holds if the value of this attribute might be a template value
     * such as `{{window.location.url}}`.
     */
    predicate mayHaveTemplateValue() {
      getStringValue().regexpMatch(Templating::getDelimiterMatchingRegexp())
    }
  }

  /**
   * An HTML attribute, viewed as an `AttributeDefinition`.
   */
  private class HtmlAttributeDefinition extends AttributeDefinition, @xmlattribute {
    HtmlAttributeDefinition() { this instanceof HTML::Attribute }

    override string getName() { result = this.(HTML::Attribute).getName() }

    override string getStringValue() { result = this.(HTML::Attribute).getValue() }

    override ElementDefinition getElement() { result = this.(HTML::Attribute).getElement() }
  }

  /**
   * A JSX attribute, viewed as an `AttributeDefinition`.
   */
  private class JsxAttributeDefinition extends AttributeDefinition, @jsx_attribute {
    JSXAttribute attr;

    JsxAttributeDefinition() { this = attr }

    override string getName() { result = attr.getName() }

    override DataFlow::Node getValueNode() { result = DataFlow::valueNode(attr.getValue()) }

    override ElementDefinition getElement() { result = attr.getElement() }
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
      (
        eltName = "script" or
        eltName = "iframe" or
        eltName = "embed" or
        eltName = "video" or
        eltName = "audio" or
        eltName = "source" or
        eltName = "track"
      ) and
      attrName = "src"
      or
      (
        eltName = "link" or
        eltName = "a" or
        eltName = "base" or
        eltName = "area"
      ) and
      attrName = "href"
      or
      eltName = "form" and
      attrName = "action"
      or
      (eltName = "input" or eltName = "button") and
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
      collectionName = "getElementsByClassName" or
      collectionName = "getElementsByName" or
      collectionName = "getElementsByTagName" or
      collectionName = "getElementsByTagNameNS" or
      collectionName = "querySelectorAll"
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
      methodName = "createElement" or
      methodName = "createElementNS" or
      methodName = "createRange" or
      methodName = "getElementById" or
      methodName = "querySelector"
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

    private string getADomPropertyName() {
      exists(ExternalInstanceMemberDecl decl |
        result = decl.getName() and
        isDomRootType(decl.getDeclaringType().getASupertype*())
      )
    }

    private class DefaultRange extends Range {
      DefaultRange() {
        this.asExpr().(VarAccess).getVariable() instanceof DOMGlobalVariable
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
        exists(JQuery::MethodCall call | this = call and call.getMethodName() = "get" |
          call.getNumArgument() = 1 and
          forex(InferredType t | t = call.getArgument(0).analyze().getAType() | t = TTNumber())
        )
        or
        // A `this` node from a callback given to a `$().each(callback)` call.
        // purposely not using JQuery::MethodCall to avoid `jquery.each()`.
        exists(DataFlow::CallNode eachCall | eachCall = JQuery::objectRef().getAMethodCall("each") |
          this = DataFlow::thisNode(eachCall.getCallback(0).getFunction()) or
          this = eachCall.getABoundCallbackParameter(0, 1)
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
    exists(DataFlow::TypeTracker t2 | result = domValueRef(t2).track(t2, t))
  }

  /** Gets a data flow node that may refer to a value from the DOM. */
  DataFlow::SourceNode domValueRef() {
    result = domValueRef(DataFlow::TypeTracker::end())
    or
    result.hasUnderlyingType("Element")
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
          propName = "documentURI" or
          propName = "documentURIObject" or
          propName = "location" or
          propName = "referrer" or
          propName = "URL"
        )
        or
        this = DOM::domValueRef().getAPropertyRead("baseUri")
        or
        this = DataFlow::globalVarRef("location")
      }
    }
  }

  /** Gets a data flow node that directly refers to a DOM `location` object. */
  DataFlow::SourceNode locationSource() { result instanceof LocationSource::Range }

  /** Gets a reference to a DOM `location` object. */
  private DataFlow::SourceNode locationRef(DataFlow::TypeTracker t) {
    t.start() and
    result = locationSource()
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
}

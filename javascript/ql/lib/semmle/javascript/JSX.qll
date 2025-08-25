/**
 * Provides classes for working with JSX code.
 */

import javascript

/**
 * A JSX element or fragment.
 *
 * Examples:
 *
 * ```
 * <a href={linkTarget()}>{linkText()}</a>
 * <Welcome name={user.name}/>
 * <><h1>Title</h1>Some <b>text</b></>
 * ```
 */
class JsxNode extends Expr, @jsx_element {
  /** Gets the `i`th element in the body of this element or fragment. */
  Expr getBodyElement(int i) { i >= 0 and result = this.getChildExpr(-i - 2) }

  /** Gets an element in the body of this element or fragment. */
  Expr getABodyElement() { result = this.getBodyElement(_) }

  /**
   * Gets the parent JSX element or fragment of this element.
   */
  JsxNode getJsxParent() { this = result.getABodyElement() }

  override string getAPrimaryQlClass() { result = "JsxNode" }
}

/**
 * A JSX element.
 *
 * Examples:
 *
 * ```
 * <a href={linkTarget()}>{linkText()}</a>
 * <Welcome name={user.name}/>
 * ```
 */
class JsxElement extends JsxNode {
  JsxName name;

  JsxElement() { name = this.getChildExpr(-1) }

  /** Gets the expression denoting the name of this element. */
  JsxName getNameExpr() { result = name }

  /** Gets the name of this element. */
  string getName() { result = name.getValue() }

  /** Gets the `i`th attribute of this element. */
  JsxAttribute getAttribute(int i) { properties(result, this, i, _, _) }

  /** Gets an attribute of this element. */
  JsxAttribute getAnAttribute() { result = this.getAttribute(_) }

  /** Gets the attribute of this element with the given name, if any. */
  JsxAttribute getAttributeByName(string n) {
    result = this.getAnAttribute() and result.getName() = n
  }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getNameExpr().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "JsxElement" }

  /**
   * Holds if this JSX element is an HTML element.
   * That is, the name starts with a lowercase letter.
   */
  predicate isHtmlElement() { this.getName().regexpMatch("[a-z].*") }
}

/**
 * A JSX fragment.
 *
 * Example:
 *
 * ```
 * <><h1>Title</h1>Some <b>text</b></>
 * ```
 */
class JsxFragment extends JsxNode {
  JsxFragment() { not exists(this.getChildExpr(-1)) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getBodyElement(0).getFirstControlFlowNode()
    or
    not exists(this.getABodyElement()) and result = this
  }

  override string getAPrimaryQlClass() { result = "JsxFragment" }
}

/**
 * An attribute of a JSX element, including spread attributes.
 *
 * Examples:
 *
 * ```
 * <a href={linkTarget()}>link</a>   // `href={linkTarget()}` is an attribute
 * <Welcome name={user.name}/>       // `name={user.name}` is an attribute
 * <div {...attrs}></div>            // `{...attrs}` is a (spread) attribute
 * ```
 */
class JsxAttribute extends AstNode, @jsx_attribute {
  /**
   * Gets the expression denoting the name of this attribute.
   *
   * This is not defined for spread attributes.
   */
  JsxName getNameExpr() { result = this.getChildExpr(0) }

  /**
   * Gets the name of this attribute.
   *
   * This is not defined for spread attributes.
   */
  string getName() { result = this.getNameExpr().getValue() }

  /** Gets the expression denoting the value of this attribute. */
  Expr getValue() { result = this.getChildExpr(1) }

  /** Gets the value of this attribute as a constant string, if possible. */
  string getStringValue() { result = this.getValue().getStringValue() }

  /** Gets the JSX element to which this attribute belongs. */
  JsxElement getElement() { this = result.getAnAttribute() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getNameExpr().getFirstControlFlowNode()
    or
    not exists(this.getNameExpr()) and result = this.getValue().getFirstControlFlowNode()
  }

  override string toString() { properties(this, _, _, _, result) }

  override string getAPrimaryQlClass() { result = "JsxAttribute" }
}

/**
 * A spread attribute of a JSX element.
 *
 * Example:
 *
 * ```
 * <div {...attrs}></div>            // `{...attrs}` is a spread attribute
 * ```
 */
class JsxSpreadAttribute extends JsxAttribute {
  JsxSpreadAttribute() { not exists(this.getNameExpr()) }

  override SpreadElement getValue() {
    // override for more precise result type
    result = super.getValue()
  }
}

/**
 * A namespace-qualified name such as `n:a`.
 *
 * Example:
 *
 * ```
 * html:href
 * ```
 */
class JsxQualifiedName extends Expr, @jsx_qualified_name {
  /** Gets the namespace component of this qualified name. */
  Identifier getNamespace() { result = this.getChildExpr(0) }

  /** Gets the name component of this qualified name. */
  Identifier getName() { result = this.getChildExpr(1) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getNamespace().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "JsxQualifiedName" }
}

/**
 * A name of an JSX element or attribute (which is
 * always an identifier, a dot expression, or a qualified
 * namespace name).
 *
 * Examples:
 *
 * ```
 * href
 * html:href
 * data.path
 * ```
 */
class JsxName extends Expr {
  JsxName() {
    this instanceof Identifier or
    this instanceof ThisExpr or
    this.(DotExpr).getBase() instanceof JsxName or
    this instanceof JsxQualifiedName
  }

  /**
   * Gets the string value of this name.
   */
  string getValue() {
    result = this.(Identifier).getName()
    or
    exists(DotExpr dot | dot = this |
      result = dot.getBase().(JsxName).getValue() + "." + dot.getPropertyName()
    )
    or
    exists(JsxQualifiedName qual | qual = this |
      result = qual.getNamespace().getName() + ":" + qual.getName().getName()
    )
    or
    this instanceof ThisExpr and
    result = "this"
  }
}

/**
 * An interpolating expression that interpolates nothing.
 *
 * Example:
 *
 * <pre>
 * { /* TBD *&#47; }
 * </pre>
 */
class JsxEmptyExpr extends Expr, @jsx_empty_expr {
  override string getAPrimaryQlClass() { result = "JsxEmptyExpr" }
}

/**
 * A legacy `@jsx` pragma.
 *
 * Example:
 *
 * ```
 * @jsx React.DOM
 * ```
 */
class JsxPragma extends JSDocTag {
  JsxPragma() { this.getTitle() = "jsx" }

  /**
   * Gets the DOM name specified by the pragma; for `@jsx React.DOM`,
   * the result is `React.DOM`.
   */
  string getDomName() { result = this.getDescription().trim() }
}

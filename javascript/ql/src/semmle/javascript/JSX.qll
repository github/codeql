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
class JSXNode extends Expr, @jsx_element {
  /** Gets the `i`th element in the body of this element or fragment. */
  Expr getBodyElement(int i) { i >= 0 and result = getChildExpr(-i - 2) }

  /** Gets an element in the body of this element or fragment. */
  Expr getABodyElement() { result = getBodyElement(_) }

  /**
   * Gets the parent JSX element or fragment of this element.
   */
  JSXNode getJsxParent() { this = result.getABodyElement() }
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
class JSXElement extends JSXNode {
  JSXName name;

  JSXElement() { name = getChildExpr(-1) }

  /** Gets the expression denoting the name of this element. */
  JSXName getNameExpr() { result = name }

  /** Gets the name of this element. */
  string getName() { result = name.getValue() }

  /** Gets the `i`th attribute of this element. */
  JSXAttribute getAttribute(int i) { properties(result, this, i, _, _) }

  /** Gets an attribute of this element. */
  JSXAttribute getAnAttribute() { result = getAttribute(_) }

  /** Gets the attribute of this element with the given name, if any. */
  JSXAttribute getAttributeByName(string n) { result = getAnAttribute() and result.getName() = n }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getNameExpr().getFirstControlFlowNode()
  }
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
class JSXFragment extends JSXNode {
  JSXFragment() { not exists(getChildExpr(-1)) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getBodyElement(0).getFirstControlFlowNode()
    or
    not exists(getABodyElement()) and result = this
  }
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
class JSXAttribute extends ASTNode, @jsx_attribute {
  /**
   * Gets the expression denoting the name of this attribute.
   *
   * This is not defined for spread attributes.
   */
  JSXName getNameExpr() { result = getChildExpr(0) }

  /**
   * Gets the name of this attribute.
   *
   * This is not defined for spread attributes.
   */
  string getName() { result = getNameExpr().getValue() }

  /** Gets the expression denoting the value of this attribute. */
  Expr getValue() { result = getChildExpr(1) }

  /** Gets the value of this attribute as a constant string, if possible. */
  string getStringValue() { result = getValue().getStringValue() }

  /** Gets the JSX element to which this attribute belongs. */
  JSXElement getElement() { this = result.getAnAttribute() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getNameExpr().getFirstControlFlowNode()
    or
    not exists(getNameExpr()) and result = getValue().getFirstControlFlowNode()
  }

  override string toString() { properties(this, _, _, _, result) }
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
class JSXSpreadAttribute extends JSXAttribute {
  JSXSpreadAttribute() { not exists(getNameExpr()) }

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
class JSXQualifiedName extends Expr, @jsx_qualified_name {
  /** Gets the namespace component of this qualified name. */
  Identifier getNamespace() { result = getChildExpr(0) }

  /** Gets the name component of this qualified name. */
  Identifier getName() { result = getChildExpr(1) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getNamespace().getFirstControlFlowNode()
  }
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
class JSXName extends Expr {
  JSXName() {
    this instanceof Identifier or
    this instanceof ThisExpr or
    this.(DotExpr).getBase() instanceof JSXName or
    this instanceof JSXQualifiedName
  }

  /**
   * Gets the string value of this name.
   */
  string getValue() {
    result = this.(Identifier).getName()
    or
    exists(DotExpr dot | dot = this |
      result = dot.getBase().(JSXName).getValue() + "." + dot.getPropertyName()
    )
    or
    exists(JSXQualifiedName qual | qual = this |
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
class JSXEmptyExpr extends Expr, @jsx_empty_expr { }

/**
 * A legacy `@jsx` pragma.
 *
 * Example:
 *
 * ```
 * @jsx React.DOM
 * ```
 */
class JSXPragma extends JSDocTag {
  JSXPragma() { getTitle() = "jsx" }

  /**
   * Gets the DOM name specified by the pragma; for `@jsx React.DOM`,
   * the result is `React.DOM`.
   */
  string getDOMName() { result = getDescription().trim() }
}

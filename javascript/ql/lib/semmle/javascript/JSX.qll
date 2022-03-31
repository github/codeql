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
  Expr getBodyElement(int i) { i >= 0 and result = getChildExpr(-i - 2) }

  /** Gets an element in the body of this element or fragment. */
  Expr getABodyElement() { result = getBodyElement(_) }

  /**
   * Gets the parent JSX element or fragment of this element.
   */
  JsxNode getJsxParent() { this = result.getABodyElement() }

  override string getAPrimaryQlClass() { result = "JsxNode" }
}

/** DEPRECATED: Alias for JsxNode */
deprecated class JSXNode = JsxNode;

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

  JsxElement() { name = getChildExpr(-1) }

  /** Gets the expression denoting the name of this element. */
  JsxName getNameExpr() { result = name }

  /** Gets the name of this element. */
  string getName() { result = name.getValue() }

  /** Gets the `i`th attribute of this element. */
  JsxAttribute getAttribute(int i) { properties(result, this, i, _, _) }

  /** Gets an attribute of this element. */
  JsxAttribute getAnAttribute() { result = getAttribute(_) }

  /** Gets the attribute of this element with the given name, if any. */
  JsxAttribute getAttributeByName(string n) { result = getAnAttribute() and result.getName() = n }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getNameExpr().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "JsxElement" }

  /**
   * Holds if this JSX element is a HTML element.
   * That is, the name starts with a lowercase letter.
   */
  predicate isHtmlElement() { getName().regexpMatch("[a-z].*") }

  /** DEPRECATED: Alias for isHtmlElement */
  deprecated predicate isHTMLElement() { isHtmlElement() }
}

/** DEPRECATED: Alias for JsxElement */
deprecated class JSXElement = JsxElement;

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
  JsxFragment() { not exists(getChildExpr(-1)) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getBodyElement(0).getFirstControlFlowNode()
    or
    not exists(getABodyElement()) and result = this
  }

  override string getAPrimaryQlClass() { result = "JsxFragment" }
}

/** DEPRECATED: Alias for JsxFragment */
deprecated class JSXFragment = JsxFragment;

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
  JsxName getNameExpr() { result = getChildExpr(0) }

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
  JsxElement getElement() { this = result.getAnAttribute() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getNameExpr().getFirstControlFlowNode()
    or
    not exists(getNameExpr()) and result = getValue().getFirstControlFlowNode()
  }

  override string toString() { properties(this, _, _, _, result) }

  override string getAPrimaryQlClass() { result = "JsxAttribute" }
}

/** DEPRECATED: Alias for JsxAttribute */
deprecated class JSXAttribute = JsxAttribute;

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
  JsxSpreadAttribute() { not exists(getNameExpr()) }

  override SpreadElement getValue() {
    // override for more precise result type
    result = super.getValue()
  }
}

/** DEPRECATED: Alias for JsxSpreadAttribute */
deprecated class JSXSpreadAttribute = JsxSpreadAttribute;

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
  Identifier getNamespace() { result = getChildExpr(0) }

  /** Gets the name component of this qualified name. */
  Identifier getName() { result = getChildExpr(1) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getNamespace().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "JsxQualifiedName" }
}

/** DEPRECATED: Alias for JsxQualifiedName */
deprecated class JSXQualifiedName = JsxQualifiedName;

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

/** DEPRECATED: Alias for JsxName */
deprecated class JSXName = JsxName;

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

/** DEPRECATED: Alias for JsxEmptyExpr */
deprecated class JSXEmptyExpr = JsxEmptyExpr;

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
  JsxPragma() { getTitle() = "jsx" }

  /**
   * Gets the DOM name specified by the pragma; for `@jsx React.DOM`,
   * the result is `React.DOM`.
   */
  string getDomName() { result = getDescription().trim() }

  /** DEPRECATED: Alias for getDomName */
  deprecated string getDOMName() { result = getDomName() }
}

/** DEPRECATED: Alias for JsxPragma */
deprecated class JSXPragma = JsxPragma;

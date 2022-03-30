/**
 * Provides classes for working with E4X.
 */

import javascript

module E4X {
  /**
   * An E4X wildcard pseudo-identifier.
   *
   * Example:
   *
   * ```
   * *
   * ```
   */
  class XmlAnyName extends Expr, @e4x_xml_anyname { }

  /** DEPRECATED: Alias for XmlAnyName */
  deprecated class XMLAnyName = XmlAnyName;

  /**
   * An E4X qualified identifier.
   *
   * Examples:
   *
   * ```
   * soap::encodingStyle
   * soap::["encodingStyle"]
   * ```
   *
   * Note that qualified identifiers are not currently supported by the parser, so snapshots
   * will not usually contain any.
   */
  class XmlQualifiedIdentifier extends Expr, @e4x_xml_qualident {
    /**
     * Gets the left operand of this qualified identifier, which is either
     * an identifier or a wildcard.
     */
    Expr getLeft() { result = getChildExpr(0) }

    /**
     * Gets the right operand of this qualified identifer, which is either
     * an identifier, or an arbitrary expression for computed qualified
     * identifiers.
     */
    Expr getRight() { result = getChildExpr(1) }

    /**
     * Holds if this is a qualified identifier with a computed name, as in
     * `q::[expr]`.
     */
    predicate isComputed() { this instanceof @e4x_xml_dynamic_qualident }

    override ControlFlowNode getFirstControlFlowNode() {
      result = getLeft().getFirstControlFlowNode()
    }
  }

  /** DEPRECATED: Alias for XmlQualifiedIdentifier */
  deprecated class XMLQualifiedIdentifier = XmlQualifiedIdentifier;

  /**
   * An E4X attribute selector.
   *
   * Examples:
   *
   * ```
   * @border
   * @[p]
   * ```
   */
  class XmlAttributeSelector extends Expr, @e4x_xml_attribute_selector {
    /**
     * Gets the selected attribute, which is either a static name (that is, a
     * wildcard identifier or a possibly qualified name), or an arbitrary
     * expression for computed attribute selectors.
     */
    Expr getAttribute() { result = getChildExpr(0) }

    /**
     * Holds if this is an attribute selector with a computed name, as in
     * `@[expr]`.
     */
    predicate isComputed() { this instanceof @e4x_xml_dynamic_attribute_selector }

    override ControlFlowNode getFirstControlFlowNode() {
      result = getAttribute().getFirstControlFlowNode()
    }
  }

  /** DEPRECATED: Alias for XmlAttributeSelector */
  deprecated class XMLAttributeSelector = XmlAttributeSelector;

  /**
   * An E4X filter expression.
   *
   * Example:
   *
   * ```
   * employees.(@id == 0 || @id == 1)
   * ```
   */
  class XmlFilterExpression extends Expr, @e4x_xml_filter_expression {
    /**
     * Gets the left operand of this filter expression.
     */
    Expr getLeft() { result = getChildExpr(0) }

    /**
     * Gets the right operand of this filter expression.
     */
    Expr getRight() { result = getChildExpr(1) }

    override ControlFlowNode getFirstControlFlowNode() {
      result = getLeft().getFirstControlFlowNode()
    }
  }

  /** DEPRECATED: Alias for XmlFilterExpression */
  deprecated class XMLFilterExpression = XmlFilterExpression;

  /**
   * An E4X "dot-dot" expression.
   *
   * Example:
   *
   * ```
   * e..name
   * ```
   */
  class XmlDotDotExpression extends Expr, @e4x_xml_dotdotexpr {
    /**
     * Gets the base expression of this dot-dot expression.
     */
    Expr getBase() { result = getChildExpr(0) }

    /**
     * Gets the index expression of this dot-dot expression.
     */
    Expr getIndex() { result = getChildExpr(1) }

    override ControlFlowNode getFirstControlFlowNode() {
      result = getBase().getFirstControlFlowNode()
    }
  }

  /** DEPRECATED: Alias for XmlDotDotExpression */
  deprecated class XMLDotDotExpression = XmlDotDotExpression;
}

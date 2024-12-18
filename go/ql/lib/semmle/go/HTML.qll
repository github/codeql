/** Provides classes for working with HTML documents. */

import go

module HTML {
  /**
   * An HTML element.
   *
   * Example:
   *
   * ```
   * <a href="semmle.com">Semmle</a>
   * ```
   */
  class Element extends Locatable, @xmlelement {
    Element() { exists(HtmlFile f | xmlElements(this, _, _, _, f)) }

    /**
     * Gets the name of this HTML element.
     *
     * For example, the name of `<br>` is `br`.
     */
    string getName() { xmlElements(this, result, _, _, _) }

    /**
     * Gets the parent element of this element, if any.
     */
    Element getParent() { xmlElements(this, _, result, _, _) }

    /**
     * Holds if this is a toplevel element, that is, if it does not have a parent element.
     */
    predicate isTopLevel() { not exists(this.getParent()) }

    /**
     * Gets the root HTML document element in which this element is contained.
     */
    DocumentElement getDocument() { result = this.getRoot() }

    /**
     * Gets the root element in which this element is contained.
     */
    Element getRoot() {
      if this.isTopLevel() then result = this else result = this.getParent().getRoot()
    }

    /**
     * Gets the `i`th child element (0-based) of this element.
     */
    Element getChild(int i) { xmlElements(result, _, this, i, _) }

    /**
     * Gets a child element of this element.
     */
    Element getChild() { result = this.getChild(_) }

    /**
     * Gets the `i`th attribute (0-based) of this element.
     */
    Attribute getAttribute(int i) { xmlAttrs(result, this, _, _, i, _) }

    /**
     * Gets an attribute of this element.
     */
    Attribute getAnAttribute() { result = this.getAttribute(_) }

    /**
     * Gets an attribute of this element that has the given name.
     */
    Attribute getAttributeByName(string name) {
      result = this.getAnAttribute() and
      result.getName() = name
    }

    /**
     * Gets the text node associated with this element.
     */
    TextNode getTextNode() { result.getParent() = this }

    override string toString() { result = "<" + this.getName() + ">...</>" }
  }

  /**
   * An attribute of an HTML element.
   *
   * Examples:
   *
   * ```
   * <a
   *   href ="semmle.com"  <!-- an attribute -->
   *   target=_blank       <!-- also an attribute -->
   * >Semmle</a>
   * ```
   */
  class Attribute extends Locatable, @xmlattribute {
    Attribute() { xmlAttrs(this, _, _, _, _, any(HtmlFile f)) }

    /**
     * Gets the element to which this attribute belongs.
     */
    Element getElement() { xmlAttrs(this, result, _, _, _, _) }

    /**
     * Gets the root element in which the element to which this attribute
     * belongs is contained.
     */
    Element getRoot() { result = this.getElement().getRoot() }

    /**
     * Gets the name of this attribute.
     */
    string getName() { xmlAttrs(this, _, result, _, _, _) }

    /**
     * Gets the value of this attribute.
     *
     * For attributes without an explicitly specified value, the
     * result is the empty string.
     */
    string getValue() { xmlAttrs(this, _, _, result, _, _) }

    override string toString() { result = this.getName() + "=" + this.getValue() }
  }

  /**
   * An HTML `<html>` element.
   *
   * Example:
   *
   * ```
   * <html>
   * <body>
   * This is a test.
   * </body>
   * </html>
   * ```
   */
  class DocumentElement extends Element {
    DocumentElement() { this.getName() = "html" }
  }

  /**
   * An HTML text node.
   *
   * Example:
   *
   * ```
   * <div>
   *   This text is represented as a text node.
   * </div>
   * ```
   */
  class TextNode extends Locatable, @xmlcharacters {
    TextNode() { exists(HtmlFile f | xmlChars(this, _, _, _, _, f)) }

    override string toString() { result = this.getText() }

    /**
     * Gets the content of this text node.
     *
     * Note that entity expansion has been performed already.
     */
    string getText() { xmlChars(this, result, _, _, _, _) }

    /**
     * Gets the parent this text.
     */
    Element getParent() { xmlChars(this, _, result, _, _, _) }

    /**
     * Gets the child index number of this text node.
     */
    int getIndex() { xmlChars(this, _, _, result, _, _) }

    /**
     * Holds if this text node is inside a `CDATA` tag.
     */
    predicate isCData() { xmlChars(this, _, _, _, 1, _) }
  }

  /**
   * An HTML comment.
   *
   * Example:
   *
   * ```
   * <!-- this is a comment -->
   * ```
   */
  class CommentNode extends Locatable, @xmlcomment {
    CommentNode() { exists(HtmlFile f | xmlComments(this, _, _, f)) }

    /** Gets the element in which this comment occurs. */
    Element getParent() { xmlComments(this, _, result, _) }

    /** Gets the text of this comment, not including delimiters. */
    string getText() { result = this.toString().regexpCapture("(?s)<!--(.*)-->", 1) }

    override string toString() { xmlComments(this, result, _, _) }
  }
}

/** Provides classes for working with HTML documents. */

import javascript

module HTML {
  /**
   * An HTML file.
   */
  class HtmlFile extends File {
    HtmlFile() { getFileType().isHtml() }
  }

  /**
   * A file that may contain HTML elements.
   *
   * This is either an `.html` file or a source code file containing
   * embedded HTML snippets.
   */
  private class FileContainingHtml extends File {
    FileContainingHtml() {
      getFileType().isHtml()
      or
      // The file contains an expression containing an HTML element
      exists(Expr e |
        e.getFile() = this and
        xml_element_parent_expression(_, e, _)
      )
    }
  }

  /** Gets `i`th root node of the HTML fragment embedded in the given expression, if any. */
  Element getHtmlElementFromExpr(Expr e, int i) { xml_element_parent_expression(result, e, i) }

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
    Element() { exists(FileContainingHtml f | xmlElements(this, _, _, _, f)) }

    override Location getLocation() { xmllocations(this, result) }

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
    predicate isTopLevel() { not exists(getParent()) }

    /**
     * Gets the root HTML document element in which this element is contained.
     */
    DocumentElement getDocument() { result = getRoot() }

    /**
     * Gets the root element in which this element is contained.
     */
    Element getRoot() { if isTopLevel() then result = this else result = getParent().getRoot() }

    /**
     * Gets the `i`th child element (0-based) of this element.
     */
    Element getChild(int i) { xmlElements(result, _, this, i, _) }

    /**
     * Gets a child element of this element.
     */
    Element getChild() { result = getChild(_) }

    /**
     * Gets the `i`th attribute (0-based) of this element.
     */
    Attribute getAttribute(int i) { xmlAttrs(result, this, _, _, i, _) }

    /**
     * Gets an attribute of this element.
     */
    Attribute getAnAttribute() { result = getAttribute(_) }

    /**
     * Gets an attribute of this element that has the given name.
     */
    Attribute getAttributeByName(string name) {
      result = getAnAttribute() and
      result.getName() = name
    }

    override string toString() { result = "<" + getName() + ">...</>" }

    override string getAPrimaryQlClass() { result = "HTML::Element" }
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
    Attribute() { exists(FileContainingHtml f | xmlAttrs(this, _, _, _, _, f)) }

    override Location getLocation() { xmllocations(this, result) }

    /**
     * Gets the inline script of this attribute, if any.
     */
    CodeInAttribute getCodeInAttribute() { toplevel_parent_xml_node(result, this) }

    /**
     * Gets the element to which this attribute belongs.
     */
    Element getElement() { xmlAttrs(this, result, _, _, _, _) }

    /**
     * Gets the root element in which the element to which this attribute
     * belongs is contained.
     */
    Element getRoot() { result = getElement().getRoot() }

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

    override string toString() { result = getName() + "=" + getValue() }

    override string getAPrimaryQlClass() { result = "HTML::Attribute" }
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
    DocumentElement() { getName() = "html" }
  }

  /**
   * An HTML `<iframe>` element.
   *
   * Example:
   *
   * ```
   * <iframe src="https://test.local/somepage.html"></iframe>
   * ```
   */
  class IframeElement extends Element {
    IframeElement() { getName() = "iframe" }

    /**
     * Gets the value of the `src` attribute.
     */
    string getSourcePath() { result = getAttributeByName("src").getValue() }
  }

  /**
   * An HTML `<script>` element.
   *
   * Example:
   *
   * ```
   * <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
   * ```
   */
  class ScriptElement extends Element {
    ScriptElement() { getName() = "script" }

    /**
     * Gets the absolute file system path the value of the `src` attribute
     * of this script tag resolves to, if any.
     *
     * Path resolution is currently limited to absolute `file://` URLs,
     * absolute file system paths starting with `/`, and paths relative
     * to the enclosing HTML file. Base URLs are not taken into account.
     */
    string resolveSourcePath() {
      exists(string path | path = getSourcePath() |
        result = path.regexpCapture("file://(/.*)", 1)
        or
        not path.regexpMatch("(\\w+:)?//.*") and
        result = getSourcePath().(ScriptSrcPath).resolve(getSearchRoot()).toString()
      )
    }

    /**
     * Gets the value of the `src` attribute.
     */
    string getSourcePath() { result = getAttributeByName("src").getValue() }

    /**
     * Gets the value of the `integrity` attribute.
     */
    string getIntegrityDigest() { result = getAttributeByName("integrity").getValue() }

    /**
     * Gets the folder relative to which the `src` attribute is resolved.
     */
    Folder getSearchRoot() {
      if getSourcePath().matches("/%")
      then result.getBaseName() = ""
      else result = getFile().getParentContainer()
    }

    /**
     * Gets the script referred to by the `src` attribute,
     * if it can be determined.
     */
    Script resolveSource() { result.getFile().getAbsolutePath() = resolveSourcePath() }

    /**
     * Gets the inline script of this script element, if any.
     */
    private InlineScript getInlineScript() {
      toplevel_parent_xml_node(result, this) and
      // the src attribute has precedence
      not exists(getSourcePath())
    }

    /**
     * Gets the script of this element, if it can be determined.
     */
    Script getScript() {
      result = getInlineScript() or
      result = resolveSource()
    }

    override string getAPrimaryQlClass() { result = "HTML::ScriptElement" }
  }

  /**
   * Holds if there is an HTML `<script>` tag with the given `src`
   * such that the script is resolved relative to `root`.
   */
  private predicate scriptSrc(string src, Folder root) {
    exists(ScriptElement script |
      src = script.getSourcePath() and
      root = script.getSearchRoot()
    )
  }

  /**
   * A path string arising from the `src` attribute of a `script` tag.
   */
  private class ScriptSrcPath extends PathString {
    ScriptSrcPath() { scriptSrc(this, _) }

    override Folder getARootFolder() { scriptSrc(this, result) }
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
   *
   * Note that instances of this class are only available if extraction is done with `--html all` or `--experimental`.
   */
  class TextNode extends Locatable, @xmlcharacters {
    TextNode() { exists(FileContainingHtml f | xmlChars(this, _, _, _, _, f)) }

    override string toString() { result = getText() }

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

    override Location getLocation() { xmllocations(this, result) }
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
    CommentNode() { exists(FileContainingHtml f | xmlComments(this, _, _, f)) }

    /** Gets the element in which this comment occurs. */
    Element getParent() { xmlComments(this, _, result, _) }

    /** Gets the text of this comment, not including delimiters. */
    string getText() { result = toString().regexpCapture("(?s)<!--(.*)-->", 1) }

    override string toString() { xmlComments(this, result, _, _) }

    override Location getLocation() { xmllocations(this, result) }
  }
}

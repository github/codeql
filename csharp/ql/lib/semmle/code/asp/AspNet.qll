/**
 * Provides all ASP.NET classes.
 *
 * All ASP.NET elements have the common base class `AspElement`.
 */

import csharp

/**
 * An ASP.NET program element. Either an attribute (`AspAttribute`), an open
 * tag (`AspOpenTag`), a close tag (`AspCloseTag`), a comment (`AspComment`),
 * a directive (`AspDirective`), arbitrary text (`AspText`), or an XML
 * directive (`AspXmlDirective`).
 */
class AspElement extends @asp_element {
  /** Gets the body of this element. */
  string getBody() { asp_element_body(this, result) }

  /** Gets the location of this element. */
  Location getLocation() { asp_elements(this, _, result) }

  /** Gets a textual representation of this element. */
  string toString() { none() }
}

/**
 * An attribute. Either a code block (`AspCode`), a data-binding expression
 * (`AspDataBinding`), or a quoted string (`AspQuotedString`).
 */
class AspAttribute extends AspElement, @asp_attribute { }

/**
 * An open tag, for example the tag on line 1 in
 *
 * ```html
 * <script runat="server">
 *   Label.Text = "Hello, World!";
 * </script>
 * ```
 */
class AspOpenTag extends AspElement, @asp_open_tag {
  /** Either `>` or `/>`, depending on whether it's an empty tag. */
  private string closeAngle() { if isEmpty() then result = "/>" else result = ">" }

  /** Gets the `i`th attribute of this open tag. */
  AspAttribute getAttribute(int i) { asp_tag_attribute(this, i, _, result) }

  /** Gets the attribute named `name`, if any. */
  AspAttribute getAttributeByName(string name) { asp_tag_attribute(this, _, name, result) }

  /** Gets the name of this open tag. */
  string getName() { asp_tag_name(this, result) }

  /** Holds if this open tag has an attribute. */
  predicate hasAttribute() { asp_tag_attribute(this, _, _, _) }

  /** Holds if this open tag is empty. */
  predicate isEmpty() { asp_tag_isempty(this) }

  override string toString() {
    if hasAttribute()
    then result = "<" + getName() + " ..." + closeAngle()
    else result = "<" + getName() + closeAngle()
  }
}

/**
 * A close tag, for example the tag on line 3 in
 *
 * ```html
 * <script runat="server">
 *   Label.Text = "Hello, World!";
 * </script>
 * ```
 */
class AspCloseTag extends AspElement, @asp_close_tag {
  /** Gets the name of this close tag. */
  string getName() { result = getBody() }

  override string toString() { result = "</" + getName() + ">" }
}

/**
 * A code block. Either a block of code (`AspBlockCode`) or inline code
 * (`AspInlineCode`).
 */
class AspCode extends AspAttribute, @asp_code { }

/**
 * A block of code that will be evaluated for its side effects, for example
 * `<% Response.Write(2 + 3) %>`.
 */
class AspBlockCode extends AspCode {
  AspBlockCode() { not asp_code_inline(this) }

  override string toString() { result = "<% ... %>" }
}

/**
 * Inline code, for example `<%= 2 + 3 %>`.
 */
class AspInlineCode extends AspCode {
  AspInlineCode() { asp_code_inline(this) }

  override string toString() { result = "<%= ... %>" }
}

/** A comment, for example `<!-- TODO -->`. */
class AspComment extends AspElement, @asp_comment {
  override string toString() { result = "<!-- ... -->" }
}

/**
 * A comment that will be stripped out on the server, for example
 * `<%-- TODO --%>`.
 */
class AspServerComment extends AspComment {
  AspServerComment() { asp_comment_server(this) }

  override string toString() { result = "<%-- ... --%>" }
}

/**
 * A data-binding expression, for example `<%# myArray %>` in
 *
 * ```html
 * <asp:ListBox id="List1" datasource='<%# myArray %>' runat="server">
 * ```
 */
class AspDataBinding extends AspAttribute, @asp_data_binding {
  override string toString() { result = "<%# ... %>" }
}

/** A directive, for example `<%@ Page Language="C#" %>`. */
class AspDirective extends AspElement, @asp_directive {
  /** Gets the `i`th attribute of this directive. */
  AspAttribute getAttribute(int i) { asp_directive_attribute(this, i, _, result) }

  /** Gets the attribute named `name`, if any. */
  AspAttribute getAttributeByName(string name) { asp_directive_attribute(this, _, name, result) }

  /**
   * Gets the name of this directive, for example `Page` in
   * `<%@ Page Language="C#" %>`.
   */
  string getName() { asp_directive_name(this, result) }

  /** Holds if this directive has an attribute. */
  predicate hasAttribute() { exists(getAttribute(_)) }

  override string toString() {
    if hasAttribute()
    then result = "<%@" + getName() + " ...%>"
    else result = "<%@" + getName() + "%>"
  }
}

/** A quoted string used as an attribute in a tag. */
class AspQuotedString extends AspAttribute, @asp_quoted_string {
  override string toString() {
    if exists(getBody().indexOf("\""))
    then result = "'" + getBody() + "'"
    else result = "\"" + getBody() + "\""
  }
}

/** Arbitrary text. It will be inserted into the document as is. */
class AspText extends AspElement, @asp_text {
  override string toString() { result = getBody() }
}

/** An XML directive, such as a `DOCTYPE` declaration. */
class AspXmlDirective extends AspElement, @asp_xml_directive {
  override string toString() { result = getBody() }
}

/**
 * A 'Page' ASP directive.
 */
class PageDirective extends AspDirective {
  PageDirective() { getName() = "Page" }

  /**
   * Gets the 'CodeBehind' class from which this page inherits.
   */
  ValueOrRefType getInheritedType() { result.getQualifiedName() = getInheritedTypeQualifiedName() }

  private string getInheritedTypeQualifiedName() {
    // Relevant attributes:
    // - `Inherits`: determines the class to inherit from, this is what we want
    // - `ClassName`: determines the name to use for the compiled class, can
    //   provide a fallback namespace if `Inherits` does not have one
    // - `CodeBehindFile`/`CodeFile`: used by tooling, but not semantically
    //   relevant at runtime
    exists(string inherits | inherits = getAttributeByName("Inherits").getBody() |
      if inherits.indexOf(".") != -1
      then result = inherits
      else
        exists(string className | className = getAttributeByName("ClassName").getBody() |
          // take everything up to and including the last .
          className.prefix(className.indexOf(".", count(className.indexOf(".")) - 1, 0) + 1) +
            inherits = result
        )
    )
  }
}

/**
 * An `.aspx` file which is implemented by a 'CodeBehind' class.
 */
class CodeBehindFile extends File {
  CodeBehindFile() {
    getExtension() = "aspx" and
    exists(PageDirective pageDir | pageDir.getLocation().getFile() = this)
  }

  /**
   * Gets the `PageDirective` that defines this page.
   */
  PageDirective getPageDirective() { result.getLocation().getFile() = this }

  /**
   * Gets the 'CodeBehind' class from which this page inherits.
   */
  ValueOrRefType getInheritedType() { result = getPageDirective().getInheritedType() }
}

/**
 * Provides classes and predicates for working with Javadoc documentation.
 */

import semmle.code.Location
import Element

/** A Javadoc parent is an element whose child can be some Javadoc documentation. */
class JavadocParent extends @javadocParent, Top {
  /** Gets a documentation element attached to this parent. */
  JavadocElement getAChild() { result.getParent() = this }

  /** Gets the child documentation element at the specified (zero-based) position. */
  JavadocElement getChild(int index) { result = this.getAChild() and result.getIndex() = index }

  /** Gets the number of documentation elements attached to this parent. */
  int getNumChild() { result = count(getAChild()) }

  /** Gets a documentation element with the specified Javadoc tag name. */
  JavadocTag getATag(string name) { result = this.getAChild() and result.getTagName() = name }

  /*abstract*/ override string toString() { result = "Javadoc" }
}

/** A Javadoc comment. */
class Javadoc extends JavadocParent, @javadoc {
  /** Gets the number of lines in this Javadoc comment. */
  int getNumberOfLines() { result = this.getLocation().getNumberOfCommentLines() }

  /** Gets the value of the `@version` tag, if any. */
  string getVersion() { result = this.getATag("@version").getChild(0).toString() }

  /** Gets the value of the `@author` tag, if any. */
  string getAuthor() { result = this.getATag("@author").getChild(0).toString() }

  override string toString() { result = toStringPrefix() + getChild(0) + toStringPostfix() }

  private string toStringPrefix() {
    if isEolComment(this)
    then result = "//"
    else (
      if isNormalComment(this) then result = "/* " else result = "/** "
    )
  }

  private string toStringPostfix() {
    if isEolComment(this)
    then result = ""
    else (
      if strictcount(getAChild()) = 1 then result = " */" else result = " ... */"
    )
  }

  /** Gets the Java code element that is commented by this piece of Javadoc. */
  Documentable getCommentedElement() { result.getJavadoc() = this }

  override string getAPrimaryQlClass() { result = "Javadoc" }
}

/** A documentable element that can have an attached Javadoc comment. */
class Documentable extends Element, @member {
  /** Gets the Javadoc comment attached to this element. */
  Javadoc getJavadoc() { hasJavadoc(this, result) and not isNormalComment(result) }

  /** Gets the name of the author(s) of this element, if any. */
  string getAuthor() { result = this.getJavadoc().getAuthor() }
}

/** A common super-class for Javadoc elements, which may be either tags or text. */
abstract class JavadocElement extends @javadocElement, Top {
  /** Gets the parent of this Javadoc element. */
  JavadocParent getParent() { javadocTag(this, _, result, _) or javadocText(this, _, result, _) }

  /** Gets the index of this child element relative to its parent. */
  int getIndex() { javadocTag(this, _, _, result) or javadocText(this, _, _, result) }

  /** Gets a printable representation of this Javadoc element. */
  /*abstract*/ override string toString() { result = "Javadoc element" }

  /** Gets the line of text associated with this Javadoc element. */
  abstract string getText();
}

/** A Javadoc block tag. This does not include inline tags. */
class JavadocTag extends JavadocElement, JavadocParent, @javadocTag {
  /** Gets the name of this Javadoc tag. */
  string getTagName() { javadocTag(this, result, _, _) }

  /** Gets a printable representation of this Javadoc tag. */
  override string toString() { result = this.getTagName() }

  /** Gets the text associated with this Javadoc tag. */
  override string getText() { result = this.getChild(0).toString() }

  override string getAPrimaryQlClass() { result = "JavadocTag" }
}

/** A Javadoc `@param` tag. */
class ParamTag extends JavadocTag {
  ParamTag() { this.getTagName() = "@param" }

  /** Gets the name of the parameter. */
  string getParamName() { result = this.getChild(0).toString() }

  /** Gets the documentation for the parameter. */
  override string getText() { result = this.getChild(1).toString() }
}

/** A Javadoc `@throws` or `@exception` tag. */
class ThrowsTag extends JavadocTag {
  ThrowsTag() { this.getTagName() = "@throws" or this.getTagName() = "@exception" }

  /** Gets the name of the exception. */
  string getExceptionName() { result = this.getChild(0).toString() }

  /** Gets the documentation for the exception. */
  override string getText() { result = this.getChild(1).toString() }
}

/** A Javadoc `@see` tag. */
class SeeTag extends JavadocTag {
  SeeTag() { getTagName() = "@see" }

  /** Gets the name of the entity referred to. */
  string getReference() { result = getChild(0).toString() }
}

/** A Javadoc `@author` tag. */
class AuthorTag extends JavadocTag {
  AuthorTag() { this.getTagName() = "@author" }

  /** Gets the name of the author. */
  string getAuthorName() { result = this.getChild(0).toString() }
}

/** A piece of Javadoc text. */
class JavadocText extends JavadocElement, @javadocText {
  /** Gets the Javadoc comment that contains this piece of text. */
  Javadoc getJavadoc() { result.getAChild+() = this }

  /** Gets the text itself. */
  override string getText() { javadocText(this, result, _, _) }

  /** Gets a printable representation of this Javadoc element. */
  override string toString() { result = this.getText() }

  override string getAPrimaryQlClass() { result = "JavadocText" }
}

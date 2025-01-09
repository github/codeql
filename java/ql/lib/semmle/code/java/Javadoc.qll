/**
 * Provides classes and predicates for working with Javadoc documentation.
 */
overlay[local?]
module;

import semmle.code.Location
private import semmle.code.java.Overlay

/** A Javadoc parent is an element whose child can be some Javadoc documentation. */
class JavadocParent extends @javadocParent, Top {
  /** Gets a documentation element attached to this parent. */
  JavadocElement getAChild() { result.getParent() = this }

  /** Gets the child documentation element at the specified (zero-based) position. */
  JavadocElement getChild(int index) { result = this.getAChild() and result.getIndex() = index }

  /** Gets the number of documentation elements attached to this parent. */
  int getNumChild() { result = count(this.getAChild()) }

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

  override string toString() {
    exists(string childStr |
      if exists(this.getChild(0)) then childStr = this.getChild(0).toString() else childStr = ""
    |
      result = this.toStringPrefix() + childStr + this.toStringPostfix()
    )
  }

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
      if strictcount(this.getAChild()) > 1 then result = " ... */" else result = " */"
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
  SeeTag() { this.getTagName() = "@see" }

  /** Gets the name of the entity referred to. */
  string getReference() { result = this.getChild(0).toString() }
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

/** A Kotlin comment. */
class KtComment extends Top, @ktcomment {
  /** Gets the full text of this comment. */
  string getText() { ktComments(this, _, result) }

  /** Holds if this comment is an EOL comment. */
  predicate isEolComment() { ktComments(this, 1, _) }

  /** Holds if this comment is a block comment. */
  predicate isBlockComment() { ktComments(this, 2, _) }

  /** Holds if this comment is a KDoc comment. */
  predicate isDocComment() { ktComments(this, 3, _) }

  /** Gets the sections of this comment. */
  KtCommentSection getSections() { ktCommentSections(result, this, _) }

  /** Gets the owner of this comment, if any. */
  Top getOwner() { ktCommentOwners(this, result) }

  override string toString() { result = this.getText() }

  override string getAPrimaryQlClass() { result = "KtComment" }
}

/** A Kotlin comment. */
class KtCommentSection extends @ktcommentsection {
  /** Gets the content text of this section. */
  string getContent() { ktCommentSections(this, _, result) }

  /** Gets the parent comment. */
  KtComment getParent() { ktCommentSections(this, result, _) }

  /** Gets the section name if any. */
  string getName() { ktCommentSectionNames(this, result) }

  /** Gets the section subject name if any. */
  string getSubjectName() { ktCommentSectionSubjectNames(this, result) }

  /** Gets the string representation of this section. */
  string toString() { result = this.getContent() }
}

overlay[local]
private predicate discardableJavadoc(string file, @javadoc d) {
  not isOverlay() and
  exists(@member m | file = getRawFile(m) and hasJavadoc(m, d))
}

/** Discard javadoc entities in files fully extracted in the overlay. */
overlay[discard_entity]
private predicate discardJavadoc(@javadoc d) {
  exists(string file | discardableJavadoc(file, d) and extractedInOverlay(file))
}

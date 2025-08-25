/** Classes representing documentation comments. */

import csharp

private class SourceDeclaration extends Declaration {
  SourceDeclaration() { this.isSourceDeclaration() }
}

/** A parameter that has come from source code. */
class SourceParameter extends SourceDeclaration, Parameter { }

/** A method that has come from source code. */
class SourceMethod extends SourceDeclaration, Method { }

/** A constructor that is in the source code and not compiler-generated. */
class SourceConstructor extends SourceDeclaration, Constructor {
  SourceConstructor() { this.getAChild() instanceof BlockStmt }
}

/** A method or constructor from source code. */
class SourceMethodOrConstructor extends SourceDeclaration, Callable {
  SourceMethodOrConstructor() {
    this instanceof SourceMethod or
    this instanceof SourceConstructor
  }
}

/** Gets an XML comment bound to this declaration. */
XmlCommentLine getADeclarationXmlComment(Declaration d) {
  result = getADeclarationCommentBlock(d).getAChild()
}

/** Gets a comment block bound to this declaration. */
CommentBlock getADeclarationCommentBlock(Declaration d) {
  // getAfter() is slightly more relaxed than getElement(),
  // because sometimes CommentBlocks
  // get split up or don't have spaces before them so aren't
  // automatically attributed to the declaration.
  result.getAfter() = d
}

/** Whether the declaration has a documentation comment. */
predicate declarationHasXmlComment(Declaration d) { exists(getADeclarationXmlComment(d)) }

/** Whether a declaration should have documentation. */
predicate isDocumentationNeeded(Modifiable decl) {
  decl.isUnboundDeclaration() and // Exclude constructed types and methods
  not exists(Attribute a |
    a = decl.(Attributable).getAnAttribute() and
    not a.getType().hasFullyQualifiedName("System.Runtime.CompilerServices", _)
  ) and // An attribute may serve to document
  decl.isPublic() and
  (
    // The documentation of the overridden method (e.g. in an interface) is sufficient.
    exists(SourceMethod m | decl = m | not m.overrides())
    or
    exists(ValueOrRefType t | decl = t | t.fromSource())
    or
    decl instanceof SourceConstructor
  )
}

/** An XML comment containing a `<returns>` tag. */
class ReturnsXmlComment extends XmlCommentLine {
  ReturnsXmlComment() { this.getOpenTag(_) = "returns" }

  /** Holds if the element in this comment has a body at offset `offset`. */
  predicate hasBody(int offset) { this.hasBody("returns", offset) }

  /** Holds if the element in this comment is an opening tag at offset `offset`. */
  predicate isOpenTag(int offset) { "returns" = this.getOpenTag(offset) }

  /** Holds if the element in this comment is an empty tag at offset `offset`. */
  predicate isEmptyTag(int offset) { "returns" = this.getEmptyTag(offset) }
}

/** An XML comment containing an `<exception>` tag. */
class ExceptionXmlComment extends XmlCommentLine {
  ExceptionXmlComment() { this.getOpenTag(_) = "exception" }

  /** Gets a `cref` attribute at offset `offset`, if any. */
  string getCref(int offset) { result = this.getAttribute("exception", "cref", offset) }

  /** Holds if the element in this comment has a body at offset `offset`. */
  predicate hasBody(int offset) { this.hasBody("exception", offset) }
}

/** An XML comment containing a `<param>` tag. */
class ParamXmlComment extends XmlCommentLine {
  ParamXmlComment() { this.getOpenTag(_) = "param" }

  /** Gets the name of this parameter at offset `offset`. */
  string getName(int offset) { this.getAttribute("param", "name", offset) = result }

  /** Holds if the element in this comment has a body at offset `offset`. */
  predicate hasBody(int offset) { this.hasBody("param", offset) }
}

/** An XML comment containing a `<typeparam>` tag. */
class TypeparamXmlComment extends XmlCommentLine {
  TypeparamXmlComment() { this.getOpenTag(_) = "typeparam" }

  /** Gets the `name` attribute of this element at offset `offset`. */
  string getName(int offset) { this.getAttribute("typeparam", "name", offset) = result }

  /** Holds if the element in this comment has a body at offset `offset`. */
  predicate hasBody(int offset) { this.hasBody("typeparam", offset) }
}

/** An XML comment containing a `<summary>` tag. */
class SummaryXmlComment extends XmlCommentLine {
  SummaryXmlComment() { this.getOpenTag(_) = "summary" }

  /** Holds if the element in this comment has a body at offset `offset`. */
  predicate hasBody(int offset) { this.hasBody("summary", offset) }

  /** Holds if the element in this comment has an open tag at offset `offset`. */
  predicate isOpenTag(int offset) { "summary" = this.getOpenTag(offset) }

  /** Holds if the element in this comment is empty at offset `offset`. */
  predicate isEmptyTag(int offset) { "summary" = this.getEmptyTag(offset) }
}

/** An XML comment containing an `<inheritdoc>` tag. */
class InheritDocXmlComment extends XmlCommentLine {
  InheritDocXmlComment() { this.getOpenTag(_) = "inheritdoc" }
}

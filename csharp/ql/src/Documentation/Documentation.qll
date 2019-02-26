import csharp

class SourceDeclaration extends Declaration {
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
XmlComment getADeclarationXmlComment(Declaration d) {
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
  decl.getSourceDeclaration() = decl and // Exclude constructed types and methods
  not exists(decl.(Attributable).getAnAttribute()) and // An attribute may serve to document
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
class ReturnsXmlComment extends XmlComment {
  ReturnsXmlComment() { getOpenTag(_) = "returns" }

  predicate hasBody(int offset) { hasBody("returns", offset) }

  predicate isOpenTag(int offset) { "returns" = getOpenTag(offset) }

  predicate isEmptyTag(int offset) { "returns" = getEmptyTag(offset) }
}

/** An XML comment containing an `<exception>` tag. */
class ExceptionXmlComment extends XmlComment {
  ExceptionXmlComment() { getOpenTag(_) = "exception" }

  string getCref(int offset) { result = getAttribute("exception", "cref", offset) }

  predicate hasBody(int offset) { hasBody("exception", offset) }
}

/** An XML comment containing a `<param>` tag. */
class ParamXmlComment extends XmlComment {
  ParamXmlComment() { getOpenTag(_) = "param" }

  string getName(int offset) { getAttribute("param", "name", offset) = result }

  predicate hasBody(int offset) { hasBody("param", offset) }
}

/** An XML comment containing a `<typeparam>` tag. */
class TypeparamXmlComment extends XmlComment {
  TypeparamXmlComment() { getOpenTag(_) = "typeparam" }

  string getName(int offset) { getAttribute("typeparam", "name", offset) = result }

  predicate hasBody(int offset) { hasBody("typeparam", offset) }
}

/** An XML comment containing a `<summary>` tag. */
class SummaryXmlComment extends XmlComment {
  SummaryXmlComment() { getOpenTag(_) = "summary" }

  predicate hasBody(int offset) { hasBody("summary", offset) }

  predicate isOpenTag(int offset) { "summary" = getOpenTag(offset) }

  predicate isEmptyTag(int offset) { "summary" = getEmptyTag(offset) }
}

/** An XML comment containing an `<inheritdoc>` tag. */
class InheritDocXmlComment extends XmlComment {
  InheritDocXmlComment() { getOpenTag(_) = "inheritdoc" }
}

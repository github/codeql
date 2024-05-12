private import codeql.ruby.AST
private import internal.Erb
private import internal.TreeSitter

/**
 * A node in the ERB abstract syntax tree. This class is the base class for all
 * ERB elements.
 */
class ErbAstNode extends TAstNode {
  /** Gets a textual representation of this node. */
  cached
  string toString() { none() }

  /** Gets the location of this node. */
  Location getLocation() { result = getLocation(this) }

  /**
   * Gets the name of a primary CodeQL class to which this node belongs.
   *
   * This predicate always has a result. If no primary class can be
   * determined, the result is `"???"`. If multiple primary classes match,
   * this predicate can have multiple results.
   */
  string getAPrimaryQlClass() { result = "???" }
}

/**
 * An ERB template. This can contain multiple directives to be executed when
 * the template is compiled.
 */
class ErbTemplate extends TTemplate, ErbAstNode {
  private Erb::Template g;

  ErbTemplate() { this = TTemplate(g) }

  override string toString() { result = "erb template" }

  final override string getAPrimaryQlClass() { result = "ErbTemplate" }

  /** Gets a child node, if any. */
  ErbAstNode getAChildNode() { toGenerated(result) = g.getChild(_) }
}

// Truncate the token string value to 32 char max
bindingset[val]
private string displayToken(string val) {
  val.length() <= 32 and result = val
  or
  val.length() > 32 and result = val.prefix(29) + "..."
}

/**
 * An ERB token. This could be embedded code, a comment, or arbitrary text.
 */
class ErbToken extends TTokenNode, ErbAstNode {
  override string toString() { result = displayToken(this.getValue()) }

  /** Gets the string value of this token. */
  string getValue() { exists(Erb::Token g | this = fromGenerated(g) | result = g.getValue()) }

  override string getAPrimaryQlClass() { result = "ErbToken" }
}

/**
 * An ERB token appearing within a comment directive.
 */
class ErbComment extends ErbToken {
  private Erb::Comment g;

  ErbComment() { this = TComment(g) }

  override string getValue() { result = g.getValue() }

  final override string getAPrimaryQlClass() { result = "ErbComment" }
}

/**
 * An ERB token appearing within a code directive. This will typically be
 * interpreted as Ruby code or a GraphQL query, depending on context.
 */
class ErbCode extends ErbToken {
  private Erb::Code g;

  ErbCode() { this = TCode(g) }

  override string getValue() { result = g.getValue() }

  final override string getAPrimaryQlClass() { result = "ErbCode" }
}

bindingset[line, col]
private predicate locationIncludesPosition(Location loc, int line, int col) {
  // position between start and end line, exclusive
  line > loc.getStartLine() and
  line < loc.getEndLine()
  or
  // position on start line, multi line location
  line = loc.getStartLine() and
  not loc.getStartLine() = loc.getEndLine() and
  col >= loc.getStartColumn()
  or
  // position on end line, multi line location
  line = loc.getEndLine() and
  not loc.getStartLine() = loc.getEndLine() and
  col <= loc.getEndColumn()
  or
  // single line location, position between start and end column
  line = loc.getStartLine() and
  loc.getStartLine() = loc.getEndLine() and
  col >= loc.getStartColumn() and
  col <= loc.getEndColumn()
}

/** A file containing an ERB directive. */
private class ErbDirectiveFile extends File {
  pragma[nomagic]
  ErbDirectiveFile() { this = any(ErbDirective dir).getLocation().getFile() }

  /** Gets a statement in this file. */
  pragma[nomagic]
  AstNode getAnAstNode(int startLine, int startColumn) {
    exists(Location loc |
      result.getLocation() = loc and
      loc.getFile() = this and
      loc.getStartLine() = startLine and
      loc.getStartColumn() = startColumn
    )
  }
}

/**
 * A directive in an ERB template.
 */
class ErbDirective extends TDirectiveNode, ErbAstNode {
  /** Holds if this directive spans line `line` in the file `file`. */
  pragma[nomagic]
  private predicate spans(ErbDirectiveFile file, int line) {
    exists(Location loc |
      loc = this.getLocation() and
      file = loc.getFile() and
      line in [loc.getStartLine() .. loc.getEndLine()]
    )
  }

  private predicate containsAstNodeStart(AstNode s) {
    // `Toplevel` statements are not contained within individual directives,
    // though their start location may appear within a directive location
    not s instanceof Toplevel and
    exists(ErbDirectiveFile file, int startLine, int startColumn |
      this.spans(file, startLine) and
      s = file.getAnAstNode(startLine, startColumn) and
      locationIncludesPosition(this.getLocation(), startLine, startColumn)
    )
  }

  /**
   * Gets a statement that starts in directive that is not a child of any other
   * statement starting in this directive.
   */
  cached
  Stmt getAChildStmt() {
    this.containsAstNodeStart(result) and
    not this.containsAstNodeStart(result.getParent())
  }

  /**
   * Gets the last child statement in this directive.
   * See `getAChildStmt` for more details.
   */
  Stmt getTerminalStmt() {
    result = this.getAChildStmt() and
    forall(Stmt s | s = this.getAChildStmt() and not s = result |
      s.getLocation().strictlyBefore(result.getLocation())
    )
  }

  /** Gets the child token of this directive. */
  ErbToken getToken() {
    exists(Erb::Directive g | this = fromGenerated(g) | toGenerated(result) = g.getChild())
  }

  override string toString() { result = "erb directive" }

  override string getAPrimaryQlClass() { result = "ErbDirective" }
}

/**
 * A comment directive in an ERB template.
 * ```erb
 * <%#= 2 + 2 %>
 * <%# for x in xs do %>
 * ```
 */
class ErbCommentDirective extends ErbDirective {
  private Erb::CommentDirective g;

  ErbCommentDirective() { this = TCommentDirective(g) }

  override ErbComment getToken() { toGenerated(result) = g.getChild() }

  final override string toString() {
    result = "<%#" + this.getToken().toString() + "%>"
    or
    not exists(this.getToken()) and result = "<%#%>"
  }

  final override string getAPrimaryQlClass() { result = "ErbCommentDirective" }
}

/**
 * A GraphQL directive in an ERB template.
 * ```erb
 * <%graphql
 *   fragment Foo on Bar {
 *     some {
 *       queryText
 *       moreProperties
 *     }
 *   }
 * %>
 * ```
 */
class ErbGraphqlDirective extends ErbDirective {
  private Erb::GraphqlDirective g;

  ErbGraphqlDirective() { this = TGraphqlDirective(g) }

  override ErbCode getToken() { toGenerated(result) = g.getChild() }

  final override string toString() {
    result = "<%graphql" + this.getToken().toString() + "%>"
    or
    not exists(this.getToken()) and result = "<%graphql%>"
  }

  final override string getAPrimaryQlClass() { result = "ErbGraphqlDirective" }
}

/**
 * An output directive in an ERB template.
 * ```erb
 * <%=
 *   fragment Foo on Bar {
 *     some {
 *       queryText
 *       moreProperties
 *     }
 *   }
 * %>
 * ```
 */
class ErbOutputDirective extends ErbDirective {
  private Erb::OutputDirective g;

  ErbOutputDirective() { this = TOutputDirective(g) }

  override ErbCode getToken() { toGenerated(result) = g.getChild() }

  /**
   * Holds if this is a raw Erb output directive.
   * ```erb
   * <%== foo %>
   * ```
   */
  predicate isRaw() {
    exists(Erb::Token t | t.getParentIndex() = 0 and t.getParent() = g and t.getValue() = "<%==")
  }

  final override string toString() {
    this.isRaw() and
    (
      result = "<%==" + this.getToken().toString() + "%>"
      or
      not exists(this.getToken()) and result = "<%==%>"
    )
    or
    not this.isRaw() and
    (
      result = "<%=" + this.getToken().toString() + "%>"
      or
      not exists(this.getToken()) and result = "<%=%>"
    )
  }

  final override string getAPrimaryQlClass() { result = "ErbOutputDirective" }
}

/**
 * An execution directive in an ERB template.
 * This code will be executed as Ruby, but not rendered.
 * ```erb
 * <% books = author.books
 *    for book in books do %>
 * ```
 */
class ErbExecutionDirective extends ErbDirective {
  private Erb::Directive g;

  ErbExecutionDirective() { this = TDirective(g) }

  final override string toString() {
    result = "<%" + this.getToken().toString() + "%>"
    or
    not exists(this.getToken()) and result = "<%-%>"
  }

  final override string getAPrimaryQlClass() { result = "ErbExecutionDirective" }
}

/**
 * A `File` containing an Embedded Ruby template.
 * This is typically a file containing snippets of Ruby code that can be
 * evaluated to create a compiled version of the file.
 */
class ErbFile extends File {
  private ErbTemplate template;

  ErbFile() { this = template.getLocation().getFile() }

  /**
   * Holds if the file represents a partial to be rendered in the context of
   * another template.
   */
  predicate isPartial() { this.getStem().charAt(0) = "_" }

  /**
   * Gets the base template name associated with this ERB file.
   * For instance, a file named `foo.html.erb` has a template name of `foo`.
   * A partial template file named `_item.html.erb` has a template name of `item`.
   */
  string getTemplateName() { none() }

  /**
   * Gets the erb template contained within this file.
   */
  ErbTemplate getTemplate() { result = template }
}

private class PartialErbFile extends ErbFile {
  PartialErbFile() { this.isPartial() }

  // Drop the leading underscore
  override string getTemplateName() { result = this.getStem().splitAt(".", 0).suffix(1) }
}

private class FullErbFile extends ErbFile {
  FullErbFile() { not this.isPartial() }

  override string getTemplateName() { result = this.getStem().splitAt(".", 0) }
}

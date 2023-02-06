/**
 * Provides classes for working with code comments.
 */

import go

/**
 * A code comment.
 *
 * Examples:
 *
 * <pre>
 * // a line comment
 * /* a block
 *   comment *&#47
 * </pre>
 */
class Comment extends @comment, AstNode {
  /**
   * Gets the text of this comment, not including delimiters.
   */
  string getText() { comments(this, _, _, _, result) }

  /**
   * Gets the comment group to which this comment belongs.
   */
  CommentGroup getGroup() { this = result.getAComment() }

  override string toString() { result = "comment" }

  override string getAPrimaryQlClass() { result = "Comment" }
}

/**
 * A comment group, that is, a sequence of comments without any intervening tokens or
 * empty lines.
 *
 * Examples:
 *
 * <pre>
 * // a line comment
 * // another line comment
 *
 * // a line comment
 * /* a block
 *   comment *&#47
 *
 * /* a block
 * comment *&#47
 * /* another block comment *&#47
 * </pre>
 */
class CommentGroup extends @comment_group, AstNode {
  /**
   * Gets the file to which this comment group belongs.
   */
  override File getParent() { this = result.getACommentGroup() }

  /** Gets the `i`th comment in this group (0-based indexing). */
  Comment getComment(int i) { comments(result, _, this, i, _) }

  /** Gets a comment in this group. */
  Comment getAComment() { result = this.getComment(_) }

  /** Gets the number of comments in this group. */
  int getNumComment() { result = count(this.getAComment()) }

  override string toString() { result = "comment group" }

  override string getAPrimaryQlClass() { result = "CommentGroup" }
}

/**
 * A program element to which a documentation comment group may be attached:
 * a file, a field, a specifier, a generic declaration, a function declaration
 * or a go.mod expression.
 *
 * Examples:
 *
 * ```go
 * // function documentation
 * func double(x int) int { return 2 * x }
 *
 * // generic declaration documentation
 * const (
 *   // specifier documentation
 *   size int64 = 1024
 *   eof        = -1 // not specifier documentation
 * )
 * ```
 */
class Documentable extends AstNode, @documentable {
  /** Gets the documentation comment group attached to this element, if any. */
  DocComment getDocumentation() { this = result.getDocumentedElement() }
}

/**
 * A comment group that is attached to a program element as documentation.
 *
 * Examples:
 *
 * ```go
 * // function documentation
 * func double(x int) int { return 2 * x }
 *
 * // generic declaration documentation
 * const (
 *   // specifier documentation
 *   size int64 = 1024
 *   eof        = -1 // not specifier documentation
 * )
 * ```
 */
class DocComment extends CommentGroup {
  Documentable node;

  DocComment() { doc_comments(node, this) }

  /** Gets the program element documented by this comment group. */
  Documentable getDocumentedElement() { result = node }

  override string getAPrimaryQlClass() { result = "DocComment" }
}

/**
 * A single-line comment starting with `//`.
 *
 * Examples:
 *
 * ```go
 * // Single line comment
 * ```
 */
class SlashSlashComment extends @slashslashcomment, Comment {
  override string getAPrimaryQlClass() { result = "SlashSlashComment" }
}

/**
 * A block comment starting with `/*` and ending with <code>*&#47;</code>.
 *
 * Examples:
 *
 * <pre>
 * /* a block
 *   comment *&#47
 * </pre>
 */
class SlashStarComment extends @slashstarcomment, Comment {
  override string getAPrimaryQlClass() { result = "SlashStarComment" }
}

/**
 * A single-line comment starting with `//`.
 *
 * Examples:
 *
 * ```go
 * // Single line comment
 * ```
 */
class LineComment = SlashSlashComment;

/**
 * A block comment starting with `/*` and ending with <code>*&#47;</code>.
 *
 * Examples:
 *
 * <pre>
 * /* a block
 *   comment *&#47
 * </pre>
 */
class BlockComment = SlashStarComment;

/** Holds if `c` starts at `line`, `col` in `f`, and precedes the package declaration. */
private predicate isInitialComment(Comment c, File f, int line, int col) {
  c.hasLocationInfo(f.getAbsolutePath(), line, col, _, _) and
  line < f.getPackageNameExpr().getLocation().getStartLine()
}

/** Gets the `i`th initial comment in `f` (0-based). */
private Comment getInitialComment(File f, int i) {
  result =
    rank[i + 1](Comment c, int line, int col |
      isInitialComment(c, f, line, col)
    |
      c order by line, col
    )
}

/**
 * A build constraint comment of the form `// +build ...` or `//go:build ...`.
 *
 * Examples:
 *
 * ```go
 * // +build darwin freebsd netbsd openbsd
 * // +build !linux
 * ```
 */
class BuildConstraintComment extends LineComment {
  BuildConstraintComment() {
    // a line comment preceding the package declaration, itself only preceded by
    // line comments
    exists(File f, int i |
      // correctness of the placement of the build constraint is not checked here;
      // this is more lax than the actual rules for build constraints
      this = getInitialComment(f, i) and
      not getInitialComment(f, [0 .. i - 1]) instanceof BlockComment
    ) and
    (
      // comment text starts with `+build` or `go:build`
      this.getText().regexpMatch("\\s*\\+build.*")
      or
      this.getText().regexpMatch("\\s*go:build.*")
    )
  }

  override string getAPrimaryQlClass() { result = "BuildConstraintComment" }

  /** Gets the body of this build constraint. */
  string getConstraintBody() { result = this.getText().splitAt("build ", 1) }

  /** Gets a disjunct of this build constraint. */
  string getADisjunct() { result = this.getConstraintBody().splitAt(" ") }
}

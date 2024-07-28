/** Provides classes for working with JavaScript comments. */

import javascript

/**
 * A JavaScript source-code comment.
 *
 * Examples:
 *
 * <pre>
 * // a line comment
 * /* a block
 *   comment *&#47
 * &lt;!-- an HTML line comment
 * </pre>
 */
class Comment extends @comment, Locatable {
  /** Gets the toplevel element this comment belongs to. */
  TopLevel getTopLevel() { comments(this, _, result, _, _) }

  /** Gets the text of this comment, not including delimiters. */
  string getText() { comments(this, _, _, result, _) }

  /** Gets the `i`th line of comment text. */
  string getLine(int i) { result = this.getText().splitAt("\n", i) }

  /** Gets the next token after this comment. */
  Token getNextToken() { next_token(this, result) }

  override int getNumLines() { result = count(this.getLine(_)) }

  override string toString() { comments(this, _, _, _, result) }

  /** Holds if this comment spans lines `start` to `end` (inclusive) in file `f`. */
  predicate onLines(File f, int start, int end) {
    exists(Location loc | loc = this.getLocation() |
      f = loc.getFile() and
      start = loc.getStartLine() and
      end = loc.getEndLine()
    )
  }
}

/**
 * A line comment, that is, either an HTML comment or a `//` comment.
 *
 * Examples:
 *
 * <pre>
 * // a line comment
 * &lt;!-- an HTML line comment
 * </pre>
 */
class LineComment extends @line_comment, Comment { }

/**
 * An HTML comment start/end token interpreted as a line comment.
 *
 * Example:
 *
 * ```
 * &lt;!-- an HTML line comment
 * --> also an HTML line comment
 * ```
 */
class HtmlLineComment extends @html_comment, LineComment { }

/**
 * An HTML comment start token interpreted as a line comment.
 *
 * Example:
 *
 * ```
 * &lt;!-- an HTML line comment
 * ```
 */
class HtmlCommentStart extends @html_comment_start, HtmlLineComment { }

/**
 * An HTML comment end token interpreted as a line comment.
 *
 * Example:
 *
 * ```
 * --> also an HTML line comment
 * ```
 */
class HtmlCommentEnd extends @htmlcommentend, HtmlLineComment { }

/**
 * A `//` comment.
 *
 * Example:
 *
 * ```
 * // a line comment
 * ```
 */
class SlashSlashComment extends @slashslash_comment, LineComment { }

/**
 * A block comment (which may be a JSDoc comment).
 *
 * Examples:
 *
 * <pre>
 * /* a block comment
 *   (but not a JSDoc comment) *&#47;
 * /** a JSDoc comment *&#47;
 * </pre>
 */
class BlockComment extends @block_comment, Comment { }

/**
 * A C-style block comment which is not a JSDoc comment.
 *
 * Example:
 *
 * <pre>
 * /* a block comment
 *   (but not a JSDoc comment) *&#47;
 * </pre>
 */
class SlashStarComment extends @slashstar_comment, BlockComment { }

/**
 * A JSDoc comment.
 *
 * Example:
 *
 * <pre>
 * /** a JSDoc comment *&#47;
 * </pre>
 */
class DocComment extends @doc_comment, BlockComment { }

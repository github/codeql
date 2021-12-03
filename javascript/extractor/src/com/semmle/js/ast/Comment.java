package com.semmle.js.ast;

import static com.semmle.js.ast.Comment.Kind.BLOCK;
import static com.semmle.js.ast.Comment.Kind.HTML_END;
import static com.semmle.js.ast.Comment.Kind.HTML_START;
import static com.semmle.js.ast.Comment.Kind.LINE;

/**
 * A source code comment.
 *
 * <p>This is not part of the SpiderMonkey AST format.
 */
public class Comment extends SourceElement {
  /** The kinds of comments recognized by the parser. */
  public static enum Kind {
    /** A C++-style line comment starting with two slashes. */
    LINE,

    /** A C-style block comment starting with slash-star and ending with star-slash. */
    BLOCK,

    /** The start of an HTML comment (<code>&lt;!--</code>). */
    HTML_START,

    /** The end of an HTML comment (<code>--&gt;</code>). */
    HTML_END
  };

  private final String text;
  private final Kind kind;

  public Comment(SourceLocation loc, String text) {
    super(loc);
    this.text = text;
    String raw = getLoc().getSource();
    if (raw.startsWith("//")) this.kind = LINE;
    else if (raw.startsWith("/*")) this.kind = BLOCK;
    else if (raw.startsWith("<!--")) this.kind = HTML_START;
    else this.kind = HTML_END;
  }

  /** What kind of comment is this? */
  public Kind getKind() {
    return kind;
  }

  /** Is this a JSDoc documentation comment? */
  public boolean isDocComment() {
    return kind == BLOCK && text.startsWith("*");
  }

  /**
   * The text of the comment, not including its delimiters.
   *
   * <p>For documentation comments, the leading asterisk is included.
   */
  public String getText() {
    return text;
  }
}

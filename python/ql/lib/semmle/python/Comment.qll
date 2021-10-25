/**
 * Provides classes representing comments in Python.
 */

import python

/** A source code comment */
class Comment extends @py_comment {
  /** Gets the full text of the comment including the leading '#' */
  string getText() { py_comments(this, result, _) }

  /** Gets the contents of the comment excluding the leading '#' */
  string getContents() { result = this.getText().suffix(1) }

  Location getLocation() { py_comments(this, _, result) }

  /** Gets a textual representation of this element. */
  string toString() { result = "Comment " + this.getText() }

  /**
   * Gets this immediately following comment.
   * Blanks line are allowed between this comment and the following comment,
   * but code or other comments are not.
   */
  Comment getFollowing() {
    exists(File f, int n | this.file_line(f, n) |
      result.file_line(f, n + 1)
      or
      result.file_line(f, n + 2) and f.emptyLine(n + 1)
      or
      result.file_line(f, n + 3) and f.emptyLine(n + 2) and f.emptyLine(n + 1)
    )
  }

  private predicate file_line(File f, int n) {
    this.getLocation().getFile() = f and
    this.getLocation().getStartLine() = n
  }
}

private predicate comment_block_part(Comment start, Comment part, int i) {
  not exists(Comment prev | prev.getFollowing() = part) and
  exists(Comment following | part.getFollowing() = following) and
  start = part and
  i = 1
  or
  exists(Comment prev |
    comment_block_part(start, prev, i - 1) and
    part = prev.getFollowing()
  )
}

/** A block of consecutive comments */
class CommentBlock extends @py_comment {
  CommentBlock() { comment_block_part(this, _, _) }

  private Comment last() { comment_block_part(this, result, this.length()) }

  /** Gets a textual representation of this element. */
  string toString() { result = "Comment block" }

  /** The length of this comment block (in comments) */
  int length() { result = max(int i | comment_block_part(this, _, i)) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.(Comment).getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _) and
    exists(Comment end | end = this.last() |
      end.getLocation().hasLocationInfo(_, _, _, endline, endcolumn)
    )
  }

  /** Holds if this comment block contains `c`. */
  predicate contains(Comment c) {
    comment_block_part(this, c, _)
    or
    this = c
  }

  /** Gets a string representation of this comment block. */
  string getContents() {
    result =
      concat(Comment c, int i |
        comment_block_part(this, c, i)
        or
        this = c and i = 0
      |
        c.getContents() order by i
      )
  }
}

/** A type-hint comment. Any comment that starts with `# type:` */
class TypeHintComment extends Comment {
  TypeHintComment() { this.getText().regexpMatch("# +type:.*") }
}

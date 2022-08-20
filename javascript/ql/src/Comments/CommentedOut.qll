/** Provides predicates for recognizing commented-out code. */

import semmle.javascript.Comments

/** Gets a line in comment `c` that looks like commented-out code. */
private string getALineOfCommentedOutCode(Comment c) {
  result = c.getLine(_) and
  // line ends with ';', '{', or '}', optionally followed by a comma,
  (
    result.regexpMatch(".*[;{}],?\\s*") and
    // but it doesn't look like a JSDoc-like annotation
    not result.regexpMatch(".*@\\w+\\s*\\{.*\\}\\s*") and
    // and it does not contain three consecutive words (which is uncommon in code)
    not result.regexpMatch("[^'\\\"]*\\w\\s++\\w++\\s++\\w[^'\\\"]*")
    or
    // line is part of a block comment and ends with something that looks
    // like a line comment; character before '//' must not be ':' to
    // avoid matching URLs
    not c instanceof SlashSlashComment and
    result.regexpMatch("(.*[^:]|^)//.*[^/].*")
    or
    // similar, but don't be fooled by '//// this kind of comment' and
    // '//// this kind of comment ////'
    c instanceof SlashSlashComment and
    result.regexpMatch("/*([^/].*[^:]|[^:/])//.*[^/].*") and
    // exclude externalization comments
    not result.regexpMatch(".*\\$NON-NLS-\\d+\\$.*")
  )
}

/**
 * Holds if `c` is a comment containing code examples, and hence should be
 * disregarded when looking for commented-out code.
 */
private predicate containsCodeExample(Comment c) {
  c.getText().matches(["%<pre>%</pre>%", "%<code>%</code>%", "%@example%", "%```%"])
}

/**
 * Gets a comment that belongs to a run of consecutive comments in file `f`
 * starting with `c`, where `c` itself contains commented-out code, but the comment
 * preceding it, if any, does not.
 */
private Comment getCommentInRun(File f, Comment c) {
  exists(int n |
    c.onLines(f, n, _) and
    countCommentedOutLines(c) > 0 and
    not exists(Comment d | d.onLines(f, _, n - 1) | countCommentedOutLines(d) > 0)
  ) and
  (
    result = c
    or
    exists(Comment prev, int n |
      prev = getCommentInRun(f, c) and
      prev.onLines(f, _, n) and
      result.onLines(f, n + 1, _)
    )
  )
}

/**
 * Gets a comment that follows `c` in a run of consecutive comments and
 * does not contain a code example.
 */
private Comment getRelevantCommentInRun(Comment c) {
  result = getCommentInRun(_, c) and not containsCodeExample(result)
}

/** Gets the number of lines in comment `c` that look like commented-out code. */
private int countCommentedOutLines(Comment c) { result = count(getALineOfCommentedOutCode(c)) }

/** Gets the number of non-blank lines in comment `c`. */
private int countNonBlankLines(Comment c) {
  result = count(string line | line = c.getLine(_) and not line.regexpMatch("\\s*"))
}

/**
 * Gets the number of lines in comment `c` and subsequent comments that look like
 * they contain commented-out code.
 */
private int countCommentedOutLinesInRun(Comment c) {
  result = sum(Comment d | d = getRelevantCommentInRun(c) | countCommentedOutLines(d))
}

/** Gets the number of non-blank lines in `c` and subsequent comments. */
private int countNonBlankLinesInRun(Comment c) {
  result = sum(Comment d | d = getRelevantCommentInRun(c) | countNonBlankLines(d))
}

/**
 * A run of consecutive comments containing a high percentage of lines
 * that look like commented-out code.
 *
 * This is represented by the comment that starts the run, with a special
 * `hasLocationInfo` implementation that assigns it the entire run as its location.
 */
class CommentedOutCode extends Comment {
  CommentedOutCode() {
    exists(int codeLines, int nonBlankLines |
      countCommentedOutLines(this) > 0 and
      not exists(Comment prev | this = getCommentInRun(_, prev) and this != prev) and
      nonBlankLines = countNonBlankLinesInRun(this) and
      codeLines = countCommentedOutLinesInRun(this) and
      nonBlankLines > 0 and
      2 * codeLines > nonBlankLines
    )
  }

  /**
   * Gets the number of lines in this run of comments
   * that look like they contain commented-out code.
   */
  int getNumCodeLines() { result = countCommentedOutLinesInRun(this) }

  /**
   * Gets the number of non-blank lines in this run of comments.
   */
  int getNumNonBlankLines() { result = countNonBlankLinesInRun(this) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(Location loc, File f | loc = getLocation() and f = loc.getFile() |
      filepath = f.getAbsolutePath() and
      startline = loc.getStartLine() and
      startcolumn = loc.getStartColumn() and
      exists(Location last |
        last = getCommentInRun(f, this).getLocation() and
        last.getEndLine() = max(getCommentInRun(f, this).getLocation().getEndLine())
      |
        endline = last.getEndLine() and
        endcolumn = last.getEndColumn()
      )
    )
  }
}

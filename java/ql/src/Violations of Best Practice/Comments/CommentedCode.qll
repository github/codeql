import java
import semmle.code.java.frameworks.gwt.GWT
import semmle.code.java.frameworks.j2objc.J2ObjC

/**
 * Guess if the given `JavadocText` is a line of code.
 *
 * Matches comment lines ending with `{`, `}` or `;` that do not start with `>` or `@`, but first filters out:
 *
 * - Lines containing `//`
 * - Substrings between `{@` and `}` (including the brackets themselves)
 * - HTML entities in common notation (e.g. `&gt;` and `&eacute;`)
 * - HTML entities in decimal notation (e.g. `&#768;`)
 * - HTML entities in hexadecimal notation (e.g. `&#x705F;`)
 */
private predicate looksLikeCode(JavadocText line) {
  exists(string trimmed | trimmed = trimmedCommentText(line) |
    (
      trimmed.matches("%;") or
      trimmed.matches("%{") or
      trimmed.matches("%}")
    ) and
    not trimmed.matches(">%") and
    not trimmed.matches("@%")
  )
}

/**
 * Remove things from comments that may look like code but are not code:
 *
 * - Lines containing `//`
 * - Substrings between `{@` and `}` (including the brackets themselves)
 * - HTML entities in common notation (e.g. `&gt;` and `&eacute;`)
 * - HTML entities in decimal notation (e.g. `&#768;`)
 * - HTML entities in hexadecimal notation (e.g. `&#x705F;`)
 */
private string trimmedCommentText(JavadocText line) {
  result =
    line
        .getText()
        .trim()
        .regexpReplaceAll("\\s*//.*$", "")
        .regexpReplaceAll("\\{@[^}]+\\}", "")
        .regexpReplaceAll("(?i)&#?[a-z0-9]{1,31};", "")
}

/**
 * Holds if this comment contains opening and closing `<code>` or `<pre>` tags.
 */
private predicate hasCodeTags(Javadoc j) {
  exists(string tag | tag = "pre" or tag = "code" |
    j.getAChild().(JavadocText).getText().matches("%<" + tag + ">%") and
    j.getAChild().(JavadocText).getText().matches("%</" + tag + ">%")
  )
}

/**
 * The comment immediately following `c`.
 */
private Javadoc getNextComment(Javadoc c) {
  exists(int n, File f | javadocLines(c, f, _, n) | javadocLines(result, f, n + 1, _))
}

private predicate javadocLines(Javadoc j, File f, int start, int end) {
  f = j.getFile() and
  start = j.getLocation().getStartLine() and
  end = j.getLocation().getEndLine()
}

private class JavadocFirst extends Javadoc {
  JavadocFirst() { not exists(Javadoc prev | this = getNextComment(prev)) }
}

/**
 * The number of lines that look like code in the comment `first`, or ones that follow it.
 */
private int codeCount(JavadocFirst first) {
  result =
    sum(Javadoc following |
      following = getNextComment*(first) and not hasCodeTags(following)
    |
      count(JavadocText line | line = following.getAChild() and looksLikeCode(line))
    )
}

/**
 * The number of lines in the comment `first`, or ones that follow it.
 */
private int anyCount(JavadocFirst first) {
  result =
    sum(Javadoc following |
      following = getNextComment*(first) and not hasCodeTags(following)
    |
      count(JavadocText line |
          line = following.getAChild() and
          not exists(string trimmed | trimmed = line.getText().trim() |
            trimmed.regexpMatch("(|/\\*|/\\*\\*|\\*|\\*/)") or
            trimmed.matches("@%")
          )
        )
    )
}

/**
 * A piece of commented-out code, identified using heuristics.
 */
class CommentedOutCode extends JavadocFirst {
  CommentedOutCode() {
    anyCount(this) > 0 and
    codeCount(this).(float) / anyCount(this).(float) > 0.5 and
    not this instanceof JSNIComment and
    not this instanceof OCNIComment
  }

  /**
   * The number of lines that appear to be commented-out code.
   */
  int getCodeLines() { result = codeCount(this) }

  private Javadoc getLastSuccessor() {
    result = getNextComment*(this) and
    not exists(getNextComment(result))
  }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = getLocation().getFile().getAbsolutePath() and
    sl = getLocation().getStartLine() and
    sc = getLocation().getStartColumn() and
    exists(Location end | end = this.getLastSuccessor().getLocation() |
      el = end.getEndLine() and
      ec = end.getEndColumn()
    )
  }
}

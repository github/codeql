/**
 * @name Filter: Suppression comments
 * @description Recognise comments containing `NOSEMMLE` as suppression comments
 *              when they appear on a line containing an alert or the
 *              immediately preceding line. As further customisations,
 *              `NOSEMMLE(some text)` will only suppress alerts where the
 *              message contains "some text", and `NOSEMMLE/some regex/` will
 *              only suppress alerts where the message contains a match of the
 *              regex. No special way of escaping `)` or `/` in the suppression
 *              comment argument is provided.
 * @kind problem
 * @id java/nosemmle-suppression-comment-filter
 */

import java
import external.DefectFilter

class SuppressionComment extends Javadoc {
  SuppressionComment() { this.getAChild*().getText().matches("%NOSEMMLE%") }

  private string getASuppressionDirective() {
    result = this.getAChild*().getText().regexpFind("\\bNOSEMMLE\\b(\\([^)]+?\\)|/[^/]+?/|)", _, 0)
  }

  private string getAnActualSubstringArg() {
    result = this.getASuppressionDirective().regexpCapture("NOSEMMLE\\((.*)\\)", 1)
  }

  private string getAnActualRegexArg() {
    result = ".*" + this.getASuppressionDirective().regexpCapture("NOSEMMLE/(.*)/", 1) + ".*"
  }

  private string getASuppressionRegex() {
    result = getAnActualRegexArg()
    or
    exists(string substring | substring = getAnActualSubstringArg() |
      result = "\\Q" + substring.replaceAll("\\E", "\\E\\\\E\\Q") + "\\E"
    )
    or
    result = ".*" and getASuppressionDirective() = "NOSEMMLE"
  }

  predicate suppresses(DefectResult res) {
    this.getFile() = res.getFile() and
    res.getEndLine() - this.getLocation().getEndLine() in [0 .. 2] and
    res.getMessage().regexpMatch(this.getASuppressionRegex())
  }
}

from DefectResult res
where not exists(SuppressionComment s | s.suppresses(res))
select res, res.getMessage()

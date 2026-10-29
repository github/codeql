/**
 * @name AV Rule 133
 * @description Every source file will be documented with an introductory comment that provides information on the file name, its contents, and any program-required information (eg. legal statements, copyright information, etc)
 * @kind problem
 * @id cpp/jsf/av-rule-133
 * @problem.severity recommendation
 * @tags maintainability
 *       documentation
 *       external/jsf
 */

import cpp

class FirstComment extends Comment {
  FirstComment() {
    not exists(Locatable l |
      l != this and
      shouldNotBeBefore(l) and
      l.getFile() = this.getFile() and
      l.getLocation().getEndLine() <= this.getLocation().getStartLine()
    )
  }

  /*
   * Test whether the comment is a reasonable start-of-file comment.
   * CUSTOMIZATION POINT: INSERT STYLE RULES FOR THE START-OF-FILE COMMENT HERE
   * Simple checks only - if there is a comment at the beginning of the file, that
   * is pretty much enough
   */

  predicate isValid() {
    // At least 3 lines long: make sure it's a proper comment
    this.getLocation().getEndLine() >= this.getLocation().getStartLine() + 2 and
    exists(string contents | contents = this.getContents() |
      // Make sure the name of the file is included
      contents.matches("%" + this.getFile().getShortName() + "%")
      // Other checks could go here; for instance containing a standard copyright notice
    )
  }
}

/** Elements that should not appear before the 'first' comment */
predicate shouldNotBeBefore(Locatable l) {
  l instanceof Comment or
  l instanceof Declaration or
  l instanceof PreprocessorDirective
}

from File f, Element blame, string message
where
  f.fromSource() and
  (
    not exists(FirstComment comment | comment.getFile() = f) and
    blame = f and
    message = ""
    or
    exists(FirstComment comment |
      comment.getFile() = f and not comment.isValid() and blame = comment
    ) and
    message = "The introductory comment does not match the required style rules."
  )
select blame,
  "AV Rule 133: every source file will be documented with an introductory comment. " + message

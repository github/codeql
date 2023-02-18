/**
 * @name Outdated deprecation
 * @description Deprecations that are over a year old should be removed.
 * @kind problem
 * @problem.severity recommendation
 * @id ql/outdated-deprecation
 * @tags maintainability
 * @precision high
 */

import ql
import codeql_ql.ast.internal.TreeSitter

date today() { result = any(Blame::BlameInfo b).getToday().getValue().toDate() }

pragma[nomagic]
Annotation getADeprecatedAnnotationAt(string filePath, int line) {
  result.getLocation().getFile().getRelativePath() = filePath and
  result.getLocation().getStartLine() = line and
  result.getName() = "deprecated"
}

class DatedDeprecation extends Annotation {
  date lastModified;

  DatedDeprecation() {
    this.getName() = "deprecated" and
    exists(Blame::FileEntry f, Blame::BlameEntry b |
      this = getADeprecatedAnnotationAt(f.getFileName().getValue(), b.getLine(_).getValue().toInt()) and
      f.getBlameEntry(_) = b and
      lastModified = b.getDate().getValue().toDate()
    )
  }

  /** Gets how long ago this deprecation was added, in months. */
  int getMonthsOld() {
    exists(float month |
      month = 365 / 12 and result = (lastModified.daysTo(today()) / month).floor()
    )
  }
}

from DatedDeprecation d
where d.getMonthsOld() >= 14
select d, "This deprecation is over 14 months old."

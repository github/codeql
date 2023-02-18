/**
 * @name Outdated deprecation
 * @description Deprecations that are over a year old should be removed.
 * @kind problem
 * @problem.severity warning
 * @id ql/outdated-deprecation
 * @tags maintainability
 * @precision high
 */

import ql
import codeql_ql.ast.internal.TreeSitter

date today() { result = any(Blame::BlameInfo b).getToday().getValue().toDate() }

class DatedDeprecation extends Annotation {
  date lastModified;

  DatedDeprecation() {
    this.getName() = "deprecated" and
    exists(Blame::FileEntry f, Blame::BlameEntry b |
      f.getFileName().getValue() = this.getLocation().getFile().getRelativePath() and
      f.getBlameEntry(_) = b and
      b.getLine(_).getValue().toInt() = this.getLocation().getStartLine() and
      lastModified = b.getDate().getValue().toDate()
    )
  }

  date getLastModified() { result = lastModified }
}

from DatedDeprecation d
where d.getLastModified().daysTo(today()) > 365
select d, "This deprecation is over a year old."

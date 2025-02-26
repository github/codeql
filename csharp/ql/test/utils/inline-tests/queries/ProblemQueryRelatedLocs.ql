/**
 * @kind problem
 * @id problem-query-with-related-loc
 */

import csharp

from StringLiteral sl, StringLiteral related, int offset
where
  sl.getValue().regexpCapture("Alert:([0-9]+)", 1).toInt() = offset and
  related.getLocation().getStartLine() = sl.getLocation().getStartLine() - offset
select sl, "This is a problem with $@", related, "a related location"

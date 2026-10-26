/**
 * @kind path-problem
 * @id path-problem-query-with-related-loc
 */

import csharp

query predicate edges(StringLiteral sl1, StringLiteral sl2) { none() }

from StringLiteral alert, StringLiteral source, StringLiteral sink, StringLiteral related
where
  exists(string regexp, int sourceOffset, int sinkOffset, int relatedOffset |
    regexp = "Alert:([0-9]+):([0-9]+):([0-9]+)"
  |
    sourceOffset = alert.getValue().regexpCapture(regexp, 1).toInt() and
    sinkOffset = alert.getValue().regexpCapture(regexp, 2).toInt() and
    relatedOffset = alert.getValue().regexpCapture(regexp, 3).toInt() and
    source.getLocation().getStartLine() = alert.getLocation().getStartLine() - sourceOffset and
    sink.getLocation().getStartLine() = alert.getLocation().getStartLine() - sinkOffset and
    related.getLocation().getStartLine() = alert.getLocation().getStartLine() - relatedOffset
  )
select alert, source, sink, "This is a problem with $@", related, "a related location"

/**
 * @kind path-problem
 * @id path-problem-query
 */

import csharp

query predicate edges(StringLiteral sl1, StringLiteral sl2) { none() }

from StringLiteral alert, StringLiteral source, StringLiteral sink
where
  exists(string regexp, int sourceOffset, int sinkOffset | regexp = "Alert:([0-9]+):([0-9]+)" |
    sourceOffset = alert.getValue().regexpCapture(regexp, 1).toInt() and
    sinkOffset = alert.getValue().regexpCapture(regexp, 2).toInt() and
    source.getLocation().getStartLine() = alert.getLocation().getStartLine() - sourceOffset and
    sink.getLocation().getStartLine() = alert.getLocation().getStartLine() - sinkOffset
  )
select alert, source, sink, "This is a problem"

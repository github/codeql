/**
 * Finds evaluations with very large tuple counts somewhere
 */

import ql
import codeql_ql.StructuredLogs

float maxTupleCount(KindPredicatesLog::SummaryEvent evt) {
  result = max(KindPredicatesLog::PipeLineRuns r | r.getEvent() = evt | r.getRun(_).getCount(_))
}

int maxPipeLineLength(KindPredicatesLog::SummaryEvent evt) {
  result = max(evt.getRA().getPipeLine(_).getLength())
}

from KindPredicatesLog::SummaryEvent evt
select evt, evt.getResultSize(), evt.getMillis() as ms, maxTupleCount(evt) as mc,
  maxPipeLineLength(evt) as len order by mc desc

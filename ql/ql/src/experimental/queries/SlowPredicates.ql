/**
 * Shows a list of the "slow" predicates by wallclock time.
 */

import ql
import codeql_ql.StructuredLogs

int predicateRank(KindPredicatesLog::SummaryEvent evt) {
  evt =
    rank[result](KindPredicatesLog::SummaryEvent y, int m | m = y.getMillis() | y order by m desc)
}

from KindPredicatesLog::SummaryEvent evt
where predicateRank(evt) < 50
select evt, evt.getMillis() as time order by time desc

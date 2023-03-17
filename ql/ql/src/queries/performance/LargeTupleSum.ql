/**
 * Shows a list of the "slow" predicates by tuple sum.
 */

import ql
import codeql_ql.StructuredLogs
import KindPredicatesLog

module SumCounts implements Fold<int> {
  int base(PipeLineRun run) { result = sum(int i | | run.getCount(i)) }

  bindingset[s]
  int fold(PipeLineRun run, int s) { result = sum(int i | | run.getCount(i)) + s }
}

int sumTuples(SummaryEvent event) {
  result = strictsum(int i | | event.(ComputeSimple).getPipelineRun().getCount(i))
  or
  result = Iterate<int, SumCounts>::iterate(event)
}

int predicateRank(SummaryEvent evt) {
  evt = rank[result](SummaryEvent y, int s | s = sumTuples(y) | y order by s desc)
}

from SummaryEvent evt, int s
where predicateRank(evt) < 50 and s = sumTuples(evt)
select evt, s order by s desc

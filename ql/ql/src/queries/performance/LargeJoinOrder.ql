/**
 * Shows a list of the non-recursive predicates with the worst join order as determined
 * by the join order metric.
 */

import ql
import codeql_ql.StructuredLogs
import KindPredicatesLog

/**
 * Gets the badness of a non-recursive predicate evaluation.
 *
 * The badness is the maximum number of tuples in the pipeline divided by the
 * maximum of two numbers: the size of the result and the size of the largest dependency.
 */
float getBadness(ComputeSimple simple) {
  exists(float maxTupleCount, float resultSize, float largestDependency, float denom |
    resultSize = simple.getResultSize() and
    extractInformation(simple, maxTupleCount, _, _, _) and
    largestDependency = max(simple.getDependencies().getADependency().getResultSize()) and
    denom = resultSize.maximum(largestDependency) and
    denom > 0 and // avoid division by zero (which would create a NaN result).
    result = maxTupleCount / denom
  )
}

pragma[nomagic]
predicate hasPipelineRun(ComputeSimple simple, PipeLineRun run) { run = simple.getPipelineRun() }

predicate extractInformation(
  ComputeSimple simple, float maxTupleCount, Array tuples, Array duplicationPercentages, Array ra
) {
  exists(PipeLineRun run |
    hasPipelineRun(simple, run) and
    maxTupleCount = max(run.getCount(_)) and
    tuples = run.getCounts() and
    duplicationPercentages = run.getDuplicationPercentage() and
    ra = simple.getRA()
  )
}

from
  ComputeSimple evt, float badness, float maxTupleCount, Array tuples, Array duplicationPercentages,
  Array ra, int index
where
  badness = getBadness(evt) and
  badness > 1.5 and
  extractInformation(evt, maxTupleCount, tuples, duplicationPercentages, ra)
select evt.getPredicateName() as predicate_name, badness, index,
  tuples.getFloat(index) as tuple_count,
  duplicationPercentages.getFloat(index) as duplication_percentage, ra.getString(index) order by
    badness desc

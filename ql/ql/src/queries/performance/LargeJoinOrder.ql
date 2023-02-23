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
    extractInformation(simple, maxTupleCount, _, _, _, _) and
    largestDependency = max(simple.getDependencies().getADependency().getResultSize()) and
    denom = resultSize.maximum(largestDependency) and
    denom > 0 and // avoid division by zero (which would create a NaN result).
    result = maxTupleCount / denom
  )
}

pragma[nomagic]
predicate hasPipelineRun(ComputeSimple simple, PipeLineRun run) { run = simple.getPipelineRun() }

predicate extractInformation(
  ComputeSimple simple, float maxTupleCount, int pipelineIndex, Array tuples,
  Array duplicationPercentages, Array ra
) {
  exists(PipeLineRun run |
    hasPipelineRun(simple, run) and
    maxTupleCount = max(run.getCount(_)) and
    pragma[only_bind_out](tuples.getFloat(pipelineIndex)) = maxTupleCount and
    tuples = run.getCounts() and
    duplicationPercentages = run.getDuplicationPercentage() and
    ra = simple.getRa()
  )
}

from
  ComputeSimple evt, float f, float maxTupleCount, int pipelineIndex, Array tuples,
  Array duplicationPercentages, Array ra
where
  f = getBadness(evt) and
  f > 1.5 and
  extractInformation(evt, maxTupleCount, pipelineIndex, tuples, duplicationPercentages, ra)
select evt, f, pipelineIndex, tuples, duplicationPercentages, ra order by f desc

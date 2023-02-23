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
    maxTupleCount = max(simple.getPipelineRun().getCount(_)) and
    largestDependency = max(simple.getDependencies().getADependency().getResultSize()) and
    denom = resultSize.maximum(largestDependency) and
    denom > 0 and // avoid division by zero (which would create a NaN result).
    result = maxTupleCount / denom
  )
}

from ComputeSimple evt, float f
where f = getBadness(evt) and f > 1.5
select evt, f order by f desc

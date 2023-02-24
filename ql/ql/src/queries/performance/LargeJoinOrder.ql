/**
 * Shows a list of the non-recursive predicates with the worst join order as determined
 * by the join order metric.
 */

import ql
import codeql_ql.StructuredLogs
import KindPredicatesLog
import experimental.RA

/**
 * Gets the badness of a non-recursive predicate evaluation.
 *
 * The badness is the maximum number of tuples in the pipeline divided by the
 * maximum of two numbers: the size of the result and the size of the largest dependency.
 */
float getNonRecursiveBadness(ComputeSimple simple) {
  exists(float maxTupleCount, float resultSize, float largestDependency, float denom |
    resultSize = simple.getResultSize() and
    maxTupleCount = max(simple.getPipelineRun().getCount(_)) and
    largestDependency = max(simple.getDependencies().getADependency().getResultSize()) and
    denom = resultSize.maximum(largestDependency) and
    denom > 0 and // avoid division by zero (which would create a NaN result).
    result = maxTupleCount / denom
  )
}

predicate hasTupleCount(
  ComputeRecursive recursive, string ordering, SummaryEvent inLayer, int iteration, int i,
  float tupleCount
) {
  inLayer = firstPredicate(recursive) and
  exists(PipeLineRun run |
    run = inLayer.getPipelineRuns().getRun(iteration) and ordering = run.getRAReference()
  |
    tupleCount = run.getCount(i)
    or
    exists(SummaryEvent inLayer0, float tupleCount0 |
      successor(recursive, inLayer0, inLayer) and
      hasTupleCount(recursive, ordering, inLayer0, pragma[only_bind_into](iteration), i, tupleCount0) and
      tupleCount = run.getCount(i) + tupleCount0
    )
  )
}

predicate hasTupleCount(ComputeRecursive recursive, string ordering, int i, float tupleCount) {
  tupleCount =
    strictsum(SummaryEvent inLayer, int iteration, int tc |
      inLayer = getInLayerOrRecursive(recursive) and
      hasTupleCount(recursive, ordering, inLayer, iteration, i, tc)
    |
      tc
    )
}

pragma[nomagic]
predicate hasDuplication(
  ComputeRecursive recursive, string ordering, SummaryEvent inLayer, int iteration, int i,
  float duplication
) {
  exists(PipeLineRun run |
    run = inLayer.getPipelineRuns().getRun(iteration) and
    ordering = run.getRAReference()
  |
    inLayer = firstPredicate(recursive) and
    duplication = run.getDuplicationPercentage(i)
    or
    exists(SummaryEvent inLayer0, float duplication0 |
      successor(recursive, inLayer0, inLayer) and
      hasDuplication(recursive, ordering, inLayer0, pragma[only_bind_into](iteration), i,
        duplication0) and
      duplication = run.getDuplicationPercentage(i).maximum(duplication0)
    )
  )
}

predicate hasDuplication(ComputeRecursive recursive, string ordering, int i, float duplication) {
  duplication =
    max(int iteration, int dup | hasDuplication(recursive, ordering, _, iteration, i, dup) | dup)
}

/**
 * Holds if the ordering `ordering` has `resultSize` resultSize in the `iteration`'th iteration.
 */
private predicate hasResultSize(
  ComputeRecursive recursive, string ordering, SummaryEvent inLayer, int iteration, float resultSize
) {
  exists(PipeLineRun run |
    run = inLayer.getPipelineRuns().getRun(iteration) and
    ordering = run.getRAReference()
  |
    inLayer = firstPredicate(recursive) and
    resultSize = inLayer.getDeltaSize(iteration)
    or
    exists(SummaryEvent inLayer0, int resultSize0 |
      successor(recursive, inLayer0, inLayer) and
      hasResultSize(recursive, ordering, inLayer0, iteration, resultSize0) and
      resultSize = inLayer.getDeltaSize(iteration) + resultSize0
    )
  )
}

predicate hasResultSize(ComputeRecursive recursive, string ordering, float resultSize) {
  resultSize =
    strictsum(int iteration, float r | hasResultSize(recursive, ordering, _, iteration, r) | r)
}

RAParser<PipeLine>::RAExpr getAnRaOperation(SummaryEvent inLayer, string ordering) {
  inLayer.getRA().getPipeLine(ordering) = result.getPredicate()
}

SummaryEvent getInLayerEventWithName(ComputeRecursive recursive, string predicateName) {
  result = getInLayerOrRecursive(recursive) and
  result.getPredicateName() = predicateName
}

bindingset[predicateName, iteration]
int getSize(ComputeRecursive recursive, string predicateName, int iteration, TDeltaKind kind) {
  exists(int i, SummaryEvent event |
    kind = TPrevious() and
    i = iteration - 1
    or
    kind = TCurrent() and
    i = iteration
  |
    event = getInLayerEventWithName(recursive, predicateName) and
    (
      result = event.getDeltaSize(i)
      or
      not exists(event.getDeltaSize(i)) and
      result = 0
    )
  )
}

SummaryEvent getDependencyWithName(Depencencies dependency, string predicateName) {
  result.getPredicateName() = predicateName and
  dependency.getADependency() = result
}

newtype TDeltaKind =
  TCurrent() or
  TPrevious()

bindingset[predicateName]
private predicate isDelta(string predicateName, TDeltaKind kind, string withoutSuffix) {
  kind = TPrevious() and
  withoutSuffix = predicateName.regexpCapture("(.+)#prev_delta", 1)
  or
  kind = TCurrent() and
  withoutSuffix = predicateName.regexpCapture("(.+)#cur_delta", 1)
}

bindingset[iteration]
float getRecursiveDependencySize(
  ComputeRecursive recursive, string predicateName, int iteration, SummaryEvent inLayer,
  string ordering, TDeltaKind kind
) {
  result = getSize(recursive, predicateName, iteration, kind) and
  isDelta(getAnRaOperation(inLayer, ordering).getARhsPredicate(), kind, predicateName)
}

bindingset[ordering, iteration]
predicate hasDependentPredicateSizeImpl(
  ComputeRecursive recursive, string ordering, float size, string predicateName, int iteration,
  SummaryEvent inLayer
) {
  // We treat the base case as a non-recursive case
  if ordering = "base"
  then
    size =
      [
        getDependencyWithName(recursive.getDependencies(), predicateName).getResultSize(),
        getRecursiveDependencySize(recursive, predicateName, iteration, inLayer, ordering,
          TCurrent())
      ]
  else
    size =
      getRecursiveDependencySize(recursive, predicateName, iteration, inLayer, ordering, TPrevious())
}

pragma[nomagic]
predicate hasDependentPredicateSize(
  ComputeRecursive recursive, string ordering, SummaryEvent inLayer, int iteration,
  string predicateName, float size
) {
  exists(PipeLineRun run |
    run = inLayer.getPipelineRuns().getRun(pragma[only_bind_into](iteration)) and
    ordering = run.getRAReference()
  |
    inLayer = firstPredicate(recursive) and
    hasDependentPredicateSizeImpl(recursive, ordering, size, predicateName, iteration, inLayer)
    or
    exists(SummaryEvent inLayer0, float size0, float size1 |
      successor(recursive, inLayer0, inLayer) and
      hasDependentPredicateSize(recursive, ordering, inLayer0, pragma[only_bind_into](iteration),
        predicateName, size0) and
      hasDependentPredicateSizeImpl(recursive, ordering, size1, predicateName, iteration, inLayer) and
      size = size0 + size1
    )
  )
}

SummaryEvent getInLayerOrRecursive(ComputeRecursive recursive) {
  result = recursive or result.(InLayer).getComputeRecursiveEvent() = recursive
}

predicate hasDependentPredicateSize(
  ComputeRecursive recursive, string ordering, string predicateName, float size
) {
  size =
    strictsum(int iteration, float s |
      hasDependentPredicateSize(recursive, ordering, _, iteration, predicateName, s)
    |
      s
    )
}

/**
 * Gets the badness of a recursive predicate evaluation.
 *
 * The badness is the maximum number of tuples in the pipeline divided by the
 * maximum of two numbers: the size of the result and the size of the largest dependency.
 *
 * A dependency of a recursive predicate is defined as follows:
 * - For a "base" ordering, it is identical to the definition of a dependency for a
 *   non-recursive predicate
 * - For a non-"base" ordering, it's defined as any `#prev_delta` or `#cur_delta` predicates
 *   that appear in the pipeline.
 */
float getRecursiveBadness(ComputeRecursive recursive, string ordering) {
  exists(float maxTupleCount, float resultSize, float maxDependentPredicateSize |
    maxTupleCount = max(float tc | hasTupleCount(recursive, ordering, _, tc) | tc) and
    hasResultSize(recursive, ordering, resultSize) and
    maxDependentPredicateSize =
      max(float size | hasDependentPredicateSize(recursive, ordering, _, size) | size) and
    resultSize.maximum(maxDependentPredicateSize) > 0 and
    result = maxTupleCount / resultSize.maximum(maxDependentPredicateSize)
  )
}

predicate extractSimpleInformation(
  ComputeSimple simple, string predicateName, int index, float tupleCount,
  float duplicationPercentage, string operation
) {
  exists(PipeLineRun run |
    run = simple.getPipelineRun() and
    tupleCount = run.getCounts().getFloat(pragma[only_bind_into](index)) and
    duplicationPercentage = run.getDuplicationPercentage().getFloat(pragma[only_bind_into](index)) and
    operation = simple.getRA().getPipeLine().getLineOfRA(pragma[only_bind_into](index)) and
    predicateName = simple.getPredicateName()
  )
}

predicate extractRecursiveInformation(
  ComputeRecursive recursive, string predicateName, string ordering, int index, float tupleCount,
  float duplicationPercentage, string operation
) {
  hasTupleCount(recursive, ordering, index, tupleCount) and
  hasDuplication(recursive, ordering, index, duplicationPercentage) and
  operation = recursive.getRA().getPipeLine(ordering).getLineOfRA(index) and
  predicateName = recursive.getPredicateName() + " (" + ordering + ")"
}

from
  SummaryEvent evt, float badness, float tupleCount, float duplicationPercentage, string operation,
  int index, string predicateName
where
  badness > 1.5 and
  (
    badness = getNonRecursiveBadness(evt) and
    extractSimpleInformation(evt, predicateName, index, tupleCount, duplicationPercentage, operation)
    or
    exists(string ordering |
      badness = getRecursiveBadness(evt, ordering) and
      extractRecursiveInformation(evt, predicateName, ordering, index, tupleCount,
        duplicationPercentage, operation)
    )
  )
select predicateName as predicate_name, badness, index, tupleCount as tuple_count,
  duplicationPercentage as duplication_percentage, operation order by badness desc

/**
 * INTERNAL: Do not use.
 *
 * Provides helper class for defining additional API graph edges.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.internal.CachedStages

/**
 * INTERNAL: Do not use.
 *
 * Holds if `result` is the result of awaiting `awaitedValue`.
 */
cached
DataFlow::Node awaited(DataFlow::Node awaitedValue) {
  Stages::DataFlow::ref() and
  // `await` x
  // - `awaitedValue` is `x`
  // - `result` is `await x`
  exists(Await await |
    await.getValue() = awaitedValue.asExpr() and
    result.asExpr() = await
  )
  or
  // `async for x in l`
  // - `awaitedValue` is `l`
  // - `result` is `l` (`x` is behind a read step)
  exists(AsyncFor asyncFor |
    // To consider `x` the result of awaiting, we would use asyncFor.getTarget() = awaitedValue.asExpr(),
    // but that is behind a read step rather than a flow step.
    asyncFor.getIter() = awaitedValue.asExpr() and
    result.asExpr() = asyncFor.getIter()
  )
  or
  // `async with x as y`
  // - `awaitedValue` is `x`
  // - `result` is `x` and `y` if it exists
  exists(AsyncWith asyncWith |
    awaitedValue.asExpr() = asyncWith.getContextExpr() and
    result.asExpr() in [
        // `x`
        asyncWith.getContextExpr(),
        // `y`, if it exists
        asyncWith.getOptionalVars()
      ]
  )
}

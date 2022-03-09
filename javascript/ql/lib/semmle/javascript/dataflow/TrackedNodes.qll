/**
 * DEPRECATED: Use `TypeTracking.qll` instead.
 *
 * The following `TrackedNode` usage is usually equivalent to the type tracking usage below.
 *
 * ```
 * class MyTrackedNode extends TrackedNode {
 *    MyTrackedNode() { isInteresting(this) }
 * }
 *
 * DataFlow::Node getMyTrackedNodeLocation(MyTrackedNode n) {
 *   n.flowsTo(result)
 * }
 * ```
 *
 * ```
 * DataFlow::SourceNode getMyTrackedNodeLocation(DataFlow::SourceNode start, DataFlow::TypeTracker t) {
 *   t.start() and
 *   isInteresting(result) and
 *   result = start
 *   or
 *   exists (DataFlow::TypeTracker t2 |
 *     result = getMyTrackedNodeLocation(start, t2).track(t2, t)
 *   )
 * }
 *
 * DataFlow::SourceNode getMyTrackedNodeLocation(DataFlow::SourceNode n) {
 *   result = getMyTrackedNodeLocation(n, DataFlow::TypeTracker::end())
 * }
 * ```
 *
 * In rare cases, additional tracking is required, for instance when tracking string constants, and the following type tracking formulation is required instead.
 *
 * ```
 * DataFlow::Node getMyTrackedNodeLocation(DataFlow::Node start, DataFlow::TypeTracker t) {
 *   t.start() and
 *   isInteresting(result) and
 *   result = start
 *   or
 *   exists(DataFlow::TypeTracker t2 |
 *     t = t2.smallstep(getMyTrackedNodeLocation(start, t2), result)
 *   )
 * }
 *
 * DataFlow::Node getMyTrackedNodeLocation(DataFlow::Node n) {
 *   result = getMyTrackedNodeLocation(n, DataFlow::TypeTracker::end())
 * }
 * ```
 *
 * Provides support for inter-procedural tracking of a customizable
 * set of data flow nodes.
 */

private import javascript
private import internal.FlowSteps as FlowSteps

/**
 * A simplified copy of `Configuration.qll` that implements tracking
 * of `TrackedNode`s without barriers or additional flow steps.
 */
private module NodeTracking {
  private import internal.FlowSteps

  /**
   * Holds if data can flow in one step from `pred` to `succ`,  taking
   * additional steps into account.
   */
  pragma[inline]
  predicate localFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    pred = succ.getAPredecessor()
    or
    DataFlow::SharedFlowStep::step(pred, succ)
    or
    localExceptionStep(pred, succ)
  }
}

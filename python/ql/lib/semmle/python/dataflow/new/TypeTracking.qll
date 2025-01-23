/**
 * Provides classes and predicates for simple data-flow reachability suitable
 * for tracking types.
 */

private import internal.TypeTrackingImpl as Impl
private import semmle.python.Files
import Impl::Shared::TypeTracking<Location, Impl::TypeTrackingInput>
private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic

/**
 * DEPRECATED.
 *
 * A string that may appear as the name of an attribute or access path.
 */
deprecated class AttributeName = Impl::TypeTrackingInput::Content;

/**
 * A summary of the steps needed to track a value to a given dataflow node.
 *
 * This can be used to track objects that implement a certain API in order to
 * recognize calls to that API. Note that type-tracking does not by itself provide a
 * source/sink relation, that is, it may determine that a node has a given type,
 * but it won't determine where that type came from.
 *
 * It is recommended that all uses of this type are written in the following form,
 * for tracking some type `myType`:
 * ```ql
 * Node myType(TypeTracker tt) {
 *   tt.start() and
 *   result = < source of myType >
 *   or
 *   exists(TypeTracker tt2 |
 *     tt = tt2.step(myType(tt2), result)
 *   )
 * }
 *
 * Node myType() { myType(TypeTracker::end()).flowsTo(result) }
 * ```
 *
 * If you want to track individual intra-procedural steps, use `tt2.smallstep`
 * instead of `tt2.step`.
 */
class TypeTracker extends Impl::TypeTracker {
  /**
   * Holds if this is the starting point of type tracking, and the value starts in the attribute named `attrName`.
   * The type tracking only ends after the attribute has been loaded.
   */
  predicate startInAttr(string attrName) {
    exists(DataFlowPublic::AttributeContent content | content.getAttribute() = attrName |
      this.startInContent(content)
    )
  }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Gets the attribute associated with this type tracker.
   */
  string getAttr() {
    if this.getContent().asSome() instanceof DataFlowPublic::AttributeContent
    then result = this.getContent().asSome().(DataFlowPublic::AttributeContent).getAttribute()
    else result = ""
  }
}

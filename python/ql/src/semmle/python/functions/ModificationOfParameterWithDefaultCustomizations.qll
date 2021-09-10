/**
 * Provides default sources, sinks and sanitizers for detecting
 * modifications of a parameters default value, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "command injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module ModificationOfParameterWithDefault {
  /**
   * A data flow source for detecting modifications of a parameters default value.
   */
  abstract class Source extends DataFlow::Node {
    /** Result is true if the default value is non-empty for this source and false if not. */
    abstract boolean isNonEmpty();
  }

  /**
   * A data flow sink for detecting modifications of a parameters default value.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for detecting modifications of a parameters default value.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A sanitizer guard that does not let a truthy value flow to the true branch.
   *
   * Implementation note:
   * Since guards with different behaviour cannot exist on the same node,
   * we let all guards have the same behaviour, in the sense that they all check
   * the true branch. Instead, we partition guards into those that block
   * truthy values and those that block falsy values.
   *
   * If you extend this class, make sure that your barrier checks the true branch.
   */
  abstract class BlocksTruthy extends DataFlow::BarrierGuard { }

  /**
   * A sanitizer guard that does not let a falsy value flow to the true branch.
   *
   * Implementation note:
   * Since guards with different behaviour cannot exist on the same node,
   * we let all guards have the same behaviour, in the sense that they all check
   * the true branch. Instead, we partition guards into those that block
   * truthy values and those that block falsy values.
   *
   * If you extend this class, make sure that your barrier checks the true branch.
   */
  abstract class BlocksFalsey extends DataFlow::BarrierGuard { }

  /** Gets the truthiness (non emptyness) of the default of `p` if that value is mutable */
  private boolean mutableDefaultValue(Parameter p) {
    exists(Dict d | p.getDefault() = d |
      exists(d.getAKey()) and result = true
      or
      not exists(d.getAKey()) and result = false
    )
    or
    exists(List l | p.getDefault() = l |
      exists(l.getAnElt()) and result = true
      or
      not exists(l.getAnElt()) and result = false
    )
  }

  /**
   * A mutable default value for a parameter, considered as a flow source.
   */
  class MutableDefaultValue extends Source {
    boolean nonEmpty;

    MutableDefaultValue() { nonEmpty = mutableDefaultValue(this.asCfgNode().(NameNode).getNode()) }

    override boolean isNonEmpty() { result = nonEmpty }
  }

  /**
   * A name of a list function that modifies the list.
   * See https://docs.python.org/3/tutorial/datastructures.html#more-on-lists
   */
  string list_modifying_method() {
    result in ["append", "extend", "insert", "remove", "pop", "clear", "sort", "reverse"]
  }

  /**
   * A name of a dict function that modifies the dict.
   * See https://docs.python.org/3/library/stdtypes.html#dict
   */
  string dict_modifying_method() { result in ["clear", "pop", "popitem", "setdefault", "update"] }

  /**
   * A mutation of the default value is a flow sink.
   *
   * Syntactic constructs that modify a list are:
   * - s[i] = x
   * - s[i:j] = t
   * - del s[i:j]
   * - s[i:j:k] = t
   * - del s[i:j:k]
   * - s += t
   * - s *= n
   * See https://docs.python.org/3/library/stdtypes.html#mutable-sequence-types
   *
   * Syntactic constructs that modify a dictionary are:
   * - d[key] = value
   * - del d[key]
   * - d |= other
   * See https://docs.python.org/3/library/stdtypes.html#dict
   *
   * These are all covered by:
   * - assignment to a subscript (includes slices)
   * - deletion of a subscript
   * - augmented assignment to the value
   */
  class Mutation extends Sink {
    Mutation() {
      // assignment to a subscript (includes slices)
      exists(DefinitionNode d | d.(SubscriptNode).getObject() = this.asCfgNode())
      or
      // deletion of a subscript
      exists(DeletionNode d | d.getTarget().(SubscriptNode).getObject() = this.asCfgNode())
      or
      // augmented assignment to the value
      exists(AugAssign a | a.getTarget().getAFlowNode() = this.asCfgNode())
      or
      // modifying function call
      exists(DataFlow::CallCfgNode c, DataFlow::AttrRead a | c.getFunction() = a |
        a.getObject() = this and
        a.getAttributeName() in [list_modifying_method(), dict_modifying_method()]
      )
    }
  }

  /**
   * A simple sanitizer guard that does not let a truthy value flow to the true branch.
   *
   * Blocks flow of `x` in the true branch in the example below.
   * ```py
   * if x:
   *     x.append(42)
   * ```
   */
  class BlocksTruthyGuard extends BlocksTruthy {
    ControlFlowNode guarded;

    BlocksTruthyGuard() { this instanceof NameNode }

    override predicate checks(ControlFlowNode node, boolean branch) {
      node = this and
      branch = true
    }
  }

  /**
   * A simple sanitizer guard that does not let a truthy value flow to the true branch.
   *
   * Blocks flow of `x` in the true branch in the example below.
   * ```py
   * if not x:
   *     x.append(42)
   * ```
   */
  class BlocksFalseyGuard extends BlocksFalsey {
    NameNode guarded;

    BlocksFalseyGuard() {
      this.(UnaryExprNode).getNode().getOp() instanceof Not and
      guarded = this.(UnaryExprNode).getOperand()
    }

    override predicate checks(ControlFlowNode node, boolean branch) {
      node = guarded and
      branch = true
    }
  }
}

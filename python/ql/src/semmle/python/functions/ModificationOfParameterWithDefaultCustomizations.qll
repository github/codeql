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
   * A sanitizer guard for detecting modifications of a parameters default value.
   */
  abstract class BarrierGuard extends DataFlow::BarrierGuard {
    abstract boolean blocksNonEmpty();
  }

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
   * An expression that is checked directly in an `if`, possibly with `not`, such as `if x:` or `if not x:`.
   */
  private class IdentityGuarded extends Expr {
    boolean inverted;

    IdentityGuarded() {
      this = any(If i).getTest() and
      inverted = false
      or
      exists(IdentityGuarded ig, UnaryExpr notExp |
        notExp.getOp() instanceof Not and
        ig = notExp and
        notExp.getOperand() = this
      |
        inverted = ig.isInverted().booleanNot()
      )
    }

    /** 
     * Whether this guard has been inverted. For `if x:` the result is `false`, and for `if not x:` the result is `true`.
     */
    boolean isInverted() { result = inverted }
  }

  /**
   * A check for the value being truthy or falsy can guard against modifying the default value.
   */
  class IdentityGuard extends BarrierGuard {
    ControlFlowNode checked_node;
    boolean safe_branch;
    boolean nonEmpty;

    IdentityGuard() {
      nonEmpty in [true, false] and
      exists(IdentityGuarded ig |
        this.getNode() = ig and
        checked_node = this and
        // The raw guard is true if the value is non-empty.
        // So we are safe either if we are looking for a non-empty value
        // or if we are looking for an empty value and the guard is inverted.
        safe_branch = ig.isInverted().booleanXor(nonEmpty)
      )
    }

    override predicate checks(ControlFlowNode node, boolean branch) {
      node = checked_node and branch = safe_branch
    }

    override boolean blocksNonEmpty() { result = nonEmpty }
  }
}

/**
 * Provides default sources, sinks and sanitizers for detecting
 * modifications of a parameters default value, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.controlflow.internal.Cfg as Cfg

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "command injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module ModificationOfParameterWithDefault {
  /**
   * A data flow source for detecting modifications of a parameters default value,
   * that is a default value for some parameter.
   */
  abstract class Source extends DataFlow::Node {
    /** Result is true if the default value is non-empty for this source and false if not. */
    abstract boolean isNonEmpty();
  }

  /**
   * A data flow sink for detecting modifications of a parameters default value,
   * that is a node representing a modification.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for detecting modifications of a parameters default value
   * should determine if the node (which is perhaps about to be modified)
   * can be the default value or not.
   *
   * In this query we do not track the default value exactly, but rather whether
   * it is empty or not (see `Source`).
   *
   * This is the extension point for determining that a node must be empty and
   * therefor is allowed to be modified if the tracked default value is non-empty.
   */
  abstract class MustBeEmpty extends DataFlow::Node { }

  /**
   * A sanitizer for detecting modifications of a parameters default value
   * should determine if the node (which is perhaps about to be modified)
   * can be the default value or not.
   *
   * In this query we do not track the default value exactly, but rather whether
   * it is empty or not (see `Source`).
   *
   * This is the extension point for determining that a node must be non-empty
   * and therefor is allowed to be modified if the tracked default value is empty.
   */
  abstract class MustBeNonEmpty extends DataFlow::Node { }

  /** Gets the truthiness (non emptiness) of the default of `p` if that value is mutable */
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

    MutableDefaultValue() {
      nonEmpty = mutableDefaultValue(this.asCfgNode().(Cfg::NameNode).getNode()) and
      // Ignore sources inside the standard library. These are unlikely to be true positives.
      exists(this.getLocation().getFile().getRelativePath())
    }

    override boolean isNonEmpty() { result = nonEmpty }
  }

  /**
   * Gets the name of a list function that modifies the list.
   * See https://docs.python.org/3/tutorial/datastructures.html#more-on-lists
   */
  string list_modifying_method() {
    result in ["append", "extend", "insert", "remove", "pop", "clear", "sort", "reverse"]
  }

  /**
   * Gets the name of a dict function that modifies the dict.
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
      exists(Cfg::DefinitionNode d | d.(Cfg::SubscriptNode).getObject() = this.asCfgNode())
      or
      // deletion of a subscript
      exists(Cfg::DeletionNode d | d.(Cfg::SubscriptNode).getObject() = this.asCfgNode())
      or
      // augmented assignment to the value
      exists(AugAssign a | this.asCfgNode().getNode() = a.getTarget())
      or
      // modifying function call
      exists(DataFlow::CallCfgNode c, DataFlow::AttrRead a | c.getFunction() = a |
        a.getObject() = this and
        a.getAttributeName() in [list_modifying_method(), dict_modifying_method()]
      )
    }
  }

  /**
   * Holds if `g` is a direct truthiness check that proves its (single
   * operand-and-result) value truthy on the `true` branch — i.e. `if g:`.
   */
  private predicate truthyGuard(DataFlow::GuardNode g, Cfg::ControlFlowNode node, boolean branch) {
    node = g and branch = true
  }

  /** Holds if `g` is a direct falsiness check — i.e. `if g:` taken to the false branch. */
  private predicate falseyGuard(DataFlow::GuardNode g, Cfg::ControlFlowNode node, boolean branch) {
    node = g and branch = false
  }

  /** Simple guard detecting truthy values. */
  private class MustBeTruthy extends MustBeNonEmpty {
    MustBeTruthy() { this = DataFlow::BarrierGuard<truthyGuard/3>::getABarrierNode() }
  }

  /** Simple guard detecting falsey values. */
  private class MustBeFalsey extends MustBeEmpty {
    MustBeFalsey() { this = DataFlow::BarrierGuard<falseyGuard/3>::getABarrierNode() }
  }
}

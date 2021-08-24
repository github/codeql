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
  abstract class Source extends DataFlow::Node { }

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
  abstract class BarrierGuard extends DataFlow::BarrierGuard { }

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
   * A source of remote user input, considered as a flow source.
   */
  class MutableDefaultValue extends Source {
    boolean nonEmpty;

    MutableDefaultValue() { nonEmpty = mutableDefaultValue(this.asCfgNode().(NameNode).getNode()) }
  }

  predicate safe_method(string name) {
    name = "count" or
    name = "index" or
    name = "copy" or
    name = "get" or
    name = "has_key" or
    name = "items" or
    name = "keys" or
    name = "values" or
    name = "iteritems" or
    name = "iterkeys" or
    name = "itervalues" or
    name = "__contains__" or
    name = "__getitem__" or
    name = "__getattribute__"
  }

  /**
   * A mutation is considered a flow sink.
   */
  class Mutation extends Sink {
    Mutation() {
      exists(AugAssign a | a.getTarget().getAFlowNode() = this.asCfgNode())
      or
      exists(Call c, Attribute a | c.getFunc() = a |
        a.getObject().getAFlowNode() = this.asCfgNode() and
        not safe_method(a.getName())
      )
    }
  }
}

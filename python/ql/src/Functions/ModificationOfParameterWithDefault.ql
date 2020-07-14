/**
 * @name Modification of parameter with default
 * @description Modifying the default value of a parameter can lead to unexpected
 *              results.
 * @kind path-problem
 * @tags reliability
 *       maintainability
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/modification-of-default-value
 */

import python
import semmle.python.security.Paths

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

class NonEmptyMutableValue extends TaintKind {
  NonEmptyMutableValue() { this = "non-empty mutable value" }
}

class EmptyMutableValue extends TaintKind {
  EmptyMutableValue() { this = "empty mutable value" }

  override boolean booleanValue() { result = false }
}

class MutableDefaultValue extends TaintSource {
  boolean nonEmpty;

  MutableDefaultValue() { nonEmpty = mutableDefaultValue(this.(NameNode).getNode()) }

  override string toString() { result = "mutable default value" }

  override predicate isSourceOf(TaintKind kind) {
    nonEmpty = false and kind instanceof EmptyMutableValue
    or
    nonEmpty = true and kind instanceof NonEmptyMutableValue
  }
}

private ClassValue mutable_class() {
  result = Value::named("list") or
  result = Value::named("dict")
}

class Mutation extends TaintSink {
  Mutation() {
    exists(AugAssign a | a.getTarget().getAFlowNode() = this)
    or
    exists(Call c, Attribute a | c.getFunc() = a |
      a.getObject().getAFlowNode() = this and
      not safe_method(a.getName()) and
      this.(ControlFlowNode).pointsTo().getClass() = mutable_class()
    )
  }

  override predicate sinks(TaintKind kind) {
    kind instanceof EmptyMutableValue
    or
    kind instanceof NonEmptyMutableValue
  }
}

from TaintedPathSource src, TaintedPathSink sink
where src.flowsTo(sink)
select sink.getSink(), src, sink, "$@ flows to here and is mutated.", src.getSource(),
  "Default value"

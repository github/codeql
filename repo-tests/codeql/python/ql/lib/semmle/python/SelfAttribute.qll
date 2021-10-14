/**
 * Utilities to support queries about instance attribute accesses of
 * the form `self.attr`.
 */

import python
private import semmle.python.pointsto.Filters

/**
 * An attribute access where the left hand side of the attribute expression
 * is `self`.
 */
class SelfAttribute extends Attribute {
  SelfAttribute() { self_attribute(this, _) }

  Class getClass() { self_attribute(this, result) }
}

/** Whether variable 'self' is the self variable in method 'method' */
private predicate self_variable(Function method, Variable self) {
  self.isParameter() and
  method.isMethod() and
  method.getArg(0).asName() = self.getAnAccess()
}

/** Whether attribute is an access of the form `self.attr` in the body of the class 'cls' */
private predicate self_attribute(Attribute attr, Class cls) {
  exists(Function f, Variable self | self_variable(f, self) |
    self.getAnAccess() = attr.getObject() and
    cls = f.getScope+()
  )
}

/** Helper class for UndefinedClassAttribute.ql &amp; MaybeUndefinedClassAttribute.ql */
class SelfAttributeRead extends SelfAttribute {
  SelfAttributeRead() {
    this.getCtx() instanceof Load and
    // Be stricter for loads.
    // We want to generous as to what is defined (i.e. stores),
    // but strict as to what needs to be defined (i.e. loads).
    exists(ClassObject cls, FunctionObject func | cls.declaredAttribute(_) = func |
      func.getFunction() = this.getScope() and
      cls.getPyClass() = this.getClass()
    )
  }

  predicate guardedByHasattr() {
    exists(Variable var, ControlFlowNode n |
      var.getAUse() = this.getObject().getAFlowNode() and
      hasattr(n, var.getAUse(), this.getName()) and
      n.strictlyDominates(this.getAFlowNode())
    )
  }

  pragma[noinline]
  predicate locallyDefined() {
    exists(SelfAttributeStore store |
      this.getName() = store.getName() and
      this.getScope() = store.getScope()
    |
      store.getAFlowNode().strictlyDominates(this.getAFlowNode())
    )
  }
}

class SelfAttributeStore extends SelfAttribute {
  SelfAttributeStore() { this.getCtx() instanceof Store }

  Expr getAssignedValue() { exists(Assign a | a.getATarget() = this | result = a.getValue()) }
}

private predicate attr_assigned_in_method_arg_n(FunctionObject method, string name, int n) {
  exists(SsaVariable param |
    method.getFunction().getArg(n).asName() = param.getDefinition().getNode()
  |
    exists(AttrNode attr |
      attr.getObject(name) = param.getAUse() and
      attr.isStore()
    )
    or
    exists(CallNode call, FunctionObject callee, int m |
      callee.getArgumentForCall(call, m) = param.getAUse() and
      attr_assigned_in_method_arg_n(callee, name, m)
    )
  )
}

predicate attribute_assigned_in_method(FunctionObject method, string name) {
  attr_assigned_in_method_arg_n(method, name, 0)
}

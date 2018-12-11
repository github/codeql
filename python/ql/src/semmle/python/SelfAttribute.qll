/** Utilities to support queries about instance attribute accesses of
 * the form `self.attr`.
 */

import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.Filters

/** An attribute access where the left hand side of the attribute expression 
  * is `self`.
  */
class SelfAttribute extends Attribute {

    SelfAttribute() {
        self_attribute(this, _)
    }

    Class getClass() {
        self_attribute(this, result)
    }

}

/** Whether variable 'self' is the self variable in method 'method' */
private predicate self_variable(Function method, Variable self) {
    self.isParameter() and
    method.isMethod() and
    method.getArg(0).asName() = self.getAnAccess()
}

/** Whether attribute is an access of the form `self.attr` in the body of the class 'cls' */
private predicate self_attribute(Attribute attr, Class cls) {
    exists(Function f, Variable self |
        self_variable(f, self) |
        self.getAnAccess() = attr.getObject() and
        cls = f.getScope+()
    )
}

/** Helper class for UndefinedClassAttribute.ql &amp; MaybeUndefinedClassAttribute.ql */
class SelfAttributeRead extends SelfAttribute {

    SelfAttributeRead() {
        this.getCtx() instanceof Load and
        /* Be stricter for loads. 
         * We want to generous as to what is defined (ie stores),
         * but strict as to what needs to be defined (ie loads).
         */
        exists(ClassObject cls, FunctionObject func |
            cls.declaredAttribute(_) = func |
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

    pragma [noinline] predicate locallyDefined() {
        exists(SelfAttributeStore store |
            this.getName() = store.getName() and 
            this.getScope() = store.getScope() |
            store.getAFlowNode().strictlyDominates(this.getAFlowNode())
        )
    }

}

class SelfAttributeStore extends SelfAttribute {

    SelfAttributeStore() {
        this.getCtx() instanceof Store
    }

    Expr getAssignedValue() {
        exists(Assign a | a.getATarget() = this |
            result = a.getValue()
        )
    }

}

private Object object_getattribute() {
    py_cmembers_versioned(theObjectType(), "__getattribute__", result, major_version().toString())
}

/** Helper class for UndefinedClassAttribute.ql and MaybeUndefinedClassAttribute.ql */
class CheckClass extends ClassObject {

    private predicate ofInterest() {
        not this.unknowableAttributes() and
        not this.getPyClass().isProbableMixin() and
        this.getPyClass().isPublic() and
        not this.getPyClass().getScope() instanceof Function and
        not this.probablyAbstract() and
        not this.declaresAttribute("__new__") and
        not this.selfDictAssigns() and
        not this.lookupAttribute("__getattribute__") != object_getattribute() and
        not this.hasAttribute("__getattr__") and
        not this.selfSetattr() and
        /* If class overrides object.__init__, but we can't resolve it to a Python function then give up */
        forall(ClassObject sup |
            sup = this.getAnImproperSuperType() and
            sup.declaresAttribute("__init__") and
            not sup = theObjectType() |
            sup.declaredAttribute("__init__") instanceof PyFunctionObject
        )
    }

    predicate alwaysDefines(string name) {
        auto_name(name) or
        this.hasAttribute(name) or
        this.getAnImproperSuperType().assignedInInit(name) or
        this.getMetaClass().assignedInInit(name)
    }

    predicate sometimesDefines(string name) {
        this.alwaysDefines(name) or
        exists(SelfAttributeStore sa | 
            sa.getScope().getScope+() = this.getAnImproperSuperType().getPyClass() |
            name = sa.getName()
        )
    }

    private predicate selfDictAssigns() {
        exists(Assign a, SelfAttributeRead self_dict, Subscript sub | 
            self_dict.getName() = "__dict__" and
            ( 
              self_dict = sub.getObject() 
              or
              /* Indirect assignment via temporary variable */
              exists(SsaVariable v | 
                  v.getAUse() = sub.getObject().getAFlowNode() and 
                  v.getDefinition().(DefinitionNode).getValue() = self_dict.getAFlowNode()
              )
            ) and
            a.getATarget() = sub and
            exists(FunctionObject meth | meth = this.lookupAttribute(_) and a.getScope() = meth.getFunction())
        )
    }

    pragma [nomagic]
    private predicate monkeyPatched(string name) {
        exists(Attribute a |
             a.getCtx() instanceof Store and
             PointsTo::points_to(a.getObject().getAFlowNode(), _, this, _, _) and a.getName() = name
        )
    }

    private predicate selfSetattr() {
      exists(Call c, Name setattr, Name self, Function method |
          ( method.getScope() = this.getPyClass() or 
            method.getScope() = this.getASuperType().getPyClass()
          ) and
          c.getScope() = method and
          c.getFunc() = setattr and
          setattr.getId() = "setattr" and
          c.getArg(0) = self and
          self.getId() = "self"
      )
    }

  predicate interestingUndefined(SelfAttributeRead a) {
      exists(string name | name = a.getName() |
          interestingContext(a, name) and
          not this.definedInBlock(a.getAFlowNode().getBasicBlock(), name)
      )
  }

  private predicate interestingContext(SelfAttributeRead a, string name) {
      name = a.getName() and
      this.ofInterest() and
      this.getPyClass() = a.getScope().getScope() and
      not a.locallyDefined() and
      not a.guardedByHasattr() and
      a.getScope().isPublic() and
      not this.monkeyPatched(name) and
      not attribute_assigned_in_method(lookupAttribute("setUp"), name)
  }

  private predicate probablyAbstract() {
      this.getName().matches("Abstract%")
      or
      this.isAbstract()
  }

  private pragma[nomagic] predicate definitionInBlock(BasicBlock b, string name) {
      exists(SelfAttributeStore sa | 
          sa.getAFlowNode().getBasicBlock() = b and sa.getName() = name and sa.getClass() = this.getPyClass()
      )
      or
      exists(FunctionObject method | this.lookupAttribute(_) = method |
          attribute_assigned_in_method(method, name) and
          b = method.getACall().getBasicBlock()
      )
  }

  private pragma[nomagic] predicate definedInBlock(BasicBlock b, string name) {
      // manual specialisation: this is only called from interestingUndefined,
      // so we can push the context in from there, which must apply to a
      // SelfAttributeRead in the same scope
      exists(SelfAttributeRead a | 
          a.getScope() = b.getScope() and name = a.getName() |
          interestingContext(a, name)
      )
      and
      this.definitionInBlock(b, name)
      or
      exists(BasicBlock prev | this.definedInBlock(prev, name) and prev.getASuccessor() = b)
  }

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

private predicate auto_name(string name) {
  name = "__class__" or name = "__dict__"
}

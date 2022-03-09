import python
private import semmle.python.pointsto.PointsTo

/** A helper class for UndefinedClassAttribute.ql and MaybeUndefinedClassAttribute.ql */
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
      not sup = theObjectType()
    |
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
    this.alwaysDefines(name)
    or
    exists(SelfAttributeStore sa |
      sa.getScope().getScope+() = this.getAnImproperSuperType().getPyClass()
    |
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
      exists(FunctionObject meth |
        meth = this.lookupAttribute(_) and a.getScope() = meth.getFunction()
      )
    )
  }

  pragma[nomagic]
  private predicate monkeyPatched(string name) {
    exists(Attribute a |
      a.getCtx() instanceof Store and
      PointsTo::points_to(a.getObject().getAFlowNode(), _, this, _, _) and
      a.getName() = name
    )
  }

  private predicate selfSetattr() {
    exists(Call c, Name setattr, Name self, Function method |
      (
        method.getScope() = this.getPyClass() or
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
      this.interestingContext(a, name) and
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
    not attribute_assigned_in_method(this.lookupAttribute("setUp"), name)
  }

  private predicate probablyAbstract() {
    this.getName().matches("Abstract%")
    or
    this.isAbstract()
  }

  pragma[nomagic]
  private predicate definitionInBlock(BasicBlock b, string name) {
    exists(SelfAttributeStore sa |
      sa.getAFlowNode().getBasicBlock() = b and
      sa.getName() = name and
      sa.getClass() = this.getPyClass()
    )
    or
    exists(FunctionObject method | this.lookupAttribute(_) = method |
      attribute_assigned_in_method(method, name) and
      b = method.getACall().getBasicBlock()
    )
  }

  pragma[nomagic]
  private predicate definedInBlock(BasicBlock b, string name) {
    // manual specialisation: this is only called from interestingUndefined,
    // so we can push the context in from there, which must apply to a
    // SelfAttributeRead in the same scope
    exists(SelfAttributeRead a | a.getScope() = b.getScope() and name = a.getName() |
      this.interestingContext(a, name)
    ) and
    this.definitionInBlock(b, name)
    or
    exists(BasicBlock prev | this.definedInBlock(prev, name) and prev.getASuccessor() = b)
  }
}

private Object object_getattribute() {
  result.asBuiltin() = theObjectType().asBuiltin().getMember("__getattribute__")
}

private predicate auto_name(string name) { name = "__class__" or name = "__dict__" }

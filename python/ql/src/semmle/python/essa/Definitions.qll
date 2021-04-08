import python

/*
 * Classification of variables. These should be non-overlapping and complete.
 *
 * Function local variables - Non escaping variables in a function, except 'self'
 * Self variables - The 'self' variable for a method.
 * Class local variables - Local variables declared in a class
 * Non-local variables - Escaping variables in a function
 * Built-in variables - Global variables with no definition
 * Non-escaping globals -- Global variables that have definitions and all of those definitions are in the module scope
 * Escaping globals -- Global variables that have definitions and at least one of those definitions is in another scope.
 */

/** A source language variable, to be converted into a set of SSA variables. */
abstract class SsaSourceVariable extends @py_variable {
  SsaSourceVariable() {
    /* Exclude `True`, `False` and `None` */
    not this.(Variable).getALoad() instanceof NameConstant
  }

  /** Gets the name of this variable */
  string getName() { variable(this, _, result) }

  Scope getScope() { variable(this, result, _) }

  /** Gets an implicit use of this variable */
  abstract ControlFlowNode getAnImplicitUse();

  abstract ControlFlowNode getScopeEntryDefinition();

  /** Gets a textual representation of this element. */
  string toString() { result = "SsaSourceVariable " + this.getName() }

  /** Gets a use of this variable, either explicit or implicit. */
  ControlFlowNode getAUse() {
    result = this.getASourceUse()
    or
    result = this.getAnImplicitUse()
    or
    /*
     * `import *` is a definition of *all* variables, so must be a use as well, for pass-through
     * once we have established that a variable is not redefined.
     */

    SsaSource::import_star_refinement(this, result, _)
    or
    /*
     * Add a use at the end of scope for all variables to keep them live
     * This is necessary for taint-tracking.
     */

    result = this.getScope().getANormalExit()
  }

  /** Holds if `def` defines an ESSA variable for this variable. */
  predicate hasDefiningNode(ControlFlowNode def) {
    def = this.getScopeEntryDefinition()
    or
    SsaSource::assignment_definition(this, def, _)
    or
    SsaSource::multi_assignment_definition(this, def, _, _)
    or
    SsaSource::deletion_definition(this, def)
    or
    SsaSource::init_module_submodule_defn(this, def)
    or
    SsaSource::parameter_definition(this, def)
    or
    SsaSource::exception_capture(this, def)
    or
    SsaSource::with_definition(this, def)
  }

  /**
   * Holds if `def` defines an ESSA variable for this variable in such a way
   * that the new variable is a refinement in some way of the variable used at `use`.
   */
  predicate hasRefinement(ControlFlowNode use, ControlFlowNode def) {
    this.hasDefiningNode(_) and
    /* Can't have a refinement unless there is a definition */
    refinement(this, use, def)
  }

  /**
   * Holds if the edge `pred`->`succ` defines an ESSA variable for this variable in such a way
   * that the new variable is a refinement in some way of the variable used at `use`.
   */
  predicate hasRefinementEdge(ControlFlowNode use, BasicBlock pred, BasicBlock succ) {
    test_contains(pred.getLastNode(), use) and
    use.(NameNode).uses(this) and
    (pred.getAFalseSuccessor() = succ or pred.getATrueSuccessor() = succ) and
    /* There is a store to this variable -- We don't want to refine builtins */
    exists(this.(Variable).getAStore())
  }

  /** Gets a use of this variable that corresponds to an explicit use in the source. */
  ControlFlowNode getASourceUse() {
    result.(NameNode).uses(this)
    or
    result.(NameNode).deletes(this)
  }

  abstract CallNode redefinedAtCallSite();
}

private predicate refinement(SsaSourceVariable v, ControlFlowNode use, ControlFlowNode def) {
  SsaSource::import_star_refinement(v, use, def)
  or
  SsaSource::attribute_assignment_refinement(v, use, def)
  or
  SsaSource::argument_refinement(v, use, def)
  or
  SsaSource::attribute_deletion_refinement(v, use, def)
  or
  SsaSource::test_refinement(v, use, def)
  or
  SsaSource::method_call_refinement(v, use, def)
  or
  def = v.redefinedAtCallSite() and def = use
}

class FunctionLocalVariable extends SsaSourceVariable {
  FunctionLocalVariable() {
    this.(LocalVariable).getScope() instanceof Function and
    not this instanceof NonLocalVariable
  }

  override ControlFlowNode getAnImplicitUse() {
    this.(Variable).isSelf() and this.(Variable).getScope().getANormalExit() = result
  }

  override ControlFlowNode getScopeEntryDefinition() {
    exists(Scope s | s.getEntryNode() = result |
      s = this.(LocalVariable).getScope() and
      not this.(LocalVariable).isParameter()
      or
      s != this.(LocalVariable).getScope() and
      s = this.(LocalVariable).getALoad().getScope()
    )
  }

  override CallNode redefinedAtCallSite() { none() }
}

class NonLocalVariable extends SsaSourceVariable {
  NonLocalVariable() {
    exists(Function f |
      this.(LocalVariable).getScope() = f and
      this.(LocalVariable).getAStore().getScope() != f
    )
  }

  override ControlFlowNode getAnImplicitUse() {
    result.(CallNode).getScope().getScope*() = this.(LocalVariable).getScope()
  }

  override ControlFlowNode getScopeEntryDefinition() {
    exists(Function f |
      f.getScope+() = this.(LocalVariable).getScope() and
      f.getEntryNode() = result
    )
    or
    not this.(LocalVariable).isParameter() and
    this.(LocalVariable).getScope().getEntryNode() = result
  }

  pragma[noinline]
  Scope scope_as_local_variable() { result = this.(LocalVariable).getScope() }

  override CallNode redefinedAtCallSite() {
    result.getScope().getScope*() = this.scope_as_local_variable()
  }
}

class ClassLocalVariable extends SsaSourceVariable {
  ClassLocalVariable() { this.(LocalVariable).getScope() instanceof Class }

  override ControlFlowNode getAnImplicitUse() { none() }

  override ControlFlowNode getScopeEntryDefinition() {
    result = this.(LocalVariable).getScope().getEntryNode()
  }

  override CallNode redefinedAtCallSite() { none() }
}

class BuiltinVariable extends SsaSourceVariable {
  BuiltinVariable() {
    this instanceof GlobalVariable and
    not exists(this.(Variable).getAStore()) and
    not this.(Variable).getId() = "__name__" and
    not this.(Variable).getId() = "__package__" and
    not exists(ImportStar is | is.getScope() = this.(Variable).getScope())
  }

  override ControlFlowNode getAnImplicitUse() { none() }

  override ControlFlowNode getScopeEntryDefinition() { none() }

  override CallNode redefinedAtCallSite() { none() }
}

class ModuleVariable extends SsaSourceVariable {
  ModuleVariable() {
    this instanceof GlobalVariable and
    (
      exists(this.(Variable).getAStore())
      or
      this.(Variable).getId() = "__name__"
      or
      this.(Variable).getId() = "__package__"
      or
      exists(ImportStar is | is.getScope() = this.(Variable).getScope())
    )
  }

  pragma[noinline]
  CallNode global_variable_callnode() { result.getScope() = this.(GlobalVariable).getScope() }

  pragma[noinline]
  ImportMemberNode global_variable_import() {
    result.getScope() = this.(GlobalVariable).getScope() and
    import_from_dot_in_init(result.(ImportMemberNode).getModule(this.getName()))
  }

  override ControlFlowNode getAnImplicitUse() {
    result = global_variable_callnode()
    or
    result = global_variable_import()
    or
    exists(ImportTimeScope scope | scope.entryEdge(result, _) |
      this = scope.getOuterVariable(_) or
      this.(Variable).getAUse().getScope() = scope
    )
    or
    /* For implicit use of __metaclass__ when constructing class */
    exists(Class c |
      class_with_global_metaclass(c, this) and
      c.(ImportTimeScope).entryEdge(result, _)
    )
    or
    exists(ImportTimeScope s |
      result = s.getANormalExit() and
      this.(Variable).getScope() = s and
      implicit_definition(this)
    )
  }

  override ControlFlowNode getScopeEntryDefinition() {
    exists(Scope s | s.getEntryNode() = result |
      /* Module entry point */
      this.(GlobalVariable).getScope() = s
      or
      /* For implicit use of __metaclass__ when constructing class */
      class_with_global_metaclass(s, this)
      or
      /* Variable is used in scope */
      this.(GlobalVariable).getAUse().getScope() = s
    )
    or
    exists(ImportTimeScope scope | scope.entryEdge(_, result) |
      this = scope.getOuterVariable(_) or
      this.(Variable).getAUse().getScope() = scope
    )
  }

  override CallNode redefinedAtCallSite() { none() }
}

class NonEscapingGlobalVariable extends ModuleVariable {
  NonEscapingGlobalVariable() {
    this instanceof GlobalVariable and
    exists(this.(Variable).getAStore()) and
    not variable_or_attribute_defined_out_of_scope(this)
  }
}

class EscapingGlobalVariable extends ModuleVariable {
  EscapingGlobalVariable() {
    this instanceof GlobalVariable and
    exists(this.(Variable).getAStore()) and
    variable_or_attribute_defined_out_of_scope(this)
  }

  override ControlFlowNode getAnImplicitUse() {
    result = ModuleVariable.super.getAnImplicitUse()
    or
    result.(CallNode).getScope().getScope+() = this.(GlobalVariable).getScope()
    or
    result = this.innerScope().getANormalExit()
  }

  private Scope innerScope() {
    result.getScope+() = this.(GlobalVariable).getScope() and
    not result instanceof ImportTimeScope
  }

  override ControlFlowNode getScopeEntryDefinition() {
    result = ModuleVariable.super.getScopeEntryDefinition()
    or
    result = this.innerScope().getEntryNode()
  }

  pragma[noinline]
  Scope scope_as_global_variable() { result = this.(GlobalVariable).getScope() }

  override CallNode redefinedAtCallSite() {
    result.(CallNode).getScope().getScope*() = this.scope_as_global_variable()
  }
}

class EscapingAssignmentGlobalVariable extends EscapingGlobalVariable {
  EscapingAssignmentGlobalVariable() {
    exists(NameNode n | n.defines(this) and not n.getScope() = this.getScope())
  }
}

class SpecialSsaSourceVariable extends SsaSourceVariable {
  SpecialSsaSourceVariable() { variable(this, _, "*") or variable(this, _, "$") }

  override ControlFlowNode getAnImplicitUse() {
    exists(ImportTimeScope s | result = s.getANormalExit() and this.getScope() = s)
  }

  override ControlFlowNode getScopeEntryDefinition() {
    /* Module entry point */
    this.getScope().getEntryNode() = result
  }

  pragma[noinline]
  Scope scope_as_global_variable() { result = this.(GlobalVariable).getScope() }

  override CallNode redefinedAtCallSite() {
    result.(CallNode).getScope().getScope*() = this.scope_as_global_variable()
  }
}

/** Holds if this variable is implicitly defined */
private predicate implicit_definition(Variable v) {
  v.getId() = "*" or
  v.getId() = "$" or
  exists(ImportStar is | is.getScope() = v.getScope())
}

private predicate variable_or_attribute_defined_out_of_scope(Variable v) {
  exists(NameNode n | n.defines(v) and not n.getScope() = v.getScope())
  or
  exists(AttrNode a |
    a.isStore() and a.getObject() = v.getAUse() and not a.getScope() = v.getScope()
  )
}

private predicate class_with_global_metaclass(Class cls, GlobalVariable metaclass) {
  metaclass.getId() = "__metaclass__" and
  major_version() = 2 and
  cls.getEnclosingModule() = metaclass.getScope()
}

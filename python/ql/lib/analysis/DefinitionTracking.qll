/**
 * Definition tracking for jump-to-defn query.
 */

import python
import semmle.python.pointsto.PointsTo
import IDEContextual

private newtype TDefinition =
  TLocalDefinition(AstNode a) { a instanceof Expr or a instanceof Stmt or a instanceof Module }

/** A definition for the purposes of jump-to-definition. */
class Definition extends TLocalDefinition {
  /** Gets a textual representation of this element. */
  string toString() { result = "Definition " + this.getAstNode().getLocation().toString() }

  /** Gets the AST Node associated with this element */
  AstNode getAstNode() { this = TLocalDefinition(result) }

  /** Gets the Module associated with this element */
  Module getModule() { result = this.getAstNode().getScope().getEnclosingModule() }

  /** Gets the source location of the AST Node associated with this element */
  Location getLocation() { result = this.getAstNode().getLocation() }
}

private predicate jump_to_defn(ControlFlowNode use, Definition defn) {
  exists(EssaVariable var |
    use = var.getASourceUse() and
    ssa_variable_defn(var, defn)
  )
  or
  exists(string name |
    use.isLoad() and
    jump_to_defn_attribute(use.(AttrNode).getObject(name), name, defn)
  )
  or
  exists(PythonModuleObject mod |
    use.(ImportExprNode).refersTo(mod) and
    defn.getAstNode() = mod.getModule()
  )
  or
  exists(PythonModuleObject mod, string name |
    use.(ImportMemberNode).getModule(name).refersTo(mod) and
    scope_jump_to_defn_attribute(mod.getModule(), name, defn)
  )
  or
  exists(PackageObject package |
    use.(ImportExprNode).refersTo(package) and
    defn.getAstNode() = package.getInitModule().getModule()
  )
  or
  exists(PackageObject package, string name |
    use.(ImportMemberNode).getModule(name).refersTo(package) and
    scope_jump_to_defn_attribute(package.getInitModule().getModule(), name, defn)
  )
  or
  (use instanceof PyFunctionObject or use instanceof ClassObject) and
  defn.getAstNode() = use.getNode()
}

/* Prefer class and functions to class-expressions and function-expressions. */
private predicate preferred_jump_to_defn(Expr use, Definition def) {
  not use instanceof ClassExpr and
  not use instanceof FunctionExpr and
  jump_to_defn(use.getAFlowNode(), def)
}

private predicate unique_jump_to_defn(Expr use, Definition def) {
  preferred_jump_to_defn(use, def) and
  not exists(Definition other |
    other != def and
    preferred_jump_to_defn(use, other)
  )
}

private predicate ssa_variable_defn(EssaVariable var, Definition defn) {
  ssa_defn_defn(var.getDefinition(), defn)
}

/** Holds if the phi-function `phi` refers to (`value`, `cls`, `origin`) given the context `context`. */
private predicate ssa_phi_defn(PhiFunction phi, Definition defn) {
  ssa_variable_defn(phi.getAnInput(), defn)
}

/** Holds if the ESSA defn `def`  refers to (`value`, `cls`, `origin`) given the context `context`. */
private predicate ssa_defn_defn(EssaDefinition def, Definition defn) {
  ssa_phi_defn(def, defn)
  or
  ssa_node_defn(def, defn)
  or
  ssa_filter_defn(def, defn)
  or
  ssa_node_refinement_defn(def, defn)
}

/** Holds if ESSA edge refinement, `def`, is defined by `defn` */
predicate ssa_filter_defn(PyEdgeRefinement def, Definition defn) {
  ssa_variable_defn(def.getInput(), defn)
}

/** Holds if ESSA defn, `uniphi`,is defined by `defn` */
predicate uni_edged_phi_defn(SingleSuccessorGuard uniphi, Definition defn) {
  ssa_variable_defn(uniphi.getInput(), defn)
}

pragma[noinline]
private predicate ssa_node_defn(EssaNodeDefinition def, Definition defn) {
  assignment_jump_to_defn(def, defn)
  or
  parameter_defn(def, defn)
  or
  delete_defn(def, defn)
  or
  scope_entry_defn(def, defn)
  or
  implicit_submodule_defn(def, defn)
}

/* Definition for normal assignments `def = ...` */
private predicate assignment_jump_to_defn(AssignmentDefinition def, Definition defn) {
  defn = TLocalDefinition(def.getValue().getNode())
}

pragma[noinline]
private predicate ssa_node_refinement_defn(EssaNodeRefinement def, Definition defn) {
  method_callsite_defn(def, defn)
  or
  import_star_defn(def, defn)
  or
  attribute_assignment_defn(def, defn)
  or
  callsite_defn(def, defn)
  or
  argument_defn(def, defn)
  or
  attribute_delete_defn(def, defn)
  or
  uni_edged_phi_defn(def, defn)
}

/* Definition for parameter. `def foo(param): ...` */
private predicate parameter_defn(ParameterDefinition def, Definition defn) {
  defn.getAstNode() = def.getDefiningNode().getNode()
}

/* Definition for deletion: `del name` */
private predicate delete_defn(DeletionDefinition def, Definition defn) { none() }

/* Implicit "defn" of the names of submodules at the start of an `__init__.py` file. */
private predicate implicit_submodule_defn(ImplicitSubModuleDefinition def, Definition defn) {
  exists(PackageObject package, ModuleObject mod |
    package.getInitModule().getModule() = def.getDefiningNode().getScope() and
    mod = package.submodule(def.getSourceVariable().getName()) and
    defn.getAstNode() = mod.getModule()
  )
}

/*
 * Helper for scope_entry_value_transfer(...).
 * Transfer of values from the callsite to the callee, for enclosing variables, but not arguments/parameters
 */

private predicate scope_entry_value_transfer_at_callsite(
  EssaVariable pred_var, ScopeEntryDefinition succ_def
) {
  exists(CallNode callsite, FunctionObject f |
    f.getACall() = callsite and
    pred_var.getSourceVariable() = succ_def.getSourceVariable() and
    pred_var.getAUse() = callsite and
    succ_def.getDefiningNode() = f.getFunction().getEntryNode()
  )
}

/* Model the transfer of values at scope-entry points. Transfer from `pred_var, pred_context` to `succ_def, succ_context` */
private predicate scope_entry_value_transfer(EssaVariable pred_var, ScopeEntryDefinition succ_def) {
  BaseFlow::scope_entry_value_transfer_from_earlier(pred_var, _, succ_def, _)
  or
  scope_entry_value_transfer_at_callsite(pred_var, succ_def)
  or
  class_entry_value_transfer(pred_var, succ_def)
}

/* Helper for scope_entry_value_transfer */
private predicate class_entry_value_transfer(EssaVariable pred_var, ScopeEntryDefinition succ_def) {
  exists(ImportTimeScope scope, ControlFlowNode class_def |
    class_def = pred_var.getAUse() and
    scope.entryEdge(class_def, succ_def.getDefiningNode()) and
    pred_var.getSourceVariable() = succ_def.getSourceVariable()
  )
}

/* Definition for implicit variable declarations at scope-entry. */
pragma[noinline]
private predicate scope_entry_defn(ScopeEntryDefinition def, Definition defn) {
  /* Transfer from another scope */
  exists(EssaVariable var |
    scope_entry_value_transfer(var, def) and
    ssa_variable_defn(var, defn)
  )
}

/*
 * Definition for a variable (possibly) redefined by a call:
 * Just assume that call does not define variable
 */

pragma[noinline]
private predicate callsite_defn(CallsiteRefinement def, Definition defn) {
  ssa_variable_defn(def.getInput(), defn)
}

/* Pass through for `self` for the implicit re-defn of `self` in `self.foo()` */
private predicate method_callsite_defn(MethodCallsiteRefinement def, Definition defn) {
  /* The value of self remains the same, only the attributes may change */
  ssa_variable_defn(def.getInput(), defn)
}

/** Helpers for import_star_defn */
pragma[noinline]
private predicate module_and_name_for_import_star(
  ModuleObject mod, string name, ImportStarRefinement def
) {
  module_and_name_for_import_star_helper(mod, name, _, def) and
  mod.exports(name)
}

pragma[noinline]
private predicate module_and_name_for_import_star_helper(
  ModuleObject mod, string name, ImportStarNode im_star, ImportStarRefinement def
) {
  im_star = def.getDefiningNode() and
  im_star.getModule().refersTo(mod) and
  name = def.getSourceVariable().getName()
}

/** Holds if `def` is technically a defn of `var`, but the `from ... import *` does not in fact define `var` */
pragma[noinline]
private predicate variable_not_redefined_by_import_star(EssaVariable var, ImportStarRefinement def) {
  var = def.getInput() and
  exists(ModuleObject mod |
    def.getDefiningNode().(ImportStarNode).getModule().refersTo(mod) and
    not mod.exports(var.getSourceVariable().getName())
  )
}

/* Definition for `from ... import *` */
private predicate import_star_defn(ImportStarRefinement def, Definition defn) {
  exists(ModuleObject mod, string name | module_and_name_for_import_star(mod, name, def) |
    /* Attribute from imported module */
    scope_jump_to_defn_attribute(mod.getModule(), name, defn)
  )
  or
  exists(EssaVariable var |
    /* Retain value held before import */
    variable_not_redefined_by_import_star(var, def) and
    ssa_variable_defn(var, defn)
  )
}

/** Attribute assignments have no effect as far as defn tracking is concerned */
private predicate attribute_assignment_defn(AttributeAssignment def, Definition defn) {
  ssa_variable_defn(def.getInput(), defn)
}

/** Ignore the effects of calls on their arguments. This is an approximation, but attempting to improve accuracy would be very expensive for very little gain. */
private predicate argument_defn(ArgumentRefinement def, Definition defn) {
  ssa_variable_defn(def.getInput(), defn)
}

/** Attribute deletions have no effect as far as value tracking is concerned. */
pragma[noinline]
private predicate attribute_delete_defn(EssaAttributeDeletion def, Definition defn) {
  ssa_variable_defn(def.getInput(), defn)
}

/*
 * Definition flow for attributes. These mirror the "normal" defn predicates.
 * For each defn predicate `xxx_defn(XXX def, Definition defn)`
 * There is an equivalent predicate that tracks the values in attributes:
 * `xxx_jump_to_defn_attribute(XXX def, string name, Definition defn)`
 */

/**
 * INTERNAL -- Public for testing only.
 * Holds if the attribute `name` of the ssa variable `var` refers to (`value`, `cls`, `origin`)
 */
predicate ssa_variable_jump_to_defn_attribute(EssaVariable var, string name, Definition defn) {
  ssa_defn_jump_to_defn_attribute(var.getDefinition(), name, defn)
}

/** Helper for ssa_variable_jump_to_defn_attribute */
private predicate ssa_defn_jump_to_defn_attribute(EssaDefinition def, string name, Definition defn) {
  ssa_phi_jump_to_defn_attribute(def, name, defn)
  or
  ssa_node_jump_to_defn_attribute(def, name, defn)
  or
  ssa_node_refinement_jump_to_defn_attribute(def, name, defn)
  or
  ssa_filter_jump_to_defn_attribute(def, name, defn)
}

/** Holds if ESSA edge refinement, `def`, is defined by `defn` of `priority` */
predicate ssa_filter_jump_to_defn_attribute(PyEdgeRefinement def, string name, Definition defn) {
  ssa_variable_jump_to_defn_attribute(def.getInput(), name, defn)
}

/** Holds if the attribute `name` of the ssa phi-function defn `phi` refers to (`value`, `cls`, `origin`) */
private predicate ssa_phi_jump_to_defn_attribute(PhiFunction phi, string name, Definition defn) {
  ssa_variable_jump_to_defn_attribute(phi.getAnInput(), name, defn)
}

/** Helper for ssa_defn_jump_to_defn_attribute */
pragma[noinline]
private predicate ssa_node_jump_to_defn_attribute(
  EssaNodeDefinition def, string name, Definition defn
) {
  assignment_jump_to_defn_attribute(def, name, defn)
  or
  self_parameter_jump_to_defn_attribute(def, name, defn)
  or
  scope_entry_jump_to_defn_attribute(def, name, defn)
}

/** Helper for ssa_defn_jump_to_defn_attribute */
pragma[noinline]
private predicate ssa_node_refinement_jump_to_defn_attribute(
  EssaNodeRefinement def, string name, Definition defn
) {
  attribute_assignment_jump_to_defn_attribute(def, name, defn)
  or
  argument_jump_to_defn_attribute(def, name, defn)
}

pragma[noinline]
private predicate scope_entry_jump_to_defn_attribute(
  ScopeEntryDefinition def, string name, Definition defn
) {
  exists(EssaVariable var |
    scope_entry_value_transfer(var, def) and
    ssa_variable_jump_to_defn_attribute(var, name, defn)
  )
}

private predicate scope_jump_to_defn_attribute(ImportTimeScope s, string name, Definition defn) {
  exists(EssaVariable var |
    BaseFlow::reaches_exit(var) and
    var.getScope() = s and
    var.getName() = name
  |
    ssa_variable_defn(var, defn)
  )
}

private predicate jump_to_defn_attribute(ControlFlowNode use, string name, Definition defn) {
  /* Local attribute */
  exists(EssaVariable var |
    use = var.getASourceUse() and
    ssa_variable_jump_to_defn_attribute(var, name, defn)
  )
  or
  /* Instance attributes */
  exists(ClassObject cls | use.refersTo(_, cls, _) |
    scope_jump_to_defn_attribute(cls.getPyClass(), name, defn)
  )
  or
  /* Super attributes */
  exists(AttrNode f, SuperBoundMethod sbm, Object function |
    use = f.getObject(name) and
    f.refersTo(sbm) and
    function = sbm.getFunction(_) and
    function.getOrigin() = defn.getAstNode()
  )
  or
  /* Class or module attribute */
  exists(Object obj, Scope scope |
    use.refersTo(obj) and
    scope_jump_to_defn_attribute(scope, name, defn)
  |
    obj.(ClassObject).getPyClass() = scope
    or
    obj.(PythonModuleObject).getModule() = scope
    or
    obj.(PackageObject).getInitModule().getModule() = scope
  )
}

pragma[noinline]
private predicate assignment_jump_to_defn_attribute(
  AssignmentDefinition def, string name, Definition defn
) {
  jump_to_defn_attribute(def.getValue(), name, defn)
}

pragma[noinline]
private predicate attribute_assignment_jump_to_defn_attribute(
  AttributeAssignment def, string name, Definition defn
) {
  defn.getAstNode() = def.getDefiningNode().getNode() and name = def.getName()
  or
  ssa_variable_jump_to_defn_attribute(def.getInput(), name, defn) and not name = def.getName()
}

/**
 * Holds if `def` defines the attribute `name`
 * `def` takes the form `setattr(use, "name")` where `use` is the input to the defn.
 */
private predicate sets_attribute(ArgumentRefinement def, string name) {
  exists(CallNode call |
    call = def.getDefiningNode() and
    call.getFunction().refersTo(Object::builtin("setattr")) and
    def.getInput().getAUse() = call.getArg(0) and
    call.getArg(1).getNode().(StringLiteral).getText() = name
  )
}

pragma[noinline]
private predicate argument_jump_to_defn_attribute(
  ArgumentRefinement def, string name, Definition defn
) {
  if sets_attribute(def, name)
  then jump_to_defn(def.getDefiningNode().(CallNode).getArg(2), defn)
  else ssa_variable_jump_to_defn_attribute(def.getInput(), name, defn)
}

/** Gets the (temporally) preceding variable for "self", e.g. `def` is in method foo() and `result` is in `__init__()`. */
private EssaVariable preceding_self_variable(ParameterDefinition def) {
  def.isSelf() and
  exists(Function preceding, Function method |
    method = def.getScope() and
    // Only methods
    preceding.isMethod() and
    preceding.precedes(method) and
    BaseFlow::reaches_exit(result) and
    result.getSourceVariable().(Variable).isSelf() and
    result.getScope() = preceding
  )
}

pragma[noinline]
private predicate self_parameter_jump_to_defn_attribute(
  ParameterDefinition def, string name, Definition defn
) {
  ssa_variable_jump_to_defn_attribute(preceding_self_variable(def), name, defn)
}

/**
 * Gets a definition for 'use'.
 * This exists primarily for testing use `getPreferredDefinition()` instead.
 */
Definition getADefinition(Expr use) {
  jump_to_defn(use.getAFlowNode(), result) and
  not use instanceof Call and
  not use.isArtificial() and
  // Not the use itself
  not result = TLocalDefinition(use)
}

/**
 * Gets the unique definition for 'use', if one can be found.
 * Helper for the jump-to-definition query.
 */
Definition getUniqueDefinition(Expr use) {
  unique_jump_to_defn(use, result) and
  not use instanceof Call and
  not use.isArtificial() and
  // Not the use itself
  not result = TLocalDefinition(use)
}

/** A helper class to get suitable locations for attributes */
class NiceLocationExpr extends Expr {
  /** Gets a textual representation of this element. */
  override string toString() { result = this.(Expr).toString() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `bc` of line `bl` to
   * column `ec` of line `el` in file `f`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(string f, int bl, int bc, int el, int ec) {
    /* Attribute location for x.y is that of 'y' so that url does not overlap with that of 'x' */
    this.(Attribute).getLocation().hasLocationInfo(f, _, _, el, ec) and
    bl = el and
    bc = ec - this.(Attribute).getName().length() + 1
    or
    this.(Name).getLocation().hasLocationInfo(f, bl, bc, el, ec)
    or
    // Show xxx for `xxx` in `from xxx import y` or
    // for `import xxx` or for `import xxx as yyy`.
    this.(ImportExpr).getLocation().hasLocationInfo(f, bl, bc, el, ec)
    or
    // Show y for `y` in `from xxx import y`
    // and y for `yyy as y` in `from xxx import yyy as y`.
    exists(string name, Alias alias |
      // This alias will always exist, as `from xxx import y`
      // is expanded to `from xxx imprt y as y`.
      this = alias.getValue() and
      name = alias.getAsname().(Name).getId()
    |
      this.(ImportMember).getLocation().hasLocationInfo(f, _, _, el, ec) and
      bl = el and
      bc = ec - name.length() + 1
    )
  }
}

/**
 * Gets the definition (of kind `kind`) for the expression `use`, if one can be found.
 */
cached
Definition definitionOf(NiceLocationExpr use, string kind) {
  exists(string f, int l |
    result = getUniqueDefinition(use) and
    kind = "Definition" and
    use.hasLocationInfo(f, l, _, _, _) and
    // Ignore if the definition is on the same line as the use
    not result.getLocation().hasLocationInfo(f, l, _, _, _)
  )
}

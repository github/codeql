/**
 * Provides classes and predicates for determining the uses and definitions of
 * variables for ESSA form.
 */

import python
private import semmle.python.pointsto.Base

cached
module SsaSource {
  /** Holds if `v` is used as the receiver in a method call. */
  cached
  predicate method_call_refinement(Variable v, ControlFlowNode use, CallNode call) {
    use = v.getAUse() and
    call.getFunction().(AttrNode).getObject() = use and
    not test_contains(_, call)
  }

  /** Holds if `v` is defined by assignment at `defn` and given `value`. */
  cached
  predicate assignment_definition(Variable v, ControlFlowNode defn, ControlFlowNode value) {
    defn.(NameNode).defines(v) and defn.(DefinitionNode).getValue() = value
  }

  /** Holds if `v` is defined by assignment of the captured exception. */
  cached
  predicate exception_capture(Variable v, NameNode defn) {
    defn.defines(v) and
    exists(ExceptFlowNode ex | ex.getName() = defn)
  }

  /** Holds if `v` is defined by a with statement. */
  cached
  predicate with_definition(Variable v, ControlFlowNode defn) {
    exists(With with, Name var |
      with.getOptionalVars() = var and
      var.getAFlowNode() = defn
    |
      var = v.getAStore()
    )
  }

  /** Holds if `v` is defined by multiple assignment at `defn`. */
  cached
  predicate multi_assignment_definition(Variable v, ControlFlowNode defn, int n, SequenceNode lhs) {
    (
      defn.(NameNode).defines(v)
      or
      defn.(StarredNode).getValue().(NameNode).defines(v)
    ) and
    not exists(defn.(DefinitionNode).getValue()) and
    lhs.getElement(n) = defn and
    lhs.getBasicBlock().dominates(defn.getBasicBlock())
  }

  /** Holds if `v` is defined by a `for` statement, the definition being `defn` */
  cached
  predicate iteration_defined_variable(Variable v, ControlFlowNode defn, ControlFlowNode sequence) {
    exists(ForNode for | for.iterates(defn, sequence)) and
    defn.(NameNode).defines(v)
  }

  /** Holds if `v` is a parameter variable and `defn` is the CFG node for that parameter. */
  cached
  predicate parameter_definition(Variable v, ControlFlowNode defn) {
    exists(Function f, Name param |
      f.getAnArg() = param or
      f.getVararg() = param or
      f.getKwarg() = param or
      f.getKeywordOnlyArg(_) = param
    |
      defn.getNode() = param and
      param.getVariable() = v
    )
  }

  /** Holds if `v` is deleted at `del`. */
  cached
  predicate deletion_definition(Variable v, DeletionNode del) {
    del.getTarget().(NameNode).deletes(v)
  }

  /**
   * Holds if the name of `var` refers to a submodule of a package and `f` is the entry point
   * to the __init__ module of that package.
   */
  cached
  predicate init_module_submodule_defn(SsaSourceVariable var, ControlFlowNode f) {
    var instanceof GlobalVariable and
    exists(Module init |
      init.isPackageInit() and
      exists(init.getPackage().getSubModule(var.getName())) and
      init.getEntryNode() = f and
      var.getScope() = init
    )
  }

  /** Holds if the `v` is in scope at a `from import ... *` and may thus be redefined by that statement */
  cached
  predicate import_star_refinement(SsaSourceVariable v, ControlFlowNode use, ControlFlowNode def) {
    use = def and
    def instanceof ImportStarNode and
    (
      v.getScope() = def.getScope()
      or
      exists(NameNode other |
        other.uses(v) and
        def.getScope() = other.getScope()
      )
    )
  }

  /** Holds if an attribute is assigned at `def` and `use` is the use of `v` for that assignment */
  cached
  predicate attribute_assignment_refinement(Variable v, ControlFlowNode use, ControlFlowNode def) {
    use.(NameNode).uses(v) and
    def.isStore() and
    def.(AttrNode).getObject() = use
  }

  /** Holds if a `v` is used as an argument to `call`, which *may* modify the object referred to by `v` */
  cached
  predicate argument_refinement(Variable v, ControlFlowNode use, CallNode call) {
    use.(NameNode).uses(v) and
    call.getArg(0) = use and
    not method_call_refinement(v, _, call) and
    not test_contains(_, call)
  }

  /** Holds if an attribute is deleted  at `def` and `use` is the use of `v` for that deletion */
  cached
  predicate attribute_deletion_refinement(Variable v, NameNode use, DeletionNode def) {
    use.uses(v) and
    def.getTarget().(AttrNode).getObject() = use
  }

  /** Holds if the set of possible values for `v` is refined by `test` and `use` is the use of `v` in that test. */
  cached
  predicate test_refinement(Variable v, ControlFlowNode use, ControlFlowNode test) {
    use.(NameNode).uses(v) and
    test.getAChild*() = use and
    test.isBranch() and
    exists(BasicBlock block |
      block = use.getBasicBlock() and
      block = test.getBasicBlock() and
      not block.getLastNode() = test
    )
  }
}

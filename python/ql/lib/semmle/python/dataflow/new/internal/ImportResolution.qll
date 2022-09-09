private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.ImportStar
private import semmle.python.dataflow.new.TypeTracker

module ImportResolution {
  /**
   * Holds if the module `m` defines a name `name` by assigning `defn` to it. This is an
   * overapproximation, as `name` may not in fact be exported (e.g. by defining an `__all__` that does
   * not include `name`).
   */
  predicate module_export(Module m, string name, DataFlow::CfgNode defn) {
    exists(EssaVariable v |
      v.getName() = name and
      v.getAUse() = ImportStar::getStarImported*(m).getANormalExit()
    |
      defn.getNode() = v.getDefinition().(AssignmentDefinition).getValue()
      or
      defn.getNode() = v.getDefinition().(ArgumentRefinement).getArgument()
    )
  }

  Module getModule(DataFlow::CfgNode node) {
    exists(ModuleValue mv |
      node.getNode().pointsTo(mv) and
      result = mv.getScope()
    )
  }
}

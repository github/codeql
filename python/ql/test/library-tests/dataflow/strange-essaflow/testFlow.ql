import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate

/** Gets the `CfgNode` that holds the module imported by the fully qualified module name `name`. */
DataFlow::CfgNode module_import(string name) {
  exists(Variable var, AssignmentDefinition def, Import imp, Alias alias |
    var = def.getSourceVariable() and
    result.getNode() = def.getDefiningNode() and
    alias = imp.getAName() and
    alias.getAsname() = var.getAStore()
  |
    name = alias.getValue().(ImportMember).getImportedModuleName()
    or
    name = alias.getValue().(ImportExpr).getImportedModuleName()
  )
}

query predicate os_import(DataFlow::Node node) {
  node = module_import("os") and
  exists(node.getLocation().getFile().getRelativePath())
}

query predicate flowstep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  os_import(nodeFrom) and
  DataFlow::localFlowStep(nodeFrom, nodeTo)
}

query predicate jumpStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  os_import(nodeFrom) and
  DataFlowPrivate::jumpStep(nodeFrom, nodeTo)
}

query predicate essaFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  os_import(nodeFrom) and
  DataFlowPrivate::LocalFlow::localFlowStep(nodeFrom, nodeTo)
}

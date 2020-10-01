import python
import experimental.dataflow.DataFlow
private import experimental.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/** Gets the EssaNode that holds the module imported by the fully qualified module name `name` */
DataFlow::EssaNode module_import(string name) {
  exists(Variable var, Import imp, Alias alias |
    alias = imp.getAName() and
    alias.getAsname() = var.getAStore() and
    (
      name = alias.getValue().(ImportMember).getImportedModuleName()
      or
      name = alias.getValue().(ImportExpr).getImportedModuleName()
    ) and
    result.getVar().(AssignmentDefinition).getSourceVariable() = var
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
  DataFlowPrivate::EssaFlow::essaFlowStep(nodeFrom, nodeTo)
}

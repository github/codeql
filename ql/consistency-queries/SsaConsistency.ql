import ruby
import codeql_ruby.dataflow.SSA
import codeql_ruby.controlflow.ControlFlowGraph

query predicate nonUniqueDef(CfgNode read, Ssa::Definition def) {
  read = def.getARead(_) and
  exists(Ssa::Definition other | read = other.getARead(_) and other != def)
}

query predicate readWithoutDef(LocalVariableReadAccess read) {
  exists(CfgNode node |
    node = read.getAControlFlowNode() and
    not node = any(Ssa::Definition def).getARead(_)
  )
}

query predicate deadDef(Ssa::Definition def, LocalVariable v) {
  v = def.getSourceVariable() and
  not v.isCaptured() and
  not exists(def.getARead(_)) and
  not def = any(Ssa::PhiNode phi).getAnInput()
}

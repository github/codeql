import ruby
import codeql.ruby.dataflow.SSA
import codeql.ruby.controlflow.ControlFlowGraph

query predicate nonUniqueDef(CfgNode read, Ssa::Definition def) {
  read = def.getARead() and
  exists(Ssa::Definition other | read = other.getARead() and other != def)
}

query predicate readWithoutDef(LocalVariableReadAccess read) {
  exists(CfgNode node |
    node = read.getAControlFlowNode() and
    not node = any(Ssa::Definition def).getARead()
  )
}

query predicate deadDef(Ssa::Definition def, LocalVariable v) {
  v = def.getSourceVariable() and
  not v.isCaptured() and
  not exists(def.getARead()) and
  not def = any(Ssa::PhiNode phi).getAnInput()
}

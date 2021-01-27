import codeql_ruby.AST
import codeql_ruby.ast.Variable
import codeql_ruby.controlflow.ControlFlowGraph
import codeql_ruby.dataflow.SSA

query predicate definition(Ssa::Definition def, Variable v) { def.getSourceVariable() = v }

query predicate read(Ssa::Definition def, Variable v, CfgNode read) {
  def.getSourceVariable() = v and read = def.getARead(_)
}

query predicate firstRead(Ssa::Definition def, Variable v, CfgNode read) {
  def.getSourceVariable() = v and read = def.getAFirstRead(_)
}

query predicate lastRead(Ssa::Definition def, Variable v, CfgNode read) {
  def.getSourceVariable() = v and read = def.getALastRead(_)
}

query predicate adjacentReads(Ssa::Definition def, Variable v, CfgNode read1, CfgNode read2) {
  def.getSourceVariable() = v and
  def.hasAdjacentReads(read1, read2)
}

query predicate phi(Ssa::PhiNode phi, Variable v, Ssa::Definition input) {
  phi.getSourceVariable() = v and input = phi.getAnInput()
}

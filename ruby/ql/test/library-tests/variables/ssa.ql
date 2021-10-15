import codeql.ruby.AST
import codeql.ruby.CFG
import codeql.ruby.ast.Variable
import codeql.ruby.dataflow.SSA

query predicate definition(Ssa::Definition def, Variable v) { def.getSourceVariable() = v }

query predicate read(Ssa::Definition def, Variable v, CfgNode read) {
  def.getSourceVariable() = v and read = def.getARead()
}

query predicate firstRead(Ssa::Definition def, Variable v, CfgNode read) {
  def.getSourceVariable() = v and read = def.getAFirstRead()
}

query predicate lastRead(Ssa::Definition def, Variable v, CfgNode read) {
  def.getSourceVariable() = v and read = def.getALastRead()
}

query predicate adjacentReads(Ssa::Definition def, Variable v, CfgNode read1, CfgNode read2) {
  def.getSourceVariable() = v and
  def.hasAdjacentReads(read1, read2)
}

query predicate phi(Ssa::PhiNode phi, Variable v, Ssa::Definition input) {
  phi.getSourceVariable() = v and input = phi.getAnInput()
}

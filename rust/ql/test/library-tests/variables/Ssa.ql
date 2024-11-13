import rust
import codeql.rust.controlflow.BasicBlocks
import codeql.rust.controlflow.ControlFlowGraph
import codeql.rust.dataflow.Ssa
import codeql.rust.dataflow.internal.SsaImpl
import ExposedForTestingOnly

query predicate nonSsaVariable(Variable v) { not v instanceof Ssa::Variable }

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

query predicate phi(Ssa::PhiDefinition phi, Variable v, Ssa::Definition input) {
  phi.getSourceVariable() = v and input = phi.getAnInput()
}

query predicate phiReadNode(PhiReadNode phi, Variable v) { phi.getSourceVariable() = v }

query predicate phiReadNodeRead(PhiReadNode phi, Variable v, CfgNode read) {
  phi.getSourceVariable() = v and
  exists(BasicBlock bb, int i |
    ssaDefReachesReadExt(v, phi, bb, i) and
    read = bb.getNode(i)
  )
}

query predicate phiReadInput(PhiReadNode phi, DefinitionExt inp) {
  phiHasInputFromBlockExt(phi, inp, _)
}

query predicate ultimateDef(Ssa::Definition def, Definition ult) {
  ult = def.getAnUltimateDefinition() and
  ult != def
}

query predicate assigns(Ssa::WriteDefinition def, CfgNode value) { def.assigns(value) }

import rust
import codeql.rust.controlflow.BasicBlocks
import codeql.rust.controlflow.ControlFlowGraph
import codeql.rust.dataflow.Ssa
import codeql.rust.dataflow.internal.SsaImpl
import Impl::TestAdjacentRefs as RefTest

query predicate definition(Ssa::Definition def, Variable v) { def.getSourceVariable() = v }

query predicate read(Ssa::Definition def, Variable v, CfgNode read) {
  def.getSourceVariable() = v and read = def.getARead()
}

query predicate firstRead(Ssa::Definition def, Variable v, CfgNode read) {
  def.getSourceVariable() = v and read = def.getAFirstRead()
}

query predicate adjacentReads(Ssa::Definition def, Variable v, CfgNode read1, CfgNode read2) {
  def.getSourceVariable() = v and
  def.hasAdjacentReads(read1, read2)
}

query predicate phi(Ssa::PhiDefinition phi, Variable v, Ssa::Definition input) {
  phi.getSourceVariable() = v and input = phi.getAnInput()
}

query predicate phiReadNode(RefTest::Ref phi, Variable v) {
  phi.isPhiRead() and phi.getSourceVariable() = v
}

query predicate phiReadNodeFirstRead(RefTest::Ref phi, Variable v, CfgNode read) {
  exists(RefTest::Ref r, BasicBlock bb, int i |
    phi.isPhiRead() and
    RefTest::adjacentRefRead(phi, r) and
    r.accessAt(bb, i, v) and
    read = bb.getNode(i)
  )
}

query predicate phiReadInput(RefTest::Ref phi, RefTest::Ref inp) {
  phi.isPhiRead() and
  RefTest::adjacentRefPhi(inp, phi)
}

query predicate ultimateDef(Ssa::Definition def, Definition ult) {
  ult = def.getAnUltimateDefinition() and
  ult != def
}

query predicate assigns(Ssa::WriteDefinition def, CfgNode value) { def.assigns(value) }

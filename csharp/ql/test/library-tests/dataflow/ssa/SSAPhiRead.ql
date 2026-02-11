import csharp
import semmle.code.csharp.dataflow.internal.SsaImpl
import Impl::TestAdjacentRefs as RefTest

query predicate phiReadNode(RefTest::Ref phi, Ssa::SourceVariable v) {
  phi.isPhiRead() and phi.getSourceVariable() = v
}

query predicate phiReadNodeFirstRead(RefTest::Ref phi, Ssa::SourceVariable v, ControlFlow::Node read) {
  exists(RefTest::Ref r, ControlFlow::BasicBlock bb, int i |
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

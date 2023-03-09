import csharp
import semmle.code.csharp.dataflow.internal.SsaImpl
import ExposedForTestingOnly

query predicate phiReadNode(PhiReadNode phi, Ssa::SourceVariable v) { phi.getSourceVariable() = v }

query predicate phiReadNodeRead(PhiReadNode phi, Ssa::SourceVariable v, ControlFlow::Node read) {
  phi.getSourceVariable() = v and
  exists(ControlFlow::BasicBlock bb, int i |
    ssaDefReachesReadExt(v, phi, bb, i) and
    read = bb.getNode(i)
  )
}

query predicate phiReadInput(PhiReadNode phi, DefinitionExt inp) {
  phiHasInputFromBlockExt(phi, inp, _)
}

private import semmle.code.cil.CIL
private import SsaImplCommon

cached
private module Cached {
  cached
  predicate forceCachingInSameStage() { any() }

  cached
  ReadAccess getARead(Definition def) {
    exists(BasicBlock bb, int i |
      ssaDefReachesRead(_, def, bb, i) and
      result = bb.getNode(i)
    )
  }

  cached
  ReadAccess getAFirstRead(Definition def) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      def.definesAt(_, bb1, i1) and
      adjacentDefRead(def, bb1, i1, bb2, i2) and
      result = bb2.getNode(i2)
    )
  }

  cached
  predicate hasAdjacentReads(Definition def, ReadAccess first, ReadAccess second) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      first = bb1.getNode(i1) and
      adjacentDefRead(def, bb1, i1, bb2, i2) and
      second = bb2.getNode(i2)
    )
  }

  cached
  Definition getAPhiInput(PhiNode phi) { phiHasInputFromBlock(phi, result, _) }

  cached
  predicate hasLastInputRef(Definition phi, Definition def, BasicBlock bb, int i) {
    lastRefRedef(def, bb, i, phi) and
    def = getAPhiInput(phi)
  }
}

import Cached

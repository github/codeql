private import cil
private import codeql.ssa.Ssa as SsaImplCommon

private module SsaInput implements SsaImplCommon::InputSig {
  class BasicBlock = CIL::BasicBlock;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class ExitBasicBlock = CIL::ExitBasicBlock;

  class SourceVariable = CIL::StackVariable;

  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    forceCachingInSameStage() and
    exists(CIL::VariableUpdate vu |
      vu.updatesAt(bb, i) and
      v = vu.getVariable() and
      certain = true
    )
  }

  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    exists(CIL::ReadAccess ra | bb.getNode(i) = ra |
      ra.getTarget() = v and
      certain = true
    )
  }
}

import SsaImplCommon::Make<SsaInput>

cached
private module Cached {
  private import CIL

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
  ReadAccess getAFirstReadExt(DefinitionExt def) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      def.definesAt(_, bb1, i1, _) and
      adjacentDefReadExt(def, _, bb1, i1, bb2, i2) and
      result = bb2.getNode(i2)
    )
  }

  cached
  predicate hasAdjacentReadsExt(DefinitionExt def, ReadAccess first, ReadAccess second) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      first = bb1.getNode(i1) and
      adjacentDefReadExt(def, _, bb1, i1, bb2, i2) and
      second = bb2.getNode(i2)
    )
  }

  cached
  Definition getAPhiInput(PhiNode phi) { phiHasInputFromBlock(phi, result, _) }

  cached
  predicate lastRefBeforeRedefExt(DefinitionExt def, BasicBlock bb, int i, DefinitionExt next) {
    lastRefRedefExt(def, _, bb, i, next)
  }
}

import Cached

private module Deprecated {
  private import CIL

  deprecated ReadAccess getAFirstRead(Definition def) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      def.definesAt(_, bb1, i1) and
      adjacentDefRead(def, bb1, i1, bb2, i2) and
      result = bb2.getNode(i2)
    )
  }

  deprecated predicate hasAdjacentReads(Definition def, ReadAccess first, ReadAccess second) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      first = bb1.getNode(i1) and
      adjacentDefRead(def, bb1, i1, bb2, i2) and
      second = bb2.getNode(i2)
    )
  }

  deprecated predicate lastRefBeforeRedef(Definition def, BasicBlock bb, int i, Definition next) {
    lastRefRedef(def, bb, i, next)
  }
}

import Deprecated

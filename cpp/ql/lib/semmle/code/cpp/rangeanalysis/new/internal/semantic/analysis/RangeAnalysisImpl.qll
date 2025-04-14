private import RangeAnalysisConstantSpecific
private import RangeAnalysisRelativeSpecific
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.FloatDelta
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExpr
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticCFG
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticGuard
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticBound as SemanticBound
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticLocation
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticSSA
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticType as SemanticType
private import SemanticType
private import codeql.rangeanalysis.RangeAnalysis
private import ConstantAnalysis as ConstantAnalysis

module Sem implements Semantic<SemLocation> {
  class Expr = SemExpr;

  class ConstantIntegerExpr = ConstantAnalysis::SemConstantIntegerExpr;

  class BinaryExpr = SemBinaryExpr;

  class AddExpr = SemAddExpr;

  class SubExpr = SemSubExpr;

  class MulExpr = SemMulExpr;

  class DivExpr = SemDivExpr;

  class RemExpr = SemRemExpr;

  class BitAndExpr = SemBitAndExpr;

  class BitOrExpr = SemBitOrExpr;

  class ShiftLeftExpr = SemShiftLeftExpr;

  class ShiftRightExpr = SemShiftRightExpr;

  class ShiftRightUnsignedExpr = SemShiftRightUnsignedExpr;

  class RelationalExpr = SemRelationalExpr;

  class UnaryExpr = SemUnaryExpr;

  class ConvertExpr = SemConvertExpr;

  class BoxExpr = SemBoxExpr;

  class UnboxExpr = SemUnboxExpr;

  class NegateExpr = SemNegateExpr;

  class PreIncExpr = SemAddOneExpr;

  class PreDecExpr = SemSubOneExpr;

  class PostIncExpr extends SemUnaryExpr {
    PostIncExpr() { none() }
  }

  class PostDecExpr extends SemUnaryExpr {
    PostDecExpr() { none() }
  }

  class CopyValueExpr extends SemUnaryExpr {
    CopyValueExpr() { this instanceof SemCopyValueExpr or this instanceof SemStoreExpr }
  }

  class ConditionalExpr = SemConditionalExpr;

  class BasicBlock = SemBasicBlock;

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  int getBlockId1(BasicBlock bb) { result = bb.getUniqueId() }

  class Guard = SemGuard;

  predicate implies_v2 = semImplies_v2/4;

  class Type = SemType;

  class IntegerType = SemIntegerType;

  class FloatingPointType = SemFloatingPointType;

  class AddressType = SemAddressType;

  SemType getExprType(SemExpr e) { result = e.getSemType() }

  SemType getSsaType(SemSsaVariable var) { result = var.getType() }

  class SsaVariable = SemSsaVariable;

  class SsaPhiNode = SemSsaPhiNode;

  class SsaExplicitUpdate = SemSsaExplicitUpdate;

  predicate additionalValueFlowStep(SemExpr dest, SemExpr src, int delta) { none() }

  predicate conversionCannotOverflow(Type fromType, Type toType) {
    SemanticType::conversionCannotOverflow(fromType, toType)
  }
}

module SignAnalysis implements SignAnalysisSig<SemLocation, Sem> {
  private import SignAnalysisCommon as SA
  import SA::SignAnalysis<FloatDelta>
}

module ConstantBounds implements BoundSig<SemLocation, Sem, FloatDelta> {
  class SemBound instanceof SemanticBound::SemBound {
    SemBound() {
      this instanceof SemanticBound::SemZeroBound
      or
      this.(SemanticBound::SemSsaBound).getAVariable() instanceof SemSsaPhiNode
    }

    string toString() { result = super.toString() }

    SemLocation getLocation() { result = super.getLocation() }

    SemExpr getExpr(float delta) { result = super.getExpr(delta) }
  }

  class SemZeroBound extends SemBound instanceof SemanticBound::SemZeroBound { }

  class SemSsaBound extends SemBound instanceof SemanticBound::SemSsaBound {
    SemSsaVariable getVariable() { result = this.(SemanticBound::SemSsaBound).getAVariable() }
  }
}

module RelativeBounds implements BoundSig<SemLocation, Sem, FloatDelta> {
  class SemBound instanceof SemanticBound::SemBound {
    SemBound() { not this instanceof SemanticBound::SemZeroBound }

    string toString() { result = super.toString() }

    SemLocation getLocation() { result = super.getLocation() }

    SemExpr getExpr(float delta) { result = super.getExpr(delta) }
  }

  class SemZeroBound extends SemBound instanceof SemanticBound::SemZeroBound { }

  class SemSsaBound extends SemBound instanceof SemanticBound::SemSsaBound {
    SemSsaVariable getVariable() { result = this.(SemanticBound::SemSsaBound).getAVariable() }
  }
}

module AllBounds implements BoundSig<SemLocation, Sem, FloatDelta> {
  class SemBound instanceof SemanticBound::SemBound {
    string toString() { result = super.toString() }

    SemLocation getLocation() { result = super.getLocation() }

    SemExpr getExpr(float delta) { result = super.getExpr(delta) }
  }

  class SemZeroBound extends SemBound instanceof SemanticBound::SemZeroBound { }

  class SemSsaBound extends SemBound instanceof SemanticBound::SemSsaBound {
    SemSsaVariable getVariable() { result = this.(SemanticBound::SemSsaBound).getAVariable() }
  }
}

private module ModulusAnalysisInstantiated implements ModulusAnalysisSig<SemLocation, Sem> {
  class ModBound = AllBounds::SemBound;

  private import codeql.rangeanalysis.ModulusAnalysis as MA
  import MA::ModulusAnalysis<SemLocation, Sem, FloatDelta, AllBounds>
}

module ConstantStage =
  RangeStage<SemLocation, Sem, FloatDelta, AllBounds, FloatOverflow, CppLangImplConstant,
    SignAnalysis, ModulusAnalysisInstantiated>;

module RelativeStage =
  RangeStage<SemLocation, Sem, FloatDelta, AllBounds, FloatOverflow, CppLangImplRelative,
    SignAnalysis, ModulusAnalysisInstantiated>;

private newtype TSemReason =
  TSemNoReason() or
  TSemCondReason(SemGuard guard) {
    guard = any(ConstantStage::SemCondReason reason).getCond()
    or
    guard = any(RelativeStage::SemCondReason reason).getCond()
  }

ConstantStage::SemReason constantReason(SemReason reason) {
  result instanceof ConstantStage::SemNoReason and reason instanceof SemNoReason
  or
  result.(ConstantStage::SemCondReason).getCond() = reason.(SemCondReason).getCond()
}

RelativeStage::SemReason relativeReason(SemReason reason) {
  result instanceof RelativeStage::SemNoReason and reason instanceof SemNoReason
  or
  result.(RelativeStage::SemCondReason).getCond() = reason.(SemCondReason).getCond()
}

import Public

module Public {
  predicate semBounded(
    SemExpr e, SemanticBound::SemBound b, float delta, boolean upper, SemReason reason
  ) {
    ConstantStage::semBounded(e, b, delta, upper, constantReason(reason))
    or
    RelativeStage::semBounded(e, b, delta, upper, relativeReason(reason))
  }

  /**
   * A reason for an inferred bound. This can either be `CondReason` if the bound
   * is due to a specific condition, or `NoReason` if the bound is inferred
   * without going through a bounding condition.
   */
  abstract class SemReason extends TSemReason {
    /** Gets a textual representation of this reason. */
    abstract string toString();
  }

  /**
   * A reason for an inferred bound that indicates that the bound is inferred
   * without going through a bounding condition.
   */
  class SemNoReason extends SemReason, TSemNoReason {
    override string toString() { result = "NoReason" }
  }

  /** A reason for an inferred bound pointing to a condition. */
  class SemCondReason extends SemReason, TSemCondReason {
    /** Gets the condition that is the reason for the bound. */
    SemGuard getCond() { this = TSemCondReason(result) }

    override string toString() { result = this.getCond().toString() }
  }
}

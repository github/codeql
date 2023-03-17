private import RangeAnalysisStage
private import RangeAnalysisSpecific
private import experimental.semmle.code.cpp.semantic.analysis.FloatDelta
private import RangeUtils
private import experimental.semmle.code.cpp.semantic.SemanticBound as SemanticBound
private import experimental.semmle.code.cpp.semantic.SemanticLocation
private import experimental.semmle.code.cpp.semantic.SemanticSSA

module ConstantBounds implements BoundSig<FloatDelta> {
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
    SemSsaVariable getAVariable() { result = this.(SemanticBound::SemSsaBound).getAVariable() }
  }
}

private module RelativeBounds implements BoundSig<FloatDelta> {
  class SemBound instanceof SemanticBound::SemBound {
    SemBound() { not this instanceof SemanticBound::SemZeroBound }

    string toString() { result = super.toString() }

    SemLocation getLocation() { result = super.getLocation() }

    SemExpr getExpr(float delta) { result = super.getExpr(delta) }
  }

  class SemZeroBound extends SemBound instanceof SemanticBound::SemZeroBound { }

  class SemSsaBound extends SemBound instanceof SemanticBound::SemSsaBound {
    SemSsaVariable getAVariable() { result = this.(SemanticBound::SemSsaBound).getAVariable() }
  }
}

private module ConstantStage =
  RangeStage<FloatDelta, ConstantBounds, CppLangImpl, RangeUtil<FloatDelta, CppLangImpl>>;

private module RelativeStage =
  RangeStage<FloatDelta, RelativeBounds, CppLangImpl, RangeUtil<FloatDelta, CppLangImpl>>;

private newtype TSemReason =
  TSemNoReason() or
  TSemCondReason(SemGuard guard) {
    guard = any(ConstantStage::SemCondReason reason).getCond()
    or
    guard = any(RelativeStage::SemCondReason reason).getCond()
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

  override string toString() { result = getCond().toString() }
}

private ConstantStage::SemReason constantReason(SemReason reason) {
  result instanceof ConstantStage::SemNoReason and reason instanceof SemNoReason
  or
  result.(ConstantStage::SemCondReason).getCond() = reason.(SemCondReason).getCond()
}

private RelativeStage::SemReason relativeReason(SemReason reason) {
  result instanceof RelativeStage::SemNoReason and reason instanceof SemNoReason
  or
  result.(RelativeStage::SemCondReason).getCond() = reason.(SemCondReason).getCond()
}

predicate semBounded(
  SemExpr e, SemanticBound::SemBound b, float delta, boolean upper, SemReason reason
) {
  ConstantStage::semBounded(e, b, delta, upper, constantReason(reason))
  or
  RelativeStage::semBounded(e, b, delta, upper, relativeReason(reason))
}

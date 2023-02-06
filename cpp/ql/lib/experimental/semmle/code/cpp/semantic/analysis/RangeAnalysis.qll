private import RangeAnalysisStage
private import RangeAnalysisSpecific
private import experimental.semmle.code.cpp.semantic.analysis.FloatDelta
private import RangeUtils
private import experimental.semmle.code.cpp.semantic.SemanticBound as SemanticBound

module Bounds implements BoundSig<FloatDelta> {
  class SemBound instanceof SemanticBound::SemBound {
    string toString() { result = super.toString() }

    SemExpr getExpr(float delta) { result = super.getExpr(delta) }
  }

  class SemZeroBound extends SemBound instanceof SemanticBound::SemZeroBound { }

  class SemSsaBound extends SemBound instanceof SemanticBound::SemSsaBound {
    SemSsaVariable getAVariable() { result = this.(SemanticBound::SemSsaBound).getAVariable() }
  }
}

private module CppRangeAnalysis =
  RangeStage<FloatDelta, Bounds, CppLangImpl, RangeUtil<FloatDelta, CppLangImpl>>;

import CppRangeAnalysis

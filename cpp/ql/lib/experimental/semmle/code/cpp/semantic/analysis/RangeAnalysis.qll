private import RangeAnalysisStage
private import RangeAnalysisSpecific
private import FloatDelta
private import RangeUtils

private module CppRangeAnalysis = RangeStage<FloatDelta, CppLangImpl, RangeUtil<FloatDelta, CppLangImpl>>;
import CppRangeAnalysis
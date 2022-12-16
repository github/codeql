private import RangeAnalysisStage
private import RangeAnalysisSpecific
private import FloatDelta
private import RangeUtils

module CppRangeAnalysis = RangeStage<FloatDelta, CppLangImpl, RangeUtil<FloatDelta, CppLangImpl>>;
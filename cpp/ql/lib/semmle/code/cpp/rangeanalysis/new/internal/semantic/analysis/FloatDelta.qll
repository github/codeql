private import RangeAnalysisStage

module FloatDelta implements DeltaSig {
  class Delta = float;

  bindingset[d]
  bindingset[result]
  float toFloat(Delta d) { result = d }

  bindingset[d]
  bindingset[result]
  int toInt(Delta d) { result = d }

  bindingset[n]
  bindingset[result]
  Delta fromInt(int n) { result = n }

  bindingset[f]
  Delta fromFloat(float f) { result = f }
}

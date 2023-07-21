private import RangeAnalysisStage

module IntDelta implements DeltaSig {
  class Delta = int;

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
  Delta fromFloat(float f) {
    result =
      min(float diff, float res |
        diff = (res - f) and res = f.ceil()
        or
        diff = (f - res) and res = f.floor()
      |
        res order by diff
      )
  }
}

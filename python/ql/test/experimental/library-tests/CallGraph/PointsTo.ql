import python
import CallGraphTest

query predicate expectedCallEdgeNotFound(Call call, Function callable) {
  any(PointsToResolver r).expectedCallEdgeNotFound(call, callable)
}

query predicate unexpectedCallEdgeFound(Call call, Function callable, string message) {
  any(PointsToResolver r).unexpectedCallEdgeFound(call, callable, message)
}

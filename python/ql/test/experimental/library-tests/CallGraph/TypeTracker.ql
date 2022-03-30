import python
import CallGraphTest

query predicate expectedCallEdgeNotFound(Call call, Function callable) {
  any(TypeTrackerResolver r).expectedCallEdgeNotFound(call, callable)
}

query predicate unexpectedCallEdgeFound(Call call, Function callable, string message) {
  any(TypeTrackerResolver r).unexpectedCallEdgeFound(call, callable, message)
}

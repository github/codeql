import python
import CallGraphTest

query predicate pointsTo_found_typeTracker_notFound(Call call, Function callable) {
  annotatedCallEdge(_, call, callable) and
  any(PointsToResolver r).callEdge(call, callable) and
  not any(TypeTrackerResolver r).callEdge(call, callable)
}

query predicate pointsTo_notFound_typeTracker_found(Call call, Function callable) {
  annotatedCallEdge(_, call, callable) and
  not any(PointsToResolver r).callEdge(call, callable) and
  any(TypeTrackerResolver r).callEdge(call, callable)
}

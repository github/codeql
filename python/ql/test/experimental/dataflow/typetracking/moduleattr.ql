import python
import experimental.dataflow.DataFlow
import experimental.dataflow.TypeTracker

DataFlow::Node module_tracker(TypeTracker t) {
  t.start() and
  result = DataFlow::importNode("module")
  or
  exists(TypeTracker t2 | result = module_tracker(t2).track(t2, t))
}

query DataFlow::Node module_tracker() { result = module_tracker(DataFlow::TypeTracker::end()) }

DataFlow::Node module_attr_tracker(TypeTracker t) {
  t.startInAttr("attr") and
  result = module_tracker()
  or
  exists(TypeTracker t2 | result = module_attr_tracker(t2).track(t2, t))
}

query DataFlow::Node module_attr_tracker() {
  result = module_attr_tracker(DataFlow::TypeTracker::end())
}

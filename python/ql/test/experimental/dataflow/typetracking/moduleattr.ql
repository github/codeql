import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TypeTracker

private DataFlow::LocalSourceNode module_tracker(TypeTracker t) {
  t.start() and
  result = DataFlow::importNode("module")
  or
  exists(TypeTracker t2 | result = module_tracker(t2).track(t2, t))
}

query DataFlow::Node module_tracker() {
  module_tracker(DataFlow::TypeTracker::end()).flowsTo(result)
}

private DataFlow::LocalSourceNode module_attr_tracker(TypeTracker t) {
  t.startInAttr("attr") and
  result = module_tracker()
  or
  exists(TypeTracker t2 | result = module_attr_tracker(t2).track(t2, t))
}

query DataFlow::Node module_attr_tracker() {
  module_attr_tracker(DataFlow::TypeTracker::end()).flowsTo(result)
}

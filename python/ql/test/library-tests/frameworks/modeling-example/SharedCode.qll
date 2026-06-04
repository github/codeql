private import python
private import semmle.python.controlflow.internal.Cfg as Cfg
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking

// Helpers modeling MyClass
/** A data-flow Node representing an instance of MyClass. */
abstract class MyClass extends DataFlow::Node { }

private DataFlow::TypeTrackingNode myClassGetValue(MyClass qualifier, DataFlow::TypeTracker t) {
  t.startInAttr("get_value") and
  result = qualifier
  or
  exists(DataFlow::TypeTracker t2 | result = myClassGetValue(qualifier, t2).track(t2, t))
}

DataFlow::Node myClassGetValue(MyClass qualifier) {
  myClassGetValue(qualifier, DataFlow::TypeTracker::end()).flowsTo(result)
}

// Config
class SourceCall extends DataFlow::Node, MyClass {
  SourceCall() { this.asCfgNode().(Cfg::CallNode).getFunction().(Cfg::NameNode).getId() = "source" }
}

private module SharedConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof SourceCall }

  predicate isSink(DataFlow::Node sink) {
    exists(Cfg::CallNode call |
      call.getFunction().(Cfg::NameNode).getId() = "sink" and
      call.getArg(0) = sink.asCfgNode()
    )
  }
}

module SharedFlow = TaintTracking::Global<SharedConfig>;

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking

// Helpers modeling MyClass
/** A data-flow Node representing an instance of MyClass. */
abstract class MyClass extends DataFlow::Node { }

private DataFlow::Node myClassGetValue(MyClass qualifier, DataFlow::TypeTracker t) {
  t.startInAttr("get_value") and
  result = qualifier
  or
  exists(DataFlow::TypeTracker t2 | result = myClassGetValue(qualifier, t2).track(t2, t))
}

DataFlow::Node myClassGetValue(MyClass qualifier) {
  result = myClassGetValue(qualifier, DataFlow::TypeTracker::end())
}

// Config
class SourceCall extends DataFlow::Node, MyClass {
  SourceCall() { this.asCfgNode().(CallNode).getFunction().(NameNode).getId() = "source" }
}

class SharedConfig extends TaintTracking::Configuration {
  SharedConfig() { this = "SharedConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof SourceCall }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "sink" and
      call.getArg(0) = sink.asCfgNode()
    )
  }
}

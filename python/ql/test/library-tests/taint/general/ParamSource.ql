import python
import semmle.python.dataflow.TaintTracking

class TestKind extends TaintKind {
  TestKind() { this = "test" }
}

class CustomSource extends TaintSource {
  CustomSource() {
    exists(Parameter p |
      p.asName().getId() = "arg" and
      this.(ControlFlowNode).getNode() = p
    )
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof TestKind }

  override string toString() { result = "Source of untrusted input" }
}

class SimpleSink extends TaintSink {
  override string toString() { result = "Simple sink" }

  SimpleSink() {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      this = call.getAnArg()
    )
  }

  override predicate sinks(TaintKind taint) { taint instanceof TestKind }
}

from TaintSource src, TaintSink sink, TaintKind srckind, TaintKind sinkkind
where src.flowsToSink(srckind, sink) and sink.sinks(sinkkind)
select srckind, src.getLocation().toString(), sink.getLocation().getStartLine(),
  sink.(ControlFlowNode).getNode().toString(), sinkkind

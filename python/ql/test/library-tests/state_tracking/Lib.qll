import python
import semmle.python.dataflow.StateTracking

predicate callTo(CallNode call, string name) { call.getFunction().(NameNode).getId() = name }

class Initialized extends TrackableState {
  Initialized() { this = "initialized" }

  override predicate startsAt(ControlFlowNode f) { callTo(f, "initialize") }
}

class Frobnicated extends TrackableState {
  Frobnicated() { this = "frobnicated" }

  override predicate startsAt(ControlFlowNode f) { callTo(f, "frobnicate") }

  override predicate endsAt(ControlFlowNode f) { callTo(f, "defrobnicate") }
}

import javascript

class FooCall extends API::CallNode {
  FooCall() { this = API::moduleImport("mylibrary").getMember("foo").getACall() }

  DataFlow::Node getFirst() { result = this.getParameter(0).getMember("value").asSink() }

  DataFlow::Node getSecond() { result = this.getParameter(1).getMember("value").asSink() }
}

query predicate values(FooCall call, int first, int second) {
  first = call.getFirst().getIntValue() and
  second = call.getSecond().getIntValue()
}

query predicate mismatch(FooCall call, string msg) {
  call.getFirst().getIntValue() != call.getSecond().getIntValue() and
  msg = "mismatching parameter indices found for call"
}

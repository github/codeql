import javascript

class FooCall extends API::CallNode {
  FooCall() { this = API::moduleImport("mylibrary").getMember("foo").getACall() }

  DataFlow::Node getFirst() { result = getParameter(0).getMember("value").getASink() }

  DataFlow::Node getSecond() { result = getParameter(1).getMember("value").getASink() }
}

query predicate values(FooCall call, int first, int second) {
  first = call.getFirst().getIntValue() and
  second = call.getSecond().getIntValue()
}

query predicate mismatch(FooCall call, string msg) {
  call.getFirst().getIntValue() != call.getSecond().getIntValue() and
  msg = "mismatching parameter indices found for call"
}

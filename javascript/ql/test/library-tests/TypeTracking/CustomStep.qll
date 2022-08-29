import javascript
private import DataFlow

predicate configStep(Node pred, Node succ) {
  exists(CallNode setter, CallNode getter |
    getter = moduleMember("@test/myconfig", "getConfigValue").getACall() and
    setter = moduleMember("@test/myconfig", "setConfigValue").getACall() and
    getter.getArgument(0).getStringValue() = setter.getArgument(0).getStringValue() and
    pred = setter.getArgument(1) and
    succ = getter
  )
}

class CustomStep extends SharedTypeTrackingStep {
  override predicate step(Node pred, Node succ) { configStep(pred, succ) }
}

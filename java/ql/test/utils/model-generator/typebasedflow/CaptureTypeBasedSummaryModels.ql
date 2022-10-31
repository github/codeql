import java
import utils.modelgenerator.internal.CaptureTypeBasedSummaryModels

private string expects() {
  exists(Javadoc doc | doc.getChild(0).toString().regexpCapture(" *MaD=(.*)", 1) = result)
}

private string flows() { exists(TypeBasedFlowTargetApi api | result = captureFlow(api)) }

query predicate unexpectedSummary(string msg) {
  exists(string flow |
    flow = flows() and
    not exists(string e | e = expects() and e = flow) and
    msg = "Unexpected summary found: " + flow
  )
}

query predicate expectedSummary(string msg) {
  exists(string e |
    e = expects() and
    not exists(string flow | flow = flows() and e = flow) and
    msg = "Expected summary missing: " + e
  )
}

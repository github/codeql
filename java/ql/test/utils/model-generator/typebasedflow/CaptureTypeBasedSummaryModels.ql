import java
import utils.modelgenerator.internal.CaptureTypeBasedSummaryModels

private string expects() {
  exists(Javadoc doc |
    doc.getChild(0).toString().regexpCapture(" *(SPURIOUS-)?MaD=(.*)", 2) = result
  )
}

private string flows() { result = captureFlow(_) }

query predicate unexpectedSummary(string msg) {
  exists(string flow |
    flow = flows() and
    not flow = expects() and
    msg = "Unexpected summary found: " + flow
  )
}

query predicate expectedSummary(string msg) {
  exists(string e |
    e = expects() and
    not e = flows() and
    msg = "Expected summary missing: " + e
  )
}

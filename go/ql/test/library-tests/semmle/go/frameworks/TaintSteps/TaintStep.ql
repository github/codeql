// This test finds taint tracking steps which are not data flow steps
// to illustrate which steps are added specifically by taint tracking
import go

predicate hasLocation(DataFlow::Node node, string loc) {
  node.hasLocationInfo(loc, _, _, _, _) and loc != ""
  or
  exists(string pkg, string name |
    node.(DataFlow::SummarizedParameterNode)
        .getCallable()
        .asSummarizedCallable()
        .asFunction()
        .hasQualifiedName(pkg, name) and
    loc = pkg + "." + name
  )
}

from string predLoc, DataFlow::Node pred, DataFlow::Node succ
where
  TaintTracking::localTaintStep(pred, succ) and
  not DataFlow::localFlowStep(pred, succ) and
  // Exclude results which only appear on unix to avoid platform-specific results
  not exists(string pkg, string name |
    pred.(DataFlow::SummarizedParameterNode)
        .getCallable()
        .asSummarizedCallable()
        .asFunction()
        .hasQualifiedName(pkg, name)
  |
    pkg = "syscall" and name = "StringSlicePtr"
    or
    pkg.matches("crypto/rand.%") and
    name = "Read"
    or
    pkg = ["os.dirEntry", "os.unixDirent"] and name = ["Info", "Name", "String"]
    or
    // Not available on arm64
    pkg = "vendor/golang.org/x/crypto/internal/poly1305.mac" and name = "Write"
  ) and
  hasLocation(pred, predLoc)
select predLoc, pred, succ

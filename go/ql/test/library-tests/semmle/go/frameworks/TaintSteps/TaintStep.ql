import go

from DataFlow::Node pred, DataFlow::Node succ
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
    pkg = ["os.dirEntry", "os.unixDirent"] and name = ["Info", "Name"]
  )
select pred, succ

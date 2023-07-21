import go

from DataFlow::Node nd, DataFlow::Node succ
where
  TaintTracking::localTaintStep(nd, succ) and
  // exclude data-flow steps
  not DataFlow::localFlowStep(nd, succ) and
  // Exclude results which only appear on unix to avoid platform-specific results
  not exists(string pkg, string name |
    nd.(DataFlow::SummarizedParameterNode)
        .getCallable()
        .asSummarizedCallable()
        .asFunction()
        .hasQualifiedName(pkg, name)
  |
    pkg = "syscall" and name = "StringSlicePtr"
    or
    pkg = ["os.dirEntry", "os.unixDirent"] and name = ["Info", "Name"]
  )
select nd, succ

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking

from DataFlow::Node pred, DataFlow::Node succ
where
  TaintTracking::localTaintStep(pred, succ) and
  not pred.getLocation() instanceof UnknownLocation and
  not succ.getLocation() instanceof UnknownLocation
select pred, succ

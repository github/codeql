import swift
import codeql.swift.dataflow.DataFlow

from DataFlow::Node pred, DataFlow::Node succ
where
  DataFlow::localFlowStep(pred, succ) and
  not pred.getLocation() instanceof UnknownLocation and
  not succ.getLocation() instanceof UnknownLocation
select pred, succ

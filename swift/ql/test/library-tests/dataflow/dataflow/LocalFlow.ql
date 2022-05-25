import swift
import codeql.swift.dataflow.DataFlow

from DataFlow::Node pred, DataFlow::Node succ
where DataFlow::localFlowStep(pred, succ)
select pred, succ

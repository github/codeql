/**
 * @kind path-problem
 */

import swift
import codeql.swift.dataflow.DataFlow::DataFlow
import FlowConfig
import DataFlow::PathGraph

from DataFlow::PathNode src, DataFlow::PathNode sink, TestConfiguration test
where test.hasFlowPath(src, sink)
select sink, src, sink, "result"

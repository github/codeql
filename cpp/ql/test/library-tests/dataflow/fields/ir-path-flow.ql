/**
 * @kind path-problem
 */

import semmle.code.cpp.ir.dataflow.DataFlow
import IRConfiguration
import cpp
import DataFlow::PathGraph

from DataFlow::PathNode src, DataFlow::PathNode sink, IRConf conf
where conf.hasFlowPath(src, sink)
select sink, src, sink, sink + " flows from $@", src, src.toString()

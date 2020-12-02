/**
 * @kind path-problem
 */

import semmle.code.cpp.dataflow.DataFlow
import ASTConfiguration
import cpp
import DataFlow::PathGraph

from DataFlow::PathNode src, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(src, sink)
select sink, src, sink, sink + " flows from $@", src, src.toString()

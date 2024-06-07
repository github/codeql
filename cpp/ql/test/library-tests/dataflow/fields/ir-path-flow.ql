/**
 * @kind path-problem
 */

import semmle.code.cpp.ir.dataflow.DataFlow
import IRConfiguration
import IRFlow::PathGraph

from IRFlow::PathNode src, IRFlow::PathNode sink
where IRFlow::flowPath(src, sink)
select sink, src, sink, sink + " flows from $@", src, src.toString()

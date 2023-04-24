/**
 * @kind path-problem
 */

import swift
import Taint
import TestFlow::PathGraph

from TestFlow::PathNode src, TestFlow::PathNode sink
where TestFlow::flowPath(src, sink)
select sink, src, sink, "result"

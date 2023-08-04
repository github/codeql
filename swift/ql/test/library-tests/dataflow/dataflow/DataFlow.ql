/**
 * @kind path-problem
 */

import swift
import FlowConfig
import TestFlow::PathGraph

from TestFlow::PathNode src, TestFlow::PathNode sink
where TestFlow::flowPath(src, sink)
select sink, src, sink, "result"

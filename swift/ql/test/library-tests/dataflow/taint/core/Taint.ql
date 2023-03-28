/**
 * @kind path-problem
 */

import swift
import Taint
import PathGraph

from PathNode src, PathNode sink, TestConfiguration test
where test.hasFlowPath(src, sink)
select sink, src, sink, "result"

/**
 * @kind path-problem
 */

import semmle.code.cpp.dataflow.DataFlow
import ASTConfiguration
import AstFlow::PathGraph

from AstFlow::PathNode src, AstFlow::PathNode sink
where AstFlow::flowPath(src, sink)
select sink, src, sink, sink + " flows from $@", src, src.toString()

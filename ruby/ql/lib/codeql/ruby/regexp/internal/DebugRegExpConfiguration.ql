/**
 * @description Used to debug the discovery of regexp literals.
 * @kind path-problem
 */

import RegExpConfiguration
import codeql.ruby.dataflow.internal.DataFlowImplForRegExp
import PathGraph

predicate stats = stageStats/8;

from RegExpConfiguration c, PathNode source, PathNode sink
where c.hasFlowPath(source, sink)
select source.getNode(), source, sink, source.toString()

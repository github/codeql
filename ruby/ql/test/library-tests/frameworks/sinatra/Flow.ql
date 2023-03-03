/**
 * @kind path-problem
 */

import ruby
import TestUtilities.InlineFlowTest
import PathGraph
import codeql.ruby.frameworks.Sinatra
import codeql.ruby.Concepts

from DataFlow::PathNode source, DataFlow::PathNode sink, DefaultTaintFlowConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()

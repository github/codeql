/**
 * @kind path-problem
 */

import ruby
import TestUtilities.InlineFlowTest
import PathGraph

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { none() }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, DefaultValueFlowConf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()

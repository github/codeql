import python
import semmle.python.dataflow.new.DataFlow

from DataFlow::CfgNode node
where exists(node.getLocation().getFile().getRelativePath())
select node.getEnclosingCallable() as enclosingCallable, node

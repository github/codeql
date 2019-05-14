import javascript
import semmle.javascript.dataflow.internal.AccessPaths

from AccessPath path
select path, concat(DataFlow::Node node | node = path.getAnInstance() | node.toString(), ", ")

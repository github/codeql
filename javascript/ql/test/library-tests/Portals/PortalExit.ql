import javascript
import semmle.javascript.dataflow.Portals

from Portal p, boolean isRemote
select p, p.getAnExitNode(isRemote), isRemote

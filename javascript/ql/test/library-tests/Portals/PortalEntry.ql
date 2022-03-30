import javascript
import semmle.javascript.dataflow.Portals

from Portal p, boolean escapes
select p, p.getAnEntryNode(escapes), escapes

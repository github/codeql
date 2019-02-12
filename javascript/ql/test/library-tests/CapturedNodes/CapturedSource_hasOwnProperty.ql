import javascript
import semmle.javascript.dataflow.CapturedNodes

from CapturedSource src, string name
where src.hasOwnProperty(name)
select src, name

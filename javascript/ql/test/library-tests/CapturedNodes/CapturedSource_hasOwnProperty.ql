import javascript
import semmle.javascript.dataflow.CapturedNodes

from LocalObject src, string name
where src.hasOwnProperty(name)
select src, name

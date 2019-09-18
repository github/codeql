import javascript
import semmle.javascript.dataflow.LocalObjects

from LocalObject src, string name
where src.hasOwnProperty(name)
select src, name

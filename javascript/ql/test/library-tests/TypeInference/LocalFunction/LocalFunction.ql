import javascript
import semmle.javascript.dataflow.internal.InterProceduralTypeInference

from LocalFunction e
select e, e.getAnInvocation()

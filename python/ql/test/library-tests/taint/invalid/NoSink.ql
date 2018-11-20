
import python

import semmle.python.security.TaintTracking

/* Sources */

class AnySource extends TaintSource {

    AnySource() {
        this instanceof ControlFlowNode
    }

    override predicate isSourceOf(TaintKind kind) { any() }

}
/* Flow */
import semmle.python.security.strings.Untrusted

from TaintSource src, TaintSink sink
where src.flowsToSink(sink)

select sink.toString(), "This message wouldn't appear if the query were complete $@",
       src.toString(), "nor this"


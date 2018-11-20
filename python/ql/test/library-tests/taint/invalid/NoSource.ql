
import python

import semmle.python.security.TaintTracking

/* Flow */
import semmle.python.security.strings.Untrusted

/* Sinks */

class AnySink extends TaintSink{

    AnySink() {
        this instanceof ControlFlowNode
    }

    override predicate sinks(TaintKind kind) { any() }

}

from TaintSource src, TaintSink sink
where src.flowsToSink(sink)

select sink.toString(), "This message wouldn't appear if the query were complete $@",
       src.toString(), "nor this"


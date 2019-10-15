/**
 * @name Possible binding to all interfaces.
 * @description Possible binding to all interfaces.
 * 		https://bandit.readthedocs.io/en/latest/plugins/b104_hardcoded_bind_all_interfaces.html
 * @kind problem
 * @tags reliability
 *       security
 * @problem.severity warning
 * @precision medium
 * @id py/bandit/binding
 */

import python
import semmle.python.security.TaintTracking



predicate interfaceBinding(ControlFlowNode f) {
  exists(Tuple p | p = f.getNode() | p.getElt(0).(StrConst).getText() = "0.0.0.0" )	
}

class BindingTuple extends TaintKind {

    BindingTuple() {
        this = "Binding Tuple"
    }
}

class BindingTupleSource extends TaintSource {

    BindingTupleSource() {
        interfaceBinding(this)
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof BindingTuple
    }
}

class TupleSink extends TaintSink {
      TupleSink() {
        exists(CallNode c | c.getFunction().(AttrNode).getName() = "bind" and c.getAnArg() = this)
	    }
	    
    override predicate sinks(TaintKind kind) {
        kind instanceof BindingTuple
    }	    
}

from TaintSource src, TaintSink sink

where src.flowsToSink(sink) 
select sink, "Possible binding to all interfaces"

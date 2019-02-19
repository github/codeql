import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted

import TurboGears



class ControllerMethodReturnValue extends TaintSink {

    ControllerMethodReturnValue() {
        exists(TurboGearsControllerMethod m |
            m.getAReturnValueFlowNode() = this and
            not m.isTemplated()
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof ExternalStringKind
    }

}

class ControllerMethodTemplatedReturnValue extends TaintSink {

    ControllerMethodTemplatedReturnValue() {
        exists(TurboGearsControllerMethod m |
            m.getAReturnValueFlowNode() = this and
            m.isTemplated()
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof ExternalStringDictKind
    }

}
import python
import semmle.python.security.TaintTracking

class OpenFile extends TaintKind {

    OpenFile() { this = "file.open" }

    override string repr() { result = "an open file" }


}

class OpenFileConfiguration extends TaintTracking::Configuration {

    OpenFileConfiguration() {  this = "Open file configuration" }

    override predicate isSource(DataFlow::Node src, TaintKind kind) {
        theOpenFunction().(FunctionObject).getACall() = src.asCfgNode() and
        kind instanceof OpenFile
    }

    override predicate isSink(DataFlow::Node sink, TaintKind kind) {
        none()
    }

}

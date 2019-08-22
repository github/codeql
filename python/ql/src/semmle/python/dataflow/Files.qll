import python
import semmle.python.security.TaintTracking

class OpenFile extends TaintKind {

    OpenFile() { this = "file.open" }

    override string repr() { result = "an open file" }


}


class OpenFileSource extends TaintSource {

    OpenFileSource() {
        theOpenFunction().(FunctionObject).getACall() = this
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof OpenFile
    }

}
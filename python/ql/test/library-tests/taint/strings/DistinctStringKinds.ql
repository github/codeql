import python
import semmle.python.security.TaintTracking

import semmle.python.security.Exceptions
import semmle.python.security.strings.Untrusted


class ExceptionInfoSource extends TaintSource {

    ExceptionInfoSource() { this.(NameNode).getId() = "TAINTED_EXCEPTION_INFO" }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof ExceptionInfo
    }

    override string toString() {
        result = "Exception info source"
    }

}

class ExternalStringSource extends TaintSource {

    ExternalStringSource() { this.(NameNode).getId() = "TAINTED_EXTERNAL_STRING" }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof ExternalStringKind
    }

    override string toString() {
        result = "Untrusted string source"
    }

}
from TaintedNode n
where n.getLocation().getFile().getName().matches("%test.py")
select "Taint " + n.getTaintKind(), n.getLocation().toString(), n.getAstNode(), n.getContext()


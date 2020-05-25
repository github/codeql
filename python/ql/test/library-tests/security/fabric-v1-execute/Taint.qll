import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted

class SimpleSource extends TaintSource {
    SimpleSource() { this.(NameNode).getId() = "TAINTED_STRING" }

    override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }

    override string toString() { result = "taint source" }
}

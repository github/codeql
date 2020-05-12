import python
import semmle.python.security.TaintTracking

abstract class SSRFSink extends TaintSink {
    bindingset[this]
    SSRFSink() { this = this }
}

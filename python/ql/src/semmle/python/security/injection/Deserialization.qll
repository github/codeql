
import python
import semmle.python.security.TaintTracking


/** `pickle.loads(untrusted)` vulnerability. */
abstract class DeserializationSink extends TaintSink {

    bindingset[this]
    DeserializationSink() {
        this = this
    }

}

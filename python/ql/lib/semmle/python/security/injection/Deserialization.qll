import python
import semmle.python.dataflow.TaintTracking

/** `pickle.loads(untrusted)` vulnerability. */
abstract deprecated class DeserializationSink extends TaintSink {
  bindingset[this]
  DeserializationSink() { this = this }
}

import semmle.python.dataflow.TaintTracking

/**
 * A generic taint sink that is vulnerable to template inclusions.
 * The `temp` in `Jinja2.Template(temp)` and similar.
 */
abstract class SSTISink extends TaintSink { }

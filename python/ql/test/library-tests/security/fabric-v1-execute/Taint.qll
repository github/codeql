import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.security.injection.Command

class SimpleSource extends TaintSource {
  SimpleSource() { this.(NameNode).getId() = "TAINTED_STRING" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }

  override string toString() { result = "taint source" }
}

class FabricExecuteTestConfiguration extends TaintTracking::Configuration {
  FabricExecuteTestConfiguration() { this = "FabricExecuteTestConfiguration" }

  override predicate isSource(TaintTracking::Source source) { source instanceof SimpleSource }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof CommandSink }

  override predicate isExtension(TaintTracking::Extension extension) {
    extension instanceof FabricExecuteExtension
  }
}

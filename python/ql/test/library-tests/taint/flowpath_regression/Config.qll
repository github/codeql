import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted

class FooSource extends TaintSource {
  FooSource() { this.(CallNode).getFunction().(NameNode).getId() = "foo_source" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof UntrustedStringKind }

  override string toString() { result = "FooSource" }
}

class FooSink extends TaintSink {
  FooSink() {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "foo_sink" and
      call.getAnArg() = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof UntrustedStringKind }

  override string toString() { result = "FooSink" }
}

class FooConfig extends TaintTracking::Configuration {
  FooConfig() { this = "FooConfig" }

  override predicate isSource(TaintTracking::Source source) { source instanceof FooSource }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof FooSink }
}

class BarSink extends TaintSink {
  BarSink() {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "bar_sink" and
      call.getAnArg() = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof UntrustedStringKind }

  override string toString() { result = "BarSink" }
}

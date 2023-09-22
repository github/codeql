import javascript
private import semmle.javascript.security.dataflow.CodeInjectionCustomizations

query predicate test_CodeInjectionSink(CodeInjection::Sink cmd, DataFlow::Node res) { res = cmd }

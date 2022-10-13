import javascript 
import semmle.javascript.security.dataflow.ReflectedXssCustomizations

query predicate test_XSS(ReflectedXss::Sink sink, Http::ResponseSendArgument res) {
  sink = res
}

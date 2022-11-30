import javascript
import semmle.javascript.security.dataflow.ReflectedXssCustomizations

query predicate test_Xss(ReflectedXss::Sink sink, Http::ResponseSendArgument res) { sink = res }

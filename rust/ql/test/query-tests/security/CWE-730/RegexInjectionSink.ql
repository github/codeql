private import codeql.rust.dataflow.DataFlow
private import codeql.rust.security.regex.RegexInjectionExtensions

query predicate regexInjectionSink(DataFlow::Node node) { node instanceof RegexInjectionSink }

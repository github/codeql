private import codeql.ruby.frameworks.Twirp
private import codeql.ruby.DataFlow

query predicate sourceTest(Twirp::UnmarshaledParameter source) { any() }

query predicate ssrfSinkTest(Twirp::ServiceUrlAsSsrfSink sink) { any() }

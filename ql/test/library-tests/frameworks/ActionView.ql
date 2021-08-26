import codeql_ruby.frameworks.ActionController
import codeql_ruby.frameworks.ActionView

query predicate htmlSafeCalls(HtmlSafeCall c) { any() }

query predicate rawCalls(RawCall c) { any() }

query predicate renderCalls(RenderCall c) { any() }

query predicate renderToCalls(RenderToCall c) { any() }

query predicate linkToCalls(LinkToCall c) { any() }

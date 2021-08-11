import codeql.ruby.frameworks.ActionController
import codeql.ruby.frameworks.ActionView

query predicate htmlSafeCalls(HtmlSafeCall c) { any() }

query predicate rawCalls(RawCall c) { any() }

query predicate renderCalls(RenderCall c) { any() }

query predicate renderToCalls(RenderToCall c) { any() }

query predicate linkToCalls(LinkToCall c) { any() }

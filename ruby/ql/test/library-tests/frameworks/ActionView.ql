private import ruby
private import codeql.ruby.AST
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.frameworks.ActionView
private import codeql.ruby.Concepts

query predicate htmlSafeCalls(HtmlSafeCall c) { any() }

query predicate rawCalls(RawCall c) { any() }

query predicate renderCalls(RenderCall c) { any() }

query predicate renderToCalls(RenderToCall c) { any() }

query predicate linkToCalls(LinkToCall c) { any() }

query predicate httpResponses(Http::Server::HttpResponse r, DataFlow::Node body, string mimeType) {
  r.getBody() = body and r.getMimetype() = mimeType
}

query predicate rawHelperCalls(ActionView::Helpers::RawHelperCall c, Expr arg) {
  arg = c.getRawArgument()
}

import ruby
import codeql.ruby.frameworks.Sinatra
import codeql.ruby.Concepts
import codeql.ruby.AST

query predicate routes(Sinatra::App app, Sinatra::Route route) { route = app.getARoute() }

query predicate params(Http::Server::RequestInputAccess params) { any() }

query predicate erbCalls(Sinatra::ErbCall c, ErbFile templateFile) {
  templateFile = c.getTemplateFile()
}

query predicate erbSyntheticGlobals(Sinatra::ErbLocalsHashSyntheticGlobal g, ErbFile file) {
  file = g.getErbFile()
}

query predicate filters(Sinatra::Filter filter, string kind) {
  filter instanceof Sinatra::BeforeFilter and kind = "before"
  or
  filter instanceof Sinatra::AfterFilter and kind = "after"
}

query predicate filterPatterns(Sinatra::Filter filter, DataFlow::ExprNode pattern) {
  pattern = filter.getPattern()
}

query predicate additionalFlowSteps(DataFlow::Node pred, DataFlow::Node succ) {
  any(Sinatra::FilterJumpStep s).step(pred, succ)
}

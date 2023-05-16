private import codeql.ruby.frameworks.Rack
private import codeql.ruby.DataFlow

query predicate rackApps(Rack::AppCandidate c, DataFlow::ParameterNode env) { env = c.getEnv() }

query predicate rackResponseStatusCodes(Rack::ResponseNode resp, int status) {
  status = resp.getAStatusCode()
}

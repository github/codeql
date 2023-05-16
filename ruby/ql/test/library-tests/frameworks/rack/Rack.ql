private import codeql.ruby.frameworks.Rack
private import codeql.ruby.DataFlow

query predicate rackApps(Rack::AppCandidate c, DataFlow::ParameterNode env) { env = c.getEnv() }

query predicate rackResponseStatusCodes(Rack::ResponseNode resp, string status) {
  if exists(resp.getAStatusCode())
  then status = resp.getAStatusCode().toString()
  else status = "<unknown>"
}

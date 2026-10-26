import codeql.ruby.Concepts
import codeql.ruby.DataFlow

query predicate httpRequests(Http::Client::Request r) { any() }

query string getFramework(Http::Client::Request req) { result = req.getFramework() }

query DataFlow::Node getResponseBody(Http::Client::Request req) { result = req.getResponseBody() }

query DataFlow::Node getAUrlPart(Http::Client::Request req) { result = req.getAUrlPart() }

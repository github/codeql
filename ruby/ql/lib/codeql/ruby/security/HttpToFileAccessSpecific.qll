/**
 * Provides imports and classes needed for `HttpToFileAccessQuery` and `HttpToFileAccessCustomizations`.
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.Concepts
import codeql.ruby.TaintTracking
private import HttpToFileAccessCustomizations::HttpToFileAccess

/**
 * An access to a user-controlled HTTP request input, considered as a flow source for writing user-controlled data to files
 */
private class RequestInputAccessAsSource extends Source instanceof HTTP::Server::RequestInputAccess {
}

/** A response from an outgoing HTTP request, considered as a flow source for writing user-controlled data to files. */
private class HttpResponseAsSource extends Source {
  HttpResponseAsSource() { this = any(HTTP::Client::Request r).getResponseBody() }
}

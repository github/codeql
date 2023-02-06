/**
 * Provides imports and classes needed for `HttpToFileAccessQuery` and `HttpToFileAccessCustomizations`.
 */

import javascript
private import HttpToFileAccessCustomizations::HttpToFileAccess

/**
 * An access to a user-controlled HTTP request input, considered as a flow source for writing user-controlled data to files
 */
private class RequestInputAccessAsSource extends Source instanceof Http::RequestInputAccess { }

/** A response from a server, considered as a flow source for writing user-controlled data to files. */
private class ServerResponseAsSource extends Source {
  ServerResponseAsSource() { this = any(ClientRequest r).getAResponseDataNode() }
}

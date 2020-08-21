/**
 * Provides classes that heuristically increase the extent of the sources in security queries.
 *
 * Note: This module should not be a permanent part of the standard library imports.
 */

import javascript
import SyntacticHeuristics
private import semmle.javascript.security.dataflow.CommandInjectionCustomizations

/**
 * A heuristic source of data flow in a security query.
 */
abstract class HeuristicSource extends DataFlow::Node { }

/**
 * An access to a password, viewed a source of remote flow.
 */
private class RemoteFlowPassword extends HeuristicSource, RemoteFlowSource {
  RemoteFlowPassword() { isReadFrom(this, "(?is).*(password|passwd).*") }

  override string getSourceType() { result = "a user provided password" }
}

/**
 * A use of `JSON.stringify`, viewed as a source for command-line injections
 * since it does not properly escape single quotes and dollar symbols.
 */
private class JSONStringifyAsCommandInjectionSource extends HeuristicSource,
  CommandInjection::Source {
  JSONStringifyAsCommandInjectionSource() { this instanceof JsonStringifyCall }

  override string getSourceType() { result = "a string from JSON.stringify" }
}

/**
 * A response from a remote server.
 */
class RemoteServerResponse extends HeuristicSource, RemoteFlowSource {
  RemoteServerResponse() {
    exists(ClientRequest r |
      this = r.getAResponseDataNode() and
      not exists(string url, string protocolPattern |
        // exclude URLs to the current host
        r.getUrl().mayHaveStringValue(url) and
        protocolPattern = "(?[a-z+]{3,10}:)" and
        not url.regexpMatch(protocolPattern + "?//.*")
      )
    )
  }

  override string getSourceType() { result = "a response from a remote server" }
}

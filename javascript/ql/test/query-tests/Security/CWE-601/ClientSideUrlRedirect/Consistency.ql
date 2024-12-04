import javascript
import semmle.javascript.security.dataflow.ClientSideUrlRedirectQuery
import testUtilities.ConsistencyChecking

deprecated class ClientSideUrlRedirectConsistency extends ConsistencyConfiguration {
  ClientSideUrlRedirectConsistency() { this = "ClientSideUrlRedirectConsistency" }

  override DataFlow::Node getAnAlert() { ClientSideUrlRedirectFlow::flowTo(result) }
}

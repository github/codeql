import javascript
import semmle.javascript.security.dataflow.RequestForgeryQuery as RequestForgery
import semmle.javascript.security.dataflow.ClientSideRequestForgeryQuery as ClientSideRequestForgery
deprecated import testUtilities.ConsistencyChecking

query predicate resultInWrongFile(DataFlow::Node node) {
  exists(string filePattern |
    RequestForgery::RequestForgeryFlow::flowTo(node) and
    filePattern = ".*serverSide.*"
    or
    ClientSideRequestForgery::ClientSideRequestForgeryFlow::flowTo(node) and
    filePattern = ".*clientSide.*"
  |
    not node.getFile().getRelativePath().regexpMatch(filePattern)
  )
}

class Consistency extends ConsistencyConfiguration {
  Consistency() { this = "Consistency" }

  override DataFlow::Node getAnAlert() {
    RequestForgery::RequestForgeryFlow::flowTo(result) or
    ClientSideRequestForgery::ClientSideRequestForgeryFlow::flowTo(result)
  }
}

import javascript
import semmle.javascript.security.dataflow.RequestForgeryQuery as RequestForgery
import semmle.javascript.security.dataflow.ClientSideRequestForgeryQuery as ClientSideRequestForgery
import testUtilities.ConsistencyChecking

query predicate resultInWrongFile(DataFlow::Node node) {
  exists(DataFlow::Configuration cfg, string filePattern |
    cfg instanceof RequestForgery::Configuration and
    filePattern = ".*serverSide.*"
    or
    cfg instanceof ClientSideRequestForgery::Configuration and
    filePattern = ".*clientSide.*"
  |
    cfg.hasFlow(_, node) and
    not node.getFile().getRelativePath().regexpMatch(filePattern)
  )
}

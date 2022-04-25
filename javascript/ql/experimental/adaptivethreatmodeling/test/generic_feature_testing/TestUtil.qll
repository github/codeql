import javascript
import extraction.NoFeaturizationRestrictionsConfig

class Endpoint extends DataFlow::Node {
  Endpoint() { this.asExpr().(VarAccess).getName() = "endpoint" }
}

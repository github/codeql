import javascript

class Endpoint extends DataFlow::Node {
  Endpoint() { this.asExpr().(VarAccess).getName() = "endpoint" }
}

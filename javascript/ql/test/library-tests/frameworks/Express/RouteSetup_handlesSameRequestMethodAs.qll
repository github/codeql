import javascript

query predicate test_RouteSetup_handlesSameRequestMethodAs(
  Express::RouteSetup rs, Express::RouteSetup rs2
) {
  rs.handlesSameRequestMethodAs(rs2) and
  rs.asExpr().getLocation().getStartLine() < rs2.asExpr().getLocation().getStartLine() and
  rs.asExpr().getLocation().getFile().getBaseName() = "csurf-example.js" and
  rs2.asExpr().getLocation().getFile().getBaseName() = "csurf-example.js"
}

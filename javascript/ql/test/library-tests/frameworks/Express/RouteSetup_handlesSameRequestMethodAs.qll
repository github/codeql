import javascript

query predicate test_RouteSetup_handlesSameRequestMethodAs(
  Express::RouteSetup rs, Express::RouteSetup rs2
) {
  rs.handlesSameRequestMethodAs(rs2) and
  rs.getLocation().getStartLine() < rs2.getLocation().getStartLine() and
  rs.getLocation().getFile().getBaseName() = "csurf-example.js" and
  rs2.getLocation().getFile().getBaseName() = "csurf-example.js"
}

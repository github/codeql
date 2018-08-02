import javascript

from Express::RouteSetup rs, Express::RouteSetup rs2
where rs.handlesSameRequestMethodAs(rs2) and
      rs.getLocation().getStartLine() < rs2.getLocation().getStartLine() and
      rs.getLocation().getFile().getBaseName() = "csurf-example.js" and
      rs2.getLocation().getFile().getBaseName() = "csurf-example.js"
select rs, rs2

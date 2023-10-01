import go
import semmle.go.security.CommandInjection
import CommandInjection::Flow::PathGraph

from CommandInjection::Flow::PathNode source, CommandInjection::Flow::PathNode sink
where CommandInjection::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"

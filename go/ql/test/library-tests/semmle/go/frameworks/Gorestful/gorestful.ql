import go
import semmle.go.security.CommandInjection
import CommandInjection::TaintConfiguration::PathGraph

from
  CommandInjection::TaintConfiguration::PathNode source,
  CommandInjection::TaintConfiguration::PathNode sink
where CommandInjection::TaintConfiguration::flowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"

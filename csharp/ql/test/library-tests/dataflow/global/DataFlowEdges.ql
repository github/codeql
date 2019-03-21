import csharp
import DataFlow

class ConfigAny extends Configuration {
  ConfigAny() { this = "ConfigAny" }

  override predicate isSource(Node source) { any() }

  override predicate isSink(Node sink) { any() }
}

query predicate edges(PathNode a, PathNode b) { a.getASuccessor() = b }

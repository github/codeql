import csharp

ControlFlow::Node successor(ControlFlow::Node node, boolean kind) {
  kind = true and result = node.getATrueSuccessor()
  or
  kind = false and result = node.getAFalseSuccessor()
}

from ControlFlow::Node node, ControlFlow::Node successor, Location nl, Location sl, boolean kind
where
  successor = successor(node, kind) and
  nl = node.getLocation() and
  sl = successor.getLocation()
select nl.getStartLine(), nl.getStartColumn(), node, kind, sl.getStartLine(), sl.getStartColumn(),
  successor

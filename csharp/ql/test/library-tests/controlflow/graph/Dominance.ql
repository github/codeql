import csharp

from ControlFlow::Node dom, ControlFlow::Node node, string s
where
  dom.strictlyDominates(node) and dom.getASuccessor() = node and s = "pre"
  or
  dom.strictlyPostDominates(node) and dom.getAPredecessor() = node and s = "post"
select s, dom, node

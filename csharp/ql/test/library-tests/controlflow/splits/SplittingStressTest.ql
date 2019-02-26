import csharp

from ControlFlowElement cfe, int i
where i = strictcount(ControlFlow::Nodes::ElementNode n | n.getElement() = cfe)
select cfe, i

import javascript

from MemberDeclaration member
where member.(ControlFlowNode).isUnreachable()
select member, "unreachable"

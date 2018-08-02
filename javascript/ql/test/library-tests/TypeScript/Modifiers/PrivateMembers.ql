import javascript

from MemberDeclaration member
where member.isPrivate()
select member.getStartLine().getText()

import javascript

from MemberDeclaration member
where member.isPublic()
select member.getStartLine().getText()

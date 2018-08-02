import javascript

from MemberDeclaration member
where member.isProtected()
select member.getStartLine().getText()

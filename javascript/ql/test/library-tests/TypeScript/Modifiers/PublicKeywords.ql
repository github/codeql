import javascript

from MemberDeclaration member
where member.hasPublicKeyword()
select member.getStartLine().getText()

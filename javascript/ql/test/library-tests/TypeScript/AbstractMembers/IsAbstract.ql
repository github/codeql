import javascript

from MemberDeclaration member
where member.isAbstract()
select member,
  "Member " + member.getName() + " of " + member.getDeclaringType().describe() + " is abstract"

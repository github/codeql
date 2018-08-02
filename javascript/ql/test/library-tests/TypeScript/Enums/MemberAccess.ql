import javascript

from VarAccess access, EnumMember member
where access.getVariable().getADeclaration() = member.getIdentifier()
select access, member

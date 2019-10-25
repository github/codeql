import cpp

from Class c, Declaration member
where not member.(Function).isCompilerGenerated()
select c.getQualifiedName(), member.getQualifiedName(), c.accessOfBaseMember(member).getName()

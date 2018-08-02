import cpp

from File f, LocalVariable v
where f.getADeclaration() = v
select f.toString(), v

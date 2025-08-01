import java

from ModuleImportDeclaration mid
select mid.getModuleName(), mid.getAnImportedType().getQualifiedName()

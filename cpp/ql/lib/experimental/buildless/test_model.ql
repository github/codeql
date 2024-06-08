import Model

from TestModel::SourceDeclaration decl
where decl.getParent+()=decl
select decl, "This has an invalid parent $@", decl.getParent()
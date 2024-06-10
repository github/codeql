import Model

query predicate multipleDefinitions(TestModel::Type type, TestModel::SourceTypeDefinition def1, TestModel::SourceTypeDefinition def2)
{
    def1 = type.getADefinition() and
    def2 = type.getADefinition() and 
    def1.getLocation() != def2.getLocation() and
    def1 != def2
}

from TestModel::SourceDeclaration decl
where decl.getParent+()=decl
select decl, "This has an invalid parent $@", decl.getParent()
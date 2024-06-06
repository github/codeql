import types

query predicate constPointers(TestAST::SourceType t, TestAST::SourceConst c, TestAST::SourcePointer p)
{
    p.getType() = c and 
    t = c.getType()
}

query predicate constRefs(TestAST::SourceType t, TestAST::SourceConst c, TestAST::SourceReference p)
{
    p.getType() = c and 
    t = c.getType()
}

from TestTypes::Type t
select t
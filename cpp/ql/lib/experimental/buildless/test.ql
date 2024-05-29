import ast

query TestAST::SourceFunction lua_copy()
{
    result.getName() = "lua_copy"
}

query int lua_copy_count()
{
    result = count(lua_copy())
}

query predicate variables(TestAST::VariableDeclaration v)
{
    any()
}

query predicate naiveCallTargets(TestAST::CallExpr call, TestAST::SourceFunction target)
{
    call.getReceiver().(TestAST::AccessExpr).getName() = target.getName()

    and target.getName() = "max"
}

from TestAST::SourceFunction fn, int i
// where fn.getName() = "lua_copy" and i=0
select fn, i, fn.getParameter(i)



// ::Node fn, CompiledAST::Node body
// where CompiledAST::functionBody(fn, body)
// select fn, body



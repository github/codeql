import ast

query TestAST::SourceFunction lua_copy()
{
    result.getName() = "lua_copy"
}

query int lua_copy_count()
{
    result = count(lua_copy())
}


from TestAST::SourceFunction fn, int i
// where fn.getName() = "lua_copy" and i=0
select fn, i, fn.getParameter(i)



// ::Node fn, CompiledAST::Node body
// where CompiledAST::functionBody(fn, body)
// select fn, body



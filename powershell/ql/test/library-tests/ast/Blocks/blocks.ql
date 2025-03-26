import powershell

query predicate paramBlockHasParam(ScriptBlock block, int i, Parameter p) {
    p = block.getParameter(i)
}
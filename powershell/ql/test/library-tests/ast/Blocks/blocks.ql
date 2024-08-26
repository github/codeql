import powershell

query predicate paramBlockHasParam(ParamBlock block, int i, Parameter p) {
    p = block.getParameter(i)
}
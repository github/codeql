import python
import Taint

from TaintedNode tainted, AstNode ast
where
    ast = tainted.getAstNode() and
    ast.getLocation().getFile().getShortName() = "test.py" and
    not exists(Call call | call.contains(ast))
select ast, tainted.getTaintKind().getAQlClass(), tainted.getTaintKind()

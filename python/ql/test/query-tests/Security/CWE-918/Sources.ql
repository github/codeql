import python
import TaintSetup

from HttpRequestTaintSource source, TaintKind kind, AstNode ast
where
    source.isSourceOf(kind) and
    ast = source.(ControlFlowNode).getNode()
select ast, ast.getScope(), kind

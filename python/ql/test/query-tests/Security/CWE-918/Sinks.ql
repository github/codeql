import python
import TaintSetup

from Client::HttpRequestUrlTaintSink sink, TaintKind kind,  AstNode ast
where
    sink.sinks(kind) and
    ast = sink.(ControlFlowNode).getNode()
select ast, ast.getScope(), kind

import csharp

from StringLiteral l, DataFlow::Node n
where TaintTracking::localTaintStep+(DataFlow::exprNode(l), n)
select l, n

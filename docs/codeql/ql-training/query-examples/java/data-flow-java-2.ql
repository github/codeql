import java
import semmle.code.java.dataflow.DataFlow::DataFlow

from MethodCall ma, StringConcat stringConcat
where
  ma.getMethod().getName().matches("sparql%Query") and
  localFlow(exprNode(stringConcat), exprNode(ma.getArgument(0)))
select ma, "SPARQL query vulnerable to injection."

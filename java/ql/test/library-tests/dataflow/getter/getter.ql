import java
import semmle.code.java.dataflow.internal.DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowImplSpecific::Public
import semmle.code.java.dataflow.internal.DataFlowImplSpecific::Private

from Node n1, Content f, Node n2
where
  read(n1, f, n2) or
  getterStep(n1, f, n2)
select n1, n2, f

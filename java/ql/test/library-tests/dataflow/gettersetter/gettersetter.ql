import java
import semmle.code.java.dataflow.internal.DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowImplSpecific::Public
import semmle.code.java.dataflow.internal.DataFlowImplSpecific::Private

private predicate read(Node n1, Content f, Node n2) {
  readDirect(n1, f, n2) or
  argumentValueFlowsThrough(_, n1, TContentSome(f), TContentNone(), n2)
}

private predicate store(Node n1, Content f, Node n2) {
  storeDirect(n1, f, n2) or
  argumentValueFlowsThrough(_, n1, TContentNone(), TContentSome(f), n2)
}

from Node n1, Content f, Node n2, string k
where
  read(n1, f, n2) and k = "Read"
  or
  store(n1, f, n2) and k = "Store"
select k, n1, n2, f

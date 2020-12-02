/**
 * @kind problem
 */

import cpp
import Nodes
import IRConfiguration as IRConf
import ASTConfiguration as ASTConf
private import semmle.code.cpp.ir.dataflow.DataFlow as IR
private import semmle.code.cpp.dataflow.DataFlow as AST

from Node source, Node sink, IRConf::Conf irConf, ASTConf::Conf astConf, string msg
where
  irConf.hasFlow(source.asIR(), sink.asIR()) and
  not exists(AST::DataFlow::Node astSource, AST::DataFlow::Node astSink |
    astSource.asExpr() = source.asIR().asExpr() and
    astSink.asExpr() = sink.asIR().asExpr()
  |
    astConf.hasFlow(astSource, astSink)
  ) and
  msg = "IR only"
  or
  astConf.hasFlow(source.asAST(), sink.asAST()) and
  not exists(IR::DataFlow::Node irSource, IR::DataFlow::Node irSink |
    irSource.asExpr() = source.asAST().asExpr() and
    irSink.asExpr() = sink.asAST().asExpr()
  |
    irConf.hasFlow(irSource, irSink)
  ) and
  msg = "AST only"
select source, sink, msg

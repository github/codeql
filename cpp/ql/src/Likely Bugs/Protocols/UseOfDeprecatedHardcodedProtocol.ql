/**
 * @name boost::asio use of deprecated hardcoded protocol
 * @description Using a deprecated hard-coded protocol using the boost::asio library.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @security-severity 7.5
 * @id cpp/boost/use-of-deprecated-hardcoded-security-protocol
 * @tags security
 *       external/cwe/cwe-327
 */

import cpp
import semmle.code.cpp.security.boostorg.asio.protocols

from Expr protocolSource, Expr protocolSink, ConstructorCall cc
where
  BoostorgAsio::SslContextCallFlow::flow(DataFlow::exprNode(protocolSource),
    DataFlow::exprNode(protocolSink)) and
  not BoostorgAsio::SslContextCallTlsProtocolFlow::flow(DataFlow::exprNode(protocolSource),
    DataFlow::exprNode(protocolSink)) and
  cc.getArgument(0) = protocolSink and
  BoostorgAsio::SslContextCallBannedProtocolFlow::flow(DataFlow::exprNode(protocolSource),
    DataFlow::exprNode(protocolSink))
select protocolSink, "Usage of $@ specifying a deprecated hardcoded protocol $@ in function $@.",
  cc, "boost::asio::ssl::context::context", protocolSource, protocolSource.toString(),
  cc.getEnclosingFunction(), cc.getEnclosingFunction().toString()

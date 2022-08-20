/**
 * @name boost::asio Use of deprecated hardcoded Protocol
 * @description Using a deprecated hard-coded protocol using the boost::asio library.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @id cpp/boost/use-of-deprecated-hardcoded-security-protocol
 * @tags security
 *       external/cwe/cwe-327
 */

import cpp
import semmle.code.cpp.security.boostorg.asio.protocols

from
  BoostorgAsio::SslContextCallConfig config, Expr protocolSource, Expr protocolSink,
  ConstructorCall cc
where
  config.hasFlow(DataFlow::exprNode(protocolSource), DataFlow::exprNode(protocolSink)) and
  not exists(BoostorgAsio::SslContextCallTlsProtocolConfig tlsConfig |
    tlsConfig.hasFlow(DataFlow::exprNode(protocolSource), DataFlow::exprNode(protocolSink))
  ) and
  cc.getArgument(0) = protocolSink and
  exists(BoostorgAsio::SslContextCallBannedProtocolConfig bannedConfig |
    bannedConfig.hasFlow(DataFlow::exprNode(protocolSource), DataFlow::exprNode(protocolSink))
  )
select protocolSink, "Usage of $@ specifying a deprecated hardcoded protocol $@ in function $@.",
  cc, "boost::asio::ssl::context::context", protocolSource, protocolSource.toString(),
  cc.getEnclosingFunction(), cc.getEnclosingFunction().toString()

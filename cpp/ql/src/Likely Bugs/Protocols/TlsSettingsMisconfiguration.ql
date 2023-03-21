/**
 * @name Boost_asio TLS Settings Misconfiguration
 * @description Using the TLS or SSLv23 protocol from the boost::asio library, but not disabling deprecated protocols, or disabling minimum-recommended protocols.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @id cpp/boost/tls-settings-misconfiguration
 * @tags security
 *       external/cwe/cwe-326
 */

import cpp
import semmle.code.cpp.security.boostorg.asio.protocols

module ExistsAnyFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(BoostorgAsio::SslContextClass c | c.getAContructorCall() = source.asExpr())
  }

  predicate isSink(DataFlow::Node sink) {
    exists(BoostorgAsio::SslSetOptionsFunction f, FunctionCall fcSetOptions |
      f.getACallToThisFunction() = fcSetOptions and
      fcSetOptions.getQualifier() = sink.asExpr()
    )
  }
}

module ExistsAnyFlow = DataFlow::Make<ExistsAnyFlowConfig>;

bindingset[flag]
predicate isOptionSet(ConstructorCall cc, int flag, FunctionCall fcSetOptions) {
  exists(VariableAccess contextSetOptions |
    ExistsAnyFlow::hasFlow(DataFlow::exprNode(cc), DataFlow::exprNode(contextSetOptions)) and
    exists(BoostorgAsio::SslSetOptionsFunction f | f.getACallToThisFunction() = fcSetOptions |
      contextSetOptions = fcSetOptions.getQualifier() and
      forall(Expr optionArgument, Expr optionArgumentSource |
        optionArgument = fcSetOptions.getArgument(0) and
        BoostorgAsio::SslOptionFlow::hasFlow(DataFlow::exprNode(optionArgumentSource),
          DataFlow::exprNode(optionArgument))
      |
        optionArgument.getValue().toInt().bitShiftRight(16).bitAnd(flag) = flag
      )
    )
  )
}

bindingset[flag]
predicate isOptionNotSet(ConstructorCall cc, int flag) { not isOptionSet(cc, flag, _) }

from Expr protocolSource, Expr protocolSink, ConstructorCall cc, Expr e, string msg
where
  BoostorgAsio::SslContextCallTlsProtocolFlow::hasFlow(DataFlow::exprNode(protocolSource),
    DataFlow::exprNode(protocolSink)) and
  cc.getArgument(0) = protocolSink and
  (
    BoostorgAsio::isExprSslV23BoostProtocol(protocolSource) and
    not (
      isOptionSet(cc, BoostorgAsio::getShiftedSslOptionsNoSsl3(), _) and
      isOptionSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1(), _) and
      isOptionSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1_1(), _) and
      isOptionNotSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1_2())
    )
    or
    BoostorgAsio::isExprTlsBoostProtocol(protocolSource) and
    not BoostorgAsio::isExprSslV23BoostProtocol(protocolSource) and
    not (
      isOptionSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1(), _) and
      isOptionSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1_1(), _) and
      isOptionNotSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1_2())
    )
  ) and
  (
    BoostorgAsio::isExprSslV23BoostProtocol(protocolSource) and
    isOptionNotSet(cc, BoostorgAsio::getShiftedSslOptionsNoSsl3()) and
    e = cc and
    msg = "no_sslv3 has not been set"
    or
    isOptionNotSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1()) and
    e = cc and
    msg = "no_tlsv1 has not been set"
    or
    isOptionNotSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1_1()) and
    e = cc and
    msg = "no_tlsv1_1 has not been set"
    or
    isOptionSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1_2(), e) and
    msg = "no_tlsv1_2 was set"
  )
select cc,
  "This usage of 'boost::asio::ssl::context::context' with protocol $@ is not configured correctly: The option $@.",
  protocolSource, protocolSource.toString(), e, msg

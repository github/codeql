/**
 * @name boost::asio TLS settings misconfiguration
 * @description Using the TLS or SSLv23 protocol from the boost::asio library, but not disabling deprecated protocols, or disabling minimum-recommended protocols.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @security-severity 7.5
 * @id cpp/boost/tls-settings-misconfiguration
 * @tags security
 *       external/cwe/cwe-326
 */

import cpp
import semmle.code.cpp.security.boostorg.asio.protocols

predicate isSourceImpl(DataFlow::Node source, ConstructorCall cc) {
  exists(BoostorgAsio::SslContextClass c | c.getAContructorCall() = cc and cc = source.asExpr())
}

predicate isSinkImpl(DataFlow::Node sink, FunctionCall fcSetOptions) {
  exists(BoostorgAsio::SslSetOptionsFunction f |
    f.getACallToThisFunction() = fcSetOptions and
    fcSetOptions.getQualifier() = sink.asIndirectExpr()
  )
}

module ExistsAnyFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSourceImpl(source, _) }

  predicate isSink(DataFlow::Node sink) { isSinkImpl(sink, _) }
}

module ExistsAnyFlow = DataFlow::Global<ExistsAnyFlowConfig>;

bindingset[flag]
predicate isOptionSet(ConstructorCall cc, int flag, FunctionCall fcSetOptions) {
  exists(
    VariableAccess contextSetOptions, BoostorgAsio::SslSetOptionsFunction f, DataFlow::Node source,
    DataFlow::Node sink
  |
    isSourceImpl(source, cc) and
    isSinkImpl(sink, fcSetOptions) and
    ExistsAnyFlow::flow(source, sink) and
    f.getACallToThisFunction() = fcSetOptions and
    contextSetOptions = fcSetOptions.getQualifier() and
    forex(Expr optionArgument |
      optionArgument = fcSetOptions.getArgument(0) and
      BoostorgAsio::SslOptionFlow::flowTo(DataFlow::exprNode(optionArgument))
    |
      optionArgument.getValue().toInt().bitShiftRight(16).bitAnd(flag) = flag
    )
  )
}

bindingset[flag]
predicate isOptionNotSet(ConstructorCall cc, int flag) { not isOptionSet(cc, flag, _) }

from Expr protocolSource, Expr protocolSink, ConstructorCall cc, Expr e, string msg
where
  BoostorgAsio::SslContextCallTlsProtocolFlow::flow(DataFlow::exprNode(protocolSource),
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

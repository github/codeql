/**
 * @name Boost_asio TLS Settings Misconfiguration
 * @description Using TLS or SSLv23 protool from the boost::asio library, but not disabling deprecated protocols or disabling minimum-recommended protocols
 * @kind problem
 * @problem.severity error
 * @id cpp/boost/tls_settings_misconfiguration
 * @tags security
 */

import cpp
import semmle.code.cpp.security.boostorg.asio.protocols

class ExistsAnyFlowConfig extends DataFlow::Configuration {
  ExistsAnyFlowConfig() { this = "ExistsAnyFlowConfig" }

  override predicate isSource(DataFlow::Node source) { any() }

  override predicate isSink(DataFlow::Node sink) { any() }
}

bindingset[flag]
predicate isOptionSet(ConstructorCall cc, int flag, FunctionCall fcSetOptions) {
  exists(
    BoostorgAsio::SslContextFlowsToSetOptionConfig config, ExistsAnyFlowConfig testConfig,
    Expr optionsSink
  |
    config.hasFlow(DataFlow::exprNode(cc), DataFlow::exprNode(optionsSink)) and
    exists(VariableAccess contextSetOptions |
      testConfig.hasFlow(DataFlow::exprNode(cc), DataFlow::exprNode(contextSetOptions)) and
      exists(BoostorgAsio::SslSetOptionsFunction f | f.getACallToThisFunction() = fcSetOptions |
        contextSetOptions = fcSetOptions.getQualifier() and
        forall(
          Expr optionArgument, BoostorgAsio::SslOptionConfig optionArgConfig,
          Expr optionArgumentSource
        |
          optionArgument = fcSetOptions.getArgument(0) and
          optionArgConfig
              .hasFlow(DataFlow::exprNode(optionArgumentSource), DataFlow::exprNode(optionArgument))
        |
          optionArgument.getValue().toInt().bitShiftRight(16).bitAnd(flag) = flag
        )
      )
    )
  )
}

bindingset[flag]
predicate isOptionNotSet(ConstructorCall cc, int flag) {
  not exists(
    BoostorgAsio::SslContextFlowsToSetOptionConfig config, ExistsAnyFlowConfig testConfig,
    Expr optionsSink
  |
    config.hasFlow(DataFlow::exprNode(cc), DataFlow::exprNode(optionsSink)) and
    exists(VariableAccess contextSetOptions |
      testConfig.hasFlow(DataFlow::exprNode(cc), DataFlow::exprNode(contextSetOptions)) and
      exists(FunctionCall fcSetOptions, BoostorgAsio::SslSetOptionsFunction f |
        f.getACallToThisFunction() = fcSetOptions
      |
        contextSetOptions = fcSetOptions.getQualifier() and
        forall(
          Expr optionArgument, BoostorgAsio::SslOptionConfig optionArgConfig,
          Expr optionArgumentSource
        |
          optionArgument = fcSetOptions.getArgument(0) and
          optionArgConfig
              .hasFlow(DataFlow::exprNode(optionArgumentSource), DataFlow::exprNode(optionArgument))
        |
          optionArgument.getValue().toInt().bitShiftRight(16).bitAnd(flag) = flag
        )
      )
    )
  )
}

from
  BoostorgAsio::SslContextCallTlsProtocolConfig configConstructor,
  BoostorgAsio::SslContextFlowsToSetOptionConfig config, Expr protocolSource, Expr protocolSink,
  ConstructorCall cc, Expr e, string msg
where
  configConstructor.hasFlow(DataFlow::exprNode(protocolSource), DataFlow::exprNode(protocolSink)) and
  cc.getArgument(0) = protocolSink and
  (
    BoostorgAsio::isExprSslV23BoostProtocol(protocolSource) and
    not exists(Expr optionsSink |
      config.hasFlow(DataFlow::exprNode(cc), DataFlow::exprNode(optionsSink)) and
      isOptionSet(cc, BoostorgAsio::getShiftedSslOptionsNoSsl3(), _) and
      isOptionSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1(), _) and
      isOptionSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1_1(), _) and
      isOptionNotSet(cc, BoostorgAsio::getShiftedSslOptionsNoTls1_2())
    )
    or
    BoostorgAsio::isExprTlsBoostProtocol(protocolSource) and
    not BoostorgAsio::isExprSslV23BoostProtocol(protocolSource) and
    not exists(Expr optionsSink |
      config.hasFlow(DataFlow::exprNode(cc), DataFlow::exprNode(optionsSink)) and
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
select cc, "Usage of $@ with protocol $@ is not configured correctly: The option $@.", cc,
  "boost::asio::ssl::context::context", protocolSource, protocolSource.toString(), e, msg

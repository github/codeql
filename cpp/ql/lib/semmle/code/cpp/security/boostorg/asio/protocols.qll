import cpp
import semmle.code.cpp.dataflow.DataFlow

module BoostorgAsio {
  /**
   * Represents the `boost::asio::ssl::context` enum.
   */
  class SslContextMethod extends Enum {
    SslContextMethod() {
      this.getName().toString() = "method" and
      this.getQualifiedName().toString().matches("boost::asio::ssl::context%")
    }

    /**
     * Gets an enumeration constant for a banned protocol.
     */
    EnumConstant getABannedProtocolConstant() {
      result = this.getAnEnumConstant() and
      (
        /// Generic SSL version 2.
        result.getName() = "sslv2"
        or
        /// SSL version 2 client.
        result.getName() = "sslv2_client"
        or
        /// SSL version 2 server.
        result.getName() = "sslv2_server"
        or
        /// Generic SSL version 3.
        result.getName() = "sslv3"
        or
        /// SSL version 3 client.
        result.getName() = "sslv3_client"
        or
        /// SSL version 3 server.
        result.getName() = "sslv3_server"
        or
        /// Generic TLS version 1.
        result.getName() = "tlsv1"
        or
        /// TLS version 1 client.
        result.getName() = "tlsv1_client"
        or
        /// TLS version 1 server.
        result.getName() = "tlsv1_server"
        or
        /// Generic TLS version 1.1.
        result.getName() = "tlsv11"
        or
        /// TLS version 1.1 client.
        result.getName() = "tlsv11_client"
        or
        /// TLS version 1.1 server.
        result.getName() = "tlsv11_server"
      )
    }

    /**
     * Gets an enumeration constant for an approved protocol, that is hard-coded
     * (no protocol negotiation).
     */
    EnumConstant getAnApprovedButHardcodedProtocolConstant() {
      result = this.getATls12ProtocolConstant()
    }

    /**
     * Gets an enumeration constant for a TLS v1.2 protocol.
     */
    EnumConstant getATls12ProtocolConstant() {
      result = this.getAnEnumConstant() and
      (
        /// Generic TLS version 1.2.
        result.getName() = "tlsv12"
        or
        /// TLS version 1.2 client.
        result.getName() = "tlsv12_client"
        or
        /// TLS version 1.2 server.
        result.getName() = "tlsv12_server"
      )
    }

    /**
     * Gets an enumeration constant for a TLS v1.3 protocol.
     */
    EnumConstant getATls13ProtocolConstant() {
      result = this.getAnEnumConstant() and
      (
        /// Generic TLS version 1.3.
        result.getName() = "tlsv13"
        or
        /// TLS version 1.3 client.
        result.getName() = "tlsv13_client"
        or
        /// TLS version 1.3 server.
        result.getName() = "tlsv13_server"
      )
    }

    /**
     * Gets an enumeration constant for a generic TLS or SSL/TLS protocol.
     */
    EnumConstant getAGenericTlsProtocolConstant() {
      result = this.getAnEnumConstant() and
      (
        /// Generic TLS
        result.getName() = "tls"
        or
        /// TLS client.
        result.getName() = "tls_client"
        or
        /// TLS server.
        result.getName() = "tls_server"
      )
      or
      result = this.getASslv23ProtocolConstant()
    }

    /**
     * Gets an enumeration constant for a generic SSL/TLS protocol.
     */
    EnumConstant getASslv23ProtocolConstant() {
      result = this.getAnEnumConstant() and
      (
        /// OpenSSL - SSLv23 == A TLS/SSL connection established with these methods may understand the SSLv2, SSLv3, TLSv1, TLSv1.1 and TLSv1.2 protocols.
        /// Generic SSL/TLS.
        result.getName() = "sslv23"
        or
        /// SSL/TLS client.
        result.getName() = "sslv23_client"
        or
        /// SSL/TLS server.
        result.getName() = "sslv23_server"
      )
    }
  }

  /**
   * Gets the value for the no_sslv2 constant, right shifted by 16 bits.
   *
   * Note that modern versions of OpelSSL do not support SSL v2, so this option is for backwards compatibility only.
   */
  int getShiftedSslOptionsNoSsl2() {
    // SSL_OP_NO_SSLv2 was removed from modern OpenSSL versions
    result = 0
  }

  /**
   * Gets the value for the no_sslv3 constant, right shifted by 16 bits.
   */
  int getShiftedSslOptionsNoSsl3() {
    // SSL_OP_NO_SSLv3 == 0x02000000U
    result = 512
  }

  /**
   * Gets the value for the no_tlsv1 constant, right shifted by 16 bits.
   */
  int getShiftedSslOptionsNoTls1() {
    // SSL_OP_NO_TLSv1 == 0x04000000U
    result = 1024
  }

  /**
   * Gets the value for the no_tlsv1_1 constant, right shifted by 16 bits.
   */
  int getShiftedSslOptionsNoTls1_1() {
    // SSL_OP_NO_TLSv1_1 == 0x10000000U
    result = 4096
  }

  /**
   * Gets the value for the no_tlsv1_2 constant, right shifted by 16 bits.
   */
  int getShiftedSslOptionsNoTls1_2() {
    // SSL_OP_NO_TLSv1_2 == 0x08000000U
    result = 2048
  }

  /**
   * Gets the value for the no_tlsv1_3 constant, right shifted by 16 bits.
   */
  int getShiftedSslOptionsNoTls1_3() {
    // SSL_OP_NO_TLSv1_2 == 0x20000000U
    result = 8192
  }

  /**
   * Represents the `boost::asio::ssl::context` class.
   */
  class SslContextClass extends Class {
    SslContextClass() { this.getQualifiedName() = "boost::asio::ssl::context" }

    ConstructorCall getAContructorCall() {
      this.getAConstructor().getACallToThisFunction() = result and
      not result.getLocation().getFile().toString().matches("%/boost/asio/%") and
      result.fromSource()
    }
  }

  /**
   * Represents `boost::asio::ssl::context::set_options` member function.
   */
  class SslSetOptionsFunction extends Function {
    SslSetOptionsFunction() {
      this.getQualifiedName().matches("boost::asio::ssl::context::set_options")
    }
  }

  /**
   * Holds if the expression represents a banned protocol.
   */
  predicate isExprBannedBoostProtocol(Expr e) {
    exists(Literal va | va = e |
      va.getValue().toInt() = 0 or
      va.getValue().toInt() = 1 or
      va.getValue().toInt() = 2 or
      va.getValue().toInt() = 3 or
      va.getValue().toInt() = 4 or
      va.getValue().toInt() = 5 or
      va.getValue().toInt() = 6 or
      va.getValue().toInt() = 7 or
      va.getValue().toInt() = 8 or
      va.getValue().toInt() = 12 or
      va.getValue().toInt() = 13 or
      va.getValue().toInt() = 14
    )
    or
    exists(VariableAccess va | va = e |
      va.getValue().toInt() = 0 or
      va.getValue().toInt() = 1 or
      va.getValue().toInt() = 2 or
      va.getValue().toInt() = 3 or
      va.getValue().toInt() = 4 or
      va.getValue().toInt() = 5 or
      va.getValue().toInt() = 6 or
      va.getValue().toInt() = 7 or
      va.getValue().toInt() = 8 or
      va.getValue().toInt() = 12 or
      va.getValue().toInt() = 13 or
      va.getValue().toInt() = 14
    )
    or
    exists(EnumConstantAccess eca, SslContextMethod enum | e = eca |
      enum.getABannedProtocolConstant().getAnAccess() = eca
    )
  }

  /**
   * Holds if the expression represents a TLS v1.2 protocol.
   */
  predicate isExprTls12BoostProtocol(Expr e) {
    exists(Literal va | va = e |
      (
        va.getValue().toInt() = 15 or /// Generic TLS version 1.2.
        va.getValue().toInt() = 16 or /// TLS version 1.2 client.
        va.getValue().toInt() = 17 /// TLS version 1.2 server.
      )
    )
    or
    exists(VariableAccess va | va = e |
      (
        va.getValue().toInt() = 15 or /// Generic TLS version 1.2.
        va.getValue().toInt() = 16 or /// TLS version 1.2 client.
        va.getValue().toInt() = 17 /// TLS version 1.2 server.
      )
    )
    or
    exists(EnumConstantAccess eca, SslContextMethod enum | e = eca |
      enum.getATls12ProtocolConstant().getAnAccess() = eca
    )
  }

  /**
   * Holds if the expression represents a protocol that requires Crypto Board approval.
   */
  predicate isExprTls13BoostProtocol(Expr e) {
    exists(Literal va | va = e |
      (
        va.getValue().toInt() = 18 or
        va.getValue().toInt() = 19 or
        va.getValue().toInt() = 20
      )
    )
    or
    exists(VariableAccess va | va = e |
      (
        va.getValue().toInt() = 18 or
        va.getValue().toInt() = 19 or
        va.getValue().toInt() = 20
      )
    )
    or
    exists(EnumConstantAccess eca, SslContextMethod enum | e = eca |
      enum.getATls13ProtocolConstant().getAnAccess() = eca
    )
  }

  /**
   * Holds if the expression represents a generic TLS or SSL/TLS protocol.
   */
  predicate isExprTlsBoostProtocol(Expr e) {
    exists(Literal va | va = e |
      (
        va.getValue().toInt() = 9 or /// Generic SSL/TLS.
        va.getValue().toInt() = 10 or /// SSL/TLS client.
        va.getValue().toInt() = 11 or /// SSL/TLS server.
        va.getValue().toInt() = 21 or /// Generic TLS.
        va.getValue().toInt() = 22 or /// TLS client.
        va.getValue().toInt() = 23 /// TLS server.
      )
    )
    or
    exists(VariableAccess va | va = e |
      (
        va.getValue().toInt() = 9 or /// Generic SSL/TLS.
        va.getValue().toInt() = 10 or /// SSL/TLS client.
        va.getValue().toInt() = 11 or /// SSL/TLS server.
        va.getValue().toInt() = 21 or /// Generic TLS.
        va.getValue().toInt() = 22 or /// TLS client.
        va.getValue().toInt() = 23 /// TLS server.
      )
    )
    or
    exists(EnumConstantAccess eca, SslContextMethod enum | e = eca |
      enum.getAGenericTlsProtocolConstant().getAnAccess() = eca
    )
  }

  /**
   * Holds if the expression represents a generic SSl/TLS protocol.
   */
  predicate isExprSslV23BoostProtocol(Expr e) {
    exists(Literal va | va = e |
      (
        va.getValue().toInt() = 9 or /// Generic SSL/TLS.
        va.getValue().toInt() = 10 or /// SSL/TLS client.
        va.getValue().toInt() = 11 /// SSL/TLS server.
      )
    )
    or
    exists(VariableAccess va | va = e |
      (
        va.getValue().toInt() = 9 or /// Generic SSL/TLS.
        va.getValue().toInt() = 10 or /// SSL/TLS client.
        va.getValue().toInt() = 11 /// SSL/TLS server.
      )
    )
    or
    exists(EnumConstantAccess eca, SslContextMethod enum | e = eca |
      enum.getASslv23ProtocolConstant().getAnAccess() = eca
    )
  }

  //////////////////////// Dataflow /////////////////////
  /**
   * Abstract class for flows of protocol values to the first argument of a context
   * constructor.
   */
  abstract class SslContextCallAbstractConfig extends DataFlow::Configuration {
    bindingset[this]
    SslContextCallAbstractConfig() { any() }

    override predicate isSink(DataFlow::Node sink) {
      exists(ConstructorCall cc, SslContextClass c, Expr e | e = sink.asExpr() |
        c.getAContructorCall() = cc and
        cc.getArgument(0) = e
      )
    }
  }

  /**
   * Any protocol value that flows to the first argument of a context constructor.
   */
  class SslContextCallConfig extends SslContextCallAbstractConfig {
    SslContextCallConfig() { this = "SslContextCallConfig" }

    override predicate isSource(DataFlow::Node source) {
      exists(Expr e | e = source.asExpr() |
        e.fromSource() and
        not e.getLocation().getFile().toString().matches("%/boost/asio/%")
      )
    }
  }

  /**
   * A banned protocol value that flows to the first argument of a context constructor.
   */
  class SslContextCallBannedProtocolConfig extends SslContextCallAbstractConfig {
    SslContextCallBannedProtocolConfig() { this = "SslContextCallBannedProtocolConfig" }

    override predicate isSource(DataFlow::Node source) {
      exists(Expr e | e = source.asExpr() |
        e.fromSource() and
        not e.getLocation().getFile().toString().matches("%/boost/asio/%") and
        isExprBannedBoostProtocol(e)
      )
    }
  }

  /**
   * A TLS 1.2 protocol value that flows to the first argument of a context constructor.
   */
  class SslContextCallTls12ProtocolConfig extends SslContextCallAbstractConfig {
    SslContextCallTls12ProtocolConfig() { this = "SslContextCallTls12ProtocolConfig" }

    override predicate isSource(DataFlow::Node source) {
      exists(Expr e | e = source.asExpr() |
        e.fromSource() and
        not e.getLocation().getFile().toString().matches("%/boost/asio/%") and
        isExprTls12BoostProtocol(e)
      )
    }
  }

  /**
   * A TLS 1.3 protocol value that flows to the first argument of a context constructor.
   */
  class SslContextCallTls13ProtocolConfig extends SslContextCallAbstractConfig {
    SslContextCallTls13ProtocolConfig() { this = "SslContextCallTls12ProtocolConfig" }

    override predicate isSource(DataFlow::Node source) {
      exists(Expr e | e = source.asExpr() |
        e.fromSource() and
        not e.getLocation().getFile().toString().matches("%/boost/asio/%") and
        isExprTls13BoostProtocol(e)
      )
    }
  }

  /**
   * A generic TLS protocol value that flows to the first argument of a context constructor.
   */
  class SslContextCallTlsProtocolConfig extends SslContextCallAbstractConfig {
    SslContextCallTlsProtocolConfig() { this = "SslContextCallTlsProtocolConfig" }

    override predicate isSource(DataFlow::Node source) {
      exists(Expr e | e = source.asExpr() |
        e.fromSource() and
        not e.getLocation().getFile().toString().matches("%/boost/asio/%") and
        isExprTlsBoostProtocol(e)
      )
    }
  }

  /**
   * A context constructor call that flows to a call to `SetOptions()`.
   */
  class SslContextFlowsToSetOptionConfig extends DataFlow::Configuration {
    SslContextFlowsToSetOptionConfig() { this = "SslContextFlowsToSetOptionConfig" }

    override predicate isSource(DataFlow::Node source) {
      exists(SslContextClass c, ConstructorCall cc |
        cc = source.asExpr() and
        c.getAContructorCall() = cc
      )
    }

    override predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall fc, SslSetOptionsFunction f, Variable v, VariableAccess va |
        va = sink.asExpr()
      |
        f.getACallToThisFunction() = fc and
        v.getAnAccess() = va and
        va = fc.getQualifier()
      )
    }
  }

  /**
   * An option value that flows to the first parameter of a call to `SetOptions()`.
   */
  class SslOptionConfig extends DataFlow::Configuration {
    SslOptionConfig() { this = "SslOptionConfig" }

    override predicate isSource(DataFlow::Node source) {
      exists(Expr e | e = source.asExpr() |
        e.fromSource() and
        not e.getLocation().getFile().toString().matches("%/boost/asio/%")
      )
    }

    override predicate isSink(DataFlow::Node sink) {
      exists(SslSetOptionsFunction f, FunctionCall call |
        sink.asExpr() = call.getArgument(0) and
        f.getACallToThisFunction() = call and
        not sink.getLocation().getFile().toString().matches("%/boost/asio/%")
      )
    }
  }
}

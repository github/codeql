import cpp
import semmle.code.cpp.dataflow.new.TaintTracking

/**
 * A constant representing one or more security protocols for the `grbitEnabledProtocols` field.
 */
class ProtocolConstant extends Expr {
  ProtocolConstant() {
    this.isConstant() and
    GrbitEnabledConstantTace::flow(DataFlow::exprNode(this), _) and
    (
      this instanceof Literal
      or
      this = any(ConstantMacroInvocation mi).getExpr()
      or
      // This is a workaround for folded constants, which currently have no
      // dataflow node representation. Attach to the outermost dataflow node
      // where a literal exists as a child that has no dataflow node representation.
      exists(Literal l |
        this.getAChild*() = l and
        not exists(DataFlow::Node n | n.asExpr() = l)
      )
    )
  }

  /** Gets the bitmask represented by this constant. */
  int getBitmask() { result = this.getValue().toInt() }

  /** Holds if this constant only represents TLS1.3 protocols. */
  predicate isTLS1_3Only() {
    // Flags for TLS1.3 are 0x00001000 and 0x00002000
    // 12288 = 0x00001000 | 0x00002000
    this.getBitmask().bitAnd(12288.bitNot()) = 0 and
    not this.isSystemDefault()
  }

  /** Holds if this constant only represents TLS1.2 protocols. */
  predicate isTLS1_2Only() {
    // Flags for TLS1.2 are 0x00000400 and 0x00000800
    // 3072 = 0x00000400 | 0x00000800
    this.getBitmask().bitAnd(3072.bitNot()) = 0 and
    not this.isSystemDefault()
  }

  /** Holds if this constant only represents TLS1.1 protocols. */
  predicate isTLS1_1Only() {
    // Flags for TLS1.1 are 0x00000100 and 0x00000200
    // 768 = 0x00000100 | 0x00000200
    this.getBitmask().bitAnd(768.bitNot()) = 0 and
    not this.isSystemDefault()
  }

  /** Holds if this constant only represents TLS1.0 protocols. */
  predicate isTLS1_0Only() {
    // Flags for TLS1.0 are 0x00000040 and 0x00000080
    // 192 = 0x00000040 | 0x00000080
    this.getBitmask().bitAnd(192.bitNot()) = 0 and
    not this.isSystemDefault()
  }

  /** Holds if this constant only represents TLS1.1 protocols. */
  predicate isSSL3Only() {
    // Flags for SSL3 are 0x00000010 and 0x00000020
    // 48 = 0x00000010 | 0x00000020
    this.getBitmask().bitAnd(48.bitNot()) = 0 and
    not this.isSystemDefault()
  }

  /** Holds if this constant only represents SSL2 protocols. */
  predicate isSSL2Only() {
    // Flags for TLS1.0 are 0x00000004 and 0x00000008
    // 12 = 0x00000004 | 0x00000008
    this.getBitmask().bitAnd(12.bitNot()) = 0 and
    not this.isSystemDefault()
  }

  /** Holds if this constant only represents PCT1 protocols. */
  predicate isPCT1Only() {
    // Flags for PCT are 0x00000001 and 0x00000002
    // 3 = 0x00000001 | 0x00000002
    this.getBitmask().bitAnd(3.bitNot()) = 0 and
    not this.isSystemDefault()
  }

  /** Holds if this constant only represents any combination of TLS-related protocols. */
  predicate isHardcodedProtocol() {
    // 16383 = SP_PROT_TLS1_3 | SP_PROT_TLS1_2 | SP_PROT_TLS1_1 | SP_PROT_TLS1_3
    //         | SP_PROT_TLS1 | SP_PROT_SSL3 | SP_PROT_SSL2 | SP_PROT_PCT1
    this.getBitmask().bitAnd(16383.bitNot()) = 0 and
    not this.isSystemDefault()
  }

  /** Holds if this constant represents the system default protocol. */
  predicate isSystemDefault() { this.getBitmask() = 0 }
}

/**
 * A data flow configuration that tracks from constant values to assignments to the
 * `grbitEnabledProtocols` field on the SCHANNEL_CRED structure.
 */
module GrbitEnabledConstantConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().isConstant() }

  predicate isSink(DataFlow::Node sink) {
    exists(Field grbitEnabledProtocols |
      grbitEnabledProtocols.hasName("grbitEnabledProtocols") and
      sink.asExpr() = grbitEnabledProtocols.getAnAssignedValue()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    // Do not flow through other macro invocations if they would, themselves, be represented
    node.asExpr() = any(ConstantMacroInvocation mi).getExpr().getAChild+()
    or
    // Do not flow through complements, as they change the meaning
    node.asExpr() instanceof ComplementExpr
  }
}

module GrbitEnabledConstantTace = TaintTracking::Global<GrbitEnabledConstantConfiguration>;

/**
 * A macro that represents a constant value.
 */
class ConstantMacroInvocation extends MacroInvocation {
  ConstantMacroInvocation() {
    exists(this.getExpr().getValue()) and
    not this.getMacro().getHead().matches("%(%)%")
  }
}

/**
 * Gets the name of the constant `val`, if it is a constant.
 */
string getConstantName(Expr val) {
  exists(val.getValue()) and
  if exists(ConstantMacroInvocation mi | mi.getExpr() = val)
  then result = any(ConstantMacroInvocation mi | mi.getExpr() = val).getMacroName()
  else result = val.toString()
}

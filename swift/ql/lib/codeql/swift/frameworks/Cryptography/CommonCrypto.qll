/** Provides models and concepts from the CommonCrypto C library */

private import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.security.Cryptography

/**
 * A model for CommonCrypto functions that permit taint flow.
 */
private class CommonCryptoSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // "namespace; type; subtypes; name; signature; ext; input; output; kind"
        ";;false;CCCryptorCreate(_:_:_:_:_:_:_:);;;Argument[1];Argument[6];value",
        ";;false;CCCryptorCreateFromData(_:_:_:_:_:_:_:_:_:_:);;;Argument[1];Argument[8];value",
        ";;false;CCCryptorCreateWithMode(_:_:_:_:_:_:_:_:_:_:_:_:);;;Argument[1..2];Argument[10];value",
      ]
  }
}

/** A data flow node for the output of a CommonCrypto encryption/decryption operation */
abstract private class CommonCryptoOutputNode extends CryptographicOperation::Range {
  override CryptographicAlgorithm getAlgorithm() { none() }

  override DataFlow::Node getAnInput() { none() }

  override BlockMode getBlockMode() { none() }
}

/**
 * A declaration of a constant representing a value of the
 * `CCAlgorithm` C enum, such as `kCCAlgorithmAES128`.
 */
private class AlgorithmConstantDecl extends VarDecl {
  AlgorithmConstantDecl() { this.getName().matches("kCCAlgorithm%") }

  string getAlgorithmName() { this.getName() = "kCCAlgorithm" + result }

  CryptographicAlgorithm asAlgorithm() { result.matchesName(this.getAlgorithmName()) }
}

/**
 * Data flow configuration from a `CCAlgorithm` constant (or `CCAlgorithm`-bearing `CCCryptorRef`)
 * to a call where it appears as an argument, e.g. `CCCryptorCreate(…)`, `CCCryptorUpdate(…)`, etc.
 */
private module AlgorithmUseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    n.asExpr().(DeclRefExpr).getDecl() instanceof AlgorithmConstantDecl
  }

  predicate isSink(DataFlow::Node n) {
    exists(Argument arg | n.asExpr() = arg.getExpr() |
      arg.getApplyExpr().getStaticTarget().getName().matches("CC%")
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    // Flow through cast expressions like `CCAlgorithm(kCCAlgorithmAES128)`.
    // TODO: turn this into a generally available flow step.
    exists(NumericalCastExpr call |
      n1.asExpr() = call.getArgument(0).getExpr() and
      n2.asExpr() = call
    )
  }
}

private module AlgorithmUse = DataFlow::Global<AlgorithmUseConfig>;

/**
 * A call expression that uses a `CCAlgorithm` constant through an argument, e.g. `CCryptorCreate(…)`.
 */
private class AlgorithmUser extends CallExpr {
  AlgorithmConstantDecl alg;

  AlgorithmUser() {
    exists(DataFlow::Node src, DataFlow::Node snk | AlgorithmUse::flow(src, snk) |
      src.asExpr().(DeclRefExpr).getDecl() = alg and
      snk.asExpr() = this.getAnArgument().getExpr()
    )
  }

  CryptographicAlgorithm getAlgorithm() { result = alg.asAlgorithm() }
}

/**
 * A call to an auto-generated numerical cast initializer, e.g. `CCAlgorithm(kCCAlgorithmAES128)`.
 */
private class NumericalCastExpr extends CallExpr {
  NumericalCastExpr() { this.getStaticTarget() instanceof NumericalCastInitializer }
}

/**
 * The declaration of an auto-generated numerical cast initializer.
 */
private class NumericalCastInitializer extends Initializer {
  NumericalCastInitializer() {
    this.getInterfaceType().getCanonicalType() instanceof NumericalCastType
  }
}

/**
 * The type of an auto-generated numerical cast initializer, which is a generic
 * function type of the form `<Self, T where ...> (Self.Type) -> (T) -> Self`.
 */
private class NumericalCastType extends Type {
  NumericalCastType() {
    exists(
      GenericFunctionType fntySelf, FunctionType fntyT, GenericTypeParamType genericSelf,
      GenericTypeParamType genericT, MetatypeType metaSelf
    |
      this = fntySelf and
      fntySelf = fntySelf.getCanonicalType() and
      fntySelf.getNumberOfGenericParams() = 2 and
      fntySelf.getGenericParam(0) = genericSelf and
      fntySelf.getGenericParam(1) = genericT and
      fntySelf.getNumberOfParamTypes() = 1 and
      fntySelf.getParamType(0) = metaSelf and
      fntySelf.getResult() = fntyT and
      fntyT.getNumberOfParamTypes() = 1 and
      fntyT.getParamType(0) = genericT and
      fntyT.getResult() = genericSelf
    )
  }
}

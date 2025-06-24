/**
 * In OpenSSL, flow between 'context' parameters is often used to
 * store state/config of how an operation will eventually be performed.
 * Tracing algorithms and configurations to operations therefore
 * requires tracing context parameters for many OpenSSL apis.
 *
 * This library provides a dataflow analysis to track context parameters
 * between any two functions accepting openssl context parameters.
 * The dataflow takes into consideration flowing through duplication and copy calls
 * as well as flow through flow killers (free/reset calls).
 *
 * TODO: we may need to revisit 'free' as a dataflow killer, depending on how
 * we want to model use after frees.
 *
 * This library also provides classes to represent context Types and relevant
 * arguments/expressions.
 */

import semmle.code.cpp.dataflow.new.DataFlow

/**
 * An openSSL CTX type, which is type for which the stripped underlying type
 * matches the pattern 'evp_%ctx_%st'.
 * This includes types like:
 * - EVP_CIPHER_CTX
 * - EVP_MD_CTX
 * - EVP_PKEY_CTX
 */
class CtxType extends Type {
  CtxType() {
    // It is possible for users to use the underlying type of the CTX variables
    // these have a name matching 'evp_%ctx_%st
    this.getUnspecifiedType().stripType().getName().matches("evp_%ctx_%st")
    or
    // In principal the above check should be sufficient, but in case of build mode none issues
    // i.e., if a typedef cannot be resolved,
    // or issues with properly stubbing test cases, we also explicitly check for the wrapping type defs
    // i.e., patterns matching 'EVP_%_CTX'
    exists(Type base | base = this or base = this.(DerivedType).getBaseType() |
      base.getName().matches("EVP_%_CTX")
    )
  }
}

/**
 * A pointer to a CtxType
 */
class CtxPointerExpr extends Expr {
  CtxPointerExpr() {
    this.getType() instanceof CtxType and
    this.getType() instanceof PointerType
  }
}

/**
 * A call argument of type CtxPointerExpr.
 */
class CtxPointerArgument extends CtxPointerExpr {
  CtxPointerArgument() { exists(Call c | c.getAnArgument() = this) }

  Call getCall() { result.getAnArgument() = this }
}

/**
 * A call returning a CtxPointerExpr.
 */
private class CtxPointerReturn extends CtxPointerExpr instanceof Call {
  Call getCall() { result = this }
}

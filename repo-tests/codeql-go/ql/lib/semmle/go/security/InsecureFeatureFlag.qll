/**
 * Provides utility predicates to spot variable and parameter names that suggest deliberately insecure settings.
 */

import go

/**
 * Provides classes and predicates relating to flags that may indicate security expectations.
 */
module InsecureFeatureFlag {
  /**
   * A kind of flag that may indicate security expectations regarding the code it guards.
   */
  abstract class FlagKind extends string {
    bindingset[this]
    FlagKind() { any() }

    /**
     * Returns a flag name of this type.
     */
    bindingset[result]
    abstract string getAFlagName();

    /** Gets a global value number representing a (likely) security flag. */
    GVN getAFlag() {
      // a call like `cfg.disableVerification()`
      exists(DataFlow::CallNode c | c.getTarget().getName() = getAFlagName() |
        result = globalValueNumber(c)
      )
      or
      // a variable or field like `insecure`
      exists(ValueEntity flag | flag.getName() = getAFlagName() |
        result = globalValueNumber(flag.getARead())
      )
      or
      // a string constant such as `"insecure"` or `"skipVerification"`
      exists(DataFlow::Node const | const.getStringValue() = getAFlagName() |
        result = globalValueNumber(const)
      )
      or
      // track feature flags through various operations
      exists(DataFlow::Node flag | flag = getAFlag().getANode() |
        // tuple destructurings
        result = globalValueNumber(DataFlow::extractTupleElement(flag, _))
        or
        // type casts
        exists(DataFlow::TypeCastNode tc |
          tc.getOperand() = flag and
          result = globalValueNumber(tc)
        )
        or
        // pointer dereferences
        exists(DataFlow::PointerDereferenceNode deref |
          deref.getOperand() = flag and
          result = globalValueNumber(deref)
        )
        or
        // calls like `os.Getenv("DISABLE_TLS_VERIFICATION")`
        exists(DataFlow::CallNode call |
          call.getAnArgument() = flag and
          result = globalValueNumber(call)
        )
        or
        // comparisons like `insecure == true`
        exists(DataFlow::EqualityTestNode eq |
          eq.getAnOperand() = flag and
          result = globalValueNumber(eq)
        )
      )
    }
  }

  /**
   * Flags suggesting an optional feature, perhaps deliberately insecure.
   */
  class SecurityFeatureFlag extends FlagKind {
    SecurityFeatureFlag() { this = "securityFeature" }

    bindingset[result]
    override string getAFlagName() { result.regexpMatch("(?i).*(secure|(en|dis)able).*") }
  }

  /**
   * Holds for string literals or named values matching `flagKind` and their fields.
   */
  predicate exprIsFlag(Expr node, FlagKind flagKind) {
    node.getStringValue() = flagKind.getAFlagName() or
    node.(Name).getTarget().getName() = flagKind.getAFlagName() or
    exprIsFlag(node.(SelectorExpr).getBase(), flagKind) or
    exprIsFlag(node.(SelectorExpr).getSelector(), flagKind)
  }

  /**
   * Holds if `node` involves a string of kind `flagKind`.
   */
  predicate astNodeIsFlag(AstNode node, FlagKind flagKind) {
    // Map literal flag: value or "flag": value
    exprIsFlag(node.(KeyValueExpr).getKey(), flagKind)
    or
    // Variable initialisation flag := value
    exists(ValueSpec valueSpec, int childIdx |
      valueSpec.getName(childIdx) = flagKind.getAFlagName()
    |
      node = valueSpec.getInit(childIdx)
    )
    or
    // Assignment flag = value
    exists(Assignment assignment, int childIdx | exprIsFlag(assignment.getLhs(childIdx), flagKind) |
      node = assignment.getRhs(childIdx)
    )
    or
    // Case clause 'case flag:' or 'case "flag":'
    exprIsFlag(node.(CaseClause).getAnExpr(), flagKind)
  }

  /**
   * Gets a control-flow node that represents a (likely) security feature-flag check
   */
  ControlFlow::ConditionGuardNode getASecurityFeatureFlagCheck() {
    result.ensures(any(SecurityFeatureFlag f).getAFlag().getANode(), _)
  }
}

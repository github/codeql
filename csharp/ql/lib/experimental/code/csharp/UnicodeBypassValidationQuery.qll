/**
 * Provides a taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 */

private import csharp
import semmle.code.csharp.dataflow.internal.tainttracking1.TaintTracking
import semmle.code.csharp.security.dataflow.flowsources.Remote
import UnicodeBypassValidationCustomizations::UnicodeBypassValidation

/** A state signifying that a logical validation has not been performed. */
class PreValidation extends DataFlow::FlowState {
  PreValidation() { this = "PreValidation" }
}

/** A state signifying that a logical validation has been performed. */
class PostValidation extends DataFlow::FlowState {
  PostValidation() { this = "PostValidation" }
}

/**
 * A taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 *
 * This configuration uses two flow states, `PreValidation` and `PostValidation`,
 * to track the requirement that a logical validation has been performed before the Unicode Transformation.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnicodeBypassValidation" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof RemoteFlowSource and state instanceof PreValidation
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    (
      exists(MethodCall mc |
        mc.getTarget().hasName("Escape") and
        mc.getTarget()
            .getDeclaringType()
            .getABaseType*()
            .hasQualifiedName("System.Security", "SecurityElement") and
        nodeFrom.asExpr() = mc.getArgument(0) and
        nodeTo.asExpr() = mc
      )
      or
      exists(MethodCall mc |
        mc.getTarget()
            .hasName([
                "Count", "Equals", "IsMatch", "Match", "UseOptionC", "UseOptionR",
                "ValidateMatchTimeout"
              ]) and
        mc.getTarget()
            .getDeclaringType()
            .getABaseType*()
            .hasQualifiedName("System.Text.RegularExpressions", "Regex") and
        nodeFrom.asExpr() = mc.getArgument(0) and
        nodeTo = nodeFrom
      )
      or
      exists(MethodCall mc |
        mc.getTarget()
            .hasName(["Matches", "Replace", "Split", "Unescape", "Escape", "EnumerateMatches",]) and
        mc.getTarget()
            .getDeclaringType()
            .getABaseType*()
            .hasQualifiedName("System.Text.RegularExpressions", "Regex") and
        nodeFrom.asExpr() = mc.getArgument(0) and
        nodeTo.asExpr() = mc
      )
      or
      exists(MethodCall mc |
        mc.getTarget()
            .hasName([
                "Clone", "Compare", "CompareOrdinal", "CompareTo", "Concat", "Contains", "Copy",
                "CopyTo", "Create", "EndsWith", "EnumerateRunes", "Equals", "Format",
                "GetEnumerator", "GetHashCode", "GetPinnableReference", "GetTypeCode", "IndexOf",
                "IndexOfAny", "Insert", "Intern", "IsInterned", "IsNormalized", "IsNullOrEmpty",
                "IsNullOrWhiteSpace", "Join", "LastIndexOf", "LastIndexOfAny", "Normalize",
                "PadLeft", "PadRight", "Remove", "Replace", "ReplaceLineEndings", "Split",
                "StartsWith", "Substring", "ToCharArray", "ToLower", "ToLowerInvariant", "ToString",
                "ToUpper", "ToUpperInvariant", "Trim", "TrimEnd", "TrimStart", "TryCopyTo"
              ]) and
        mc.getTarget().getDeclaringType().getABaseType*().hasQualifiedName("System", "String") and
        nodeFrom.asExpr() = mc.getQualifier() and
        nodeTo = nodeFrom
      )
    ) and
    stateFrom instanceof PreValidation and
    stateTo instanceof PostValidation
  }

  /* A Unicode Tranformation (Unicode tranformation) is considered a sink when the algorithm used is either NFC or NFKC.  */
  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(MethodCall mc, MemberConstant tm, MemberConstantAccess mca |
      mca = mc.getArgument(0) and
      mc.getTarget().hasName("Normalize") and
      tm = mca.getTarget() and
      tm.toString() = ["FormKC", "FormC"] and
      tm.getType().toString() = "NormalizationForm" and
      sink.asExpr() = mc.getQualifier()
    ) and
    state instanceof PostValidation
  }
}

/**
 * Provides a taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 */

private import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.controlflow.Guards
import UnicodeBypassValidationCustomizations::UnicodeBypassValidation
import RegexAndStrManipulation

/** Use of the four Unicode normalization forms */
private class ComposingUnicodeForm extends Field {
  ComposingUnicodeForm() {
    this.hasQualifiedName("java.text", "Normalizer$Form", ["NFKC", "NFC", "NFKD", "NFD"])
  }
}

/** A state signifying that a logical validation has not been performed. */
class PreValidation extends DataFlow::FlowState {
  PreValidation() { this = "PreValidation" }
}

/** A state signifying that a logical validation has been performed. */
class PostValidation extends DataFlow::FlowState {
  PostValidation() { this = "PostValidation" }
}

private predicate regexMatcherCheck(Guard g, Expr e, boolean outcome) {
  exists(MethodAccess ma, MethodAccess fma |
    ma.getMethod() instanceof PatternMatcherMethod and
    ma.getArgument(0) = e and
    DataFlow::localExprFlow(ma, fma.getQualifier()) and
    fma.getMethod().getName() = "find" and
    g = fma and
    outcome = false
  )
}

/**
 * A use of a variable guarded by a call to Regex Matcher find function
 * in a context suggesting it has been validated to not matches a particular string.
 */
class UntrustedUnicodeRegexCheck extends DataFlow::Node {
  UntrustedUnicodeRegexCheck() {
    this = DataFlow::BarrierGuard<regexMatcherCheck/3>::getABarrierNode()
  }
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
      // Match `org.springframework.web.util.HtmlUtils.htmlEscape` and possibly other methods like it.
      exists(MethodAccess ma |
        ma.getMethod().getName().regexpMatch("(?i)html_?escape.*") and
        nodeTo.asExpr() = ma and
        nodeFrom.asExpr() = ma.getArgument(0)
      )
      or
      exists(MethodAccess ma |
        (
          // p = Pattern.compile(regexPattern); p.matcher(input)
          ma.getMethod() instanceof PatternCompileMethod and
          exists(MethodAccess pma |
            pma.getMethod() instanceof PatternMatcherMethod and
            nodeFrom.asExpr() = pma.getArgument(0) and
            DataFlow::localExprFlow(ma, pma.getQualifier())
          )
          or
          // p = Pattern.matches(regexPattern, input)
          ma.getMethod() instanceof PatternMatchMethod and nodeFrom.asExpr() = ma.getArgument(1)
        ) and
        nodeTo.asExpr() = ma
      )
      or
      // input.matches(regexPattern)
      exists(MethodAccess ma |
        ma.getMethod() instanceof StringMethod and
        nodeFrom.asExpr() = ma.getQualifier() and
        nodeTo = nodeFrom
      )
    ) and
    stateFrom instanceof PreValidation and
    stateTo instanceof PostValidation
  }

  /*
   * A Unicode Normalization (Unicode tranformation) is considered a sink.
   * The Unicode normalisation may be guarded by a check that the input does not matches a particular string by Regex matcher.
   */

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("java.text", "Normalizer", "normalize") and
      ma.getArgument(1).(FieldAccess).getField() instanceof ComposingUnicodeForm and
      sink.asExpr() = ma.getArgument(0)
    ) and
    state instanceof PostValidation
    or
    sink instanceof UntrustedUnicodeRegexCheck and state instanceof PreValidation
  }
}

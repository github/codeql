/**
 * Provides a taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 */

private import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import UnicodeBypassValidationCustomizations::UnicodeBypassValidation
import RegexAndStrManipulation

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

  /* A Unicode Tranformation (Unicode tranformation) is considered a sink when the algorithm used is either NFC or NFKC.  */
  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(MethodAccess ma, Method m, VarAccess v |
      m = ma.getMethod() and
      m.getQualifiedName() = "java.text.Normalizer.normalize" and
      v = ma.getArgument(1) and
      v.toString() = "Normalizer.Form." + ["NFKC", "NFC"] and
      sink.asExpr() = ma.getArgument(0)
    ) and
    state instanceof PostValidation
  }
}

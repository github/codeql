/**
 * @name Checkout of untrusted code in a privileged context
 * @description Privileged workflows have read/write access to the base repository and access to secrets.
 *              By explicitly checking out and running the build script from a fork the untrusted code is running in an environment
 *              that is able to push to the base repository and to access secrets.
 * @kind path-problem
 * @problem.severity error
 * @precision very-high
 * @security-severity 9.3
 * @id actions/untrusted-checkout/critical
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions
private import codeql.util.FilePath
import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.PoisonableSteps
import codeql.actions.security.ControlChecks

query predicate edges(AstNode predecessor, AstNode successor) {
  predecessor.(Step).getNextStep() = successor
  or
  checkoutReferenceEdge(predecessor, successor)
}

private class ActionsCheckoutPathInput extends NormalizableFilepath {
  ActionsCheckoutPathInput() {
    exists(PRHeadCheckoutStep checkout |
      checkout instanceof UsesStep and
      checkout.(UsesStep).getCallee() = "actions/checkout" and
      this = trimQuotes(checkout.(UsesStep).getArgument("path"))
    )
  }
}

/** Gets the modeled script operand before shared path normalization can discard dot segments. */
private string getUnnormalizedLocalScriptPath(LocalScriptExecutionRunStep step) {
  exists(string regexp, int pathGroup |
    poisonableLocalScriptsDataModel(regexp, pathGroup) and
    result = step.getScript().getACommand().regexpCapture(regexp, pathGroup).splitAt(" ")
  )
}

private class ExecutionPathInput extends NormalizableFilepath {
  ExecutionPathInput() {
    exists(LocalScriptExecutionRunStep |
      this = trimQuotes(getUnnormalizedLocalScriptPath(_))
    )
    or
    exists(LocalActionUsesStep step | this = step.getCallee())
  }
}

private string getNormalizedActionsCheckoutPath(PRHeadCheckoutStep checkout) {
  exists(ActionsCheckoutPathInput checkoutPath, string normalized |
    checkout instanceof UsesStep and
    checkout.(UsesStep).getCallee() = "actions/checkout" and
    checkoutPath = trimQuotes(checkout.(UsesStep).getArgument("path")) and
    not checkoutPath.regexpMatch(".*\\$\\{\\{.*") and
    normalized = checkoutPath.getNormalizedPath() and
    not normalized.matches("/%") and
    normalized != ".." and
    not normalized.matches("../%") and
    if normalized = "."
    then result = "GITHUB_WORKSPACE"
    else result = "GITHUB_WORKSPACE/" + normalized
  )
}

bindingset[path]
private string getNormalizedExecutionPath(string path) {
  exists(ExecutionPathInput executionPath, string normalized |
    executionPath = trimQuotes(path) and
    not executionPath.regexpMatch(".*\\$\\{\\{.*") and
    normalized = executionPath.getNormalizedPath() and
    not normalized.matches("/%") and
    normalized != ".." and
    not normalized.matches("../%") and
    if normalized = "."
    then result = "GITHUB_WORKSPACE"
    else (
      normalized.regexpMatch("^[^$/~].*") and
      result = "GITHUB_WORKSPACE/" + normalized
    )
  )
}

bindingset[checkout, rawPath, path]
private predicate checkoutContainsPath(PRHeadCheckoutStep checkout, string rawPath, string path) {
  exists(string root, string candidate |
    root = getNormalizedActionsCheckoutPath(checkout) and
    candidate = getNormalizedExecutionPath(rawPath) and
    // Canonicalize both paths so dot segments cannot enter or escape the checkout while still
    // passing a lexical prefix check.
    (candidate = root or candidate.indexOf(root + "/") = 0)
  )
  or
  not exists(getNormalizedActionsCheckoutPath(checkout)) and
  isSubpath(path, checkout.getPath())
}

private predicate checkoutUsesWorkspaceRoot(PRHeadCheckoutStep checkout) {
  getNormalizedActionsCheckoutPath(checkout) = "GITHUB_WORKSPACE"
  or
  not exists(getNormalizedActionsCheckoutPath(checkout)) and
  checkout.getPath() = "GITHUB_WORKSPACE/"
}

from
  PRHeadCheckoutStep checkout, PoisonableStep poisonable, Event event, AstNode checkoutReference,
  string checkoutReferenceText
where
  checkoutReference = getCheckoutReference(checkout) and
  checkoutReferenceText = getCheckoutReferenceText(checkoutReference) and
  // the checkout is followed by a known poisonable step
  checkout.getAFollowingStep() = poisonable and
  (
    // Check if the poisonable step is a local script execution step
    // and the path of the command or script matches the path of the downloaded artifact
    (
      poisonable instanceof LocalScriptExecutionRunStep and
      checkoutContainsPath(checkout,
        getUnnormalizedLocalScriptPath(poisonable), poisonable.getPath())
    )
    or
    // Checking the path for non local script execution steps is very difficult
    (
      poisonable instanceof Run and
      not poisonable instanceof LocalScriptExecutionRunStep
    )
    // Its not easy to extract the path from a non-local script execution step so skipping this check for now
    // and isSubpath(poisonable.(Run).getWorkingDirectory(), checkout.getPath())
    or
    poisonable instanceof UsesStep and
    (
      not poisonable instanceof LocalActionUsesStep and
      checkoutUsesWorkspaceRoot(checkout)
      or
      checkoutContainsPath(checkout, poisonable.(LocalActionUsesStep).getCallee(),
        poisonable.(LocalActionUsesStep).getPath())
    )
  ) and
  // the checkout occurs in a privileged context
  inPrivilegedContext(poisonable, event) and
  inPrivilegedContext(checkout, event) and
  event.getName() = checkoutTriggers() and
  not exists(ControlCheck check | check.protects(checkout, event, "untrusted-checkout")) and
  not exists(ControlCheck check | check.protects(poisonable, event, "untrusted-checkout"))
select checkout, checkoutReference, poisonable,
  "Checkout of untrusted code from $@ in a privileged workflow with later potential execution (event trigger: $@).",
  checkoutReference, checkoutReferenceText, event, event.getName()

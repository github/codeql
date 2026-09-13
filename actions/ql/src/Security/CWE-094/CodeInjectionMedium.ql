/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision medium
 * @id actions/code-injection/medium
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-116
 */

import actions
import codeql.actions.security.CodeInjectionQuery
import CodeInjectionFlow::PathGraph

/**
 * A data flow source of user input from github context.
 * eg: github.head_ref
 * Usually only considered for pull_request_target where access to secrets
 * and tokens is more available.
 * However this query already finds all context events as sources regardless
 * so this should be similar.
 */
class GitHubCtxSourceMediumLikely extends RemoteFlowSource {
  string flag;
  string event;

  GitHubCtxSourceMediumLikely() {
    exists(GitHubExpression e |
      this.asExpr() = e and
      // github.head_ref
      e.getFieldName() = "head_ref" and
      flag = "branch"
    |
      event = e.getATriggerEvent().getName() and
      event = "pull_request"
      or
      not exists(e.getATriggerEvent()) and
      event = "unknown"
    )
  }

  override string getSourceType() { result = flag }

  override string getEventName() { result = event }
}

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink
where mediumSeverityCodeInjection(source, sink)
select sink.getNode(), source, sink,
  "Potential code injection in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()

/**
 * Provides classes representing various flow steps for taint tracking.
 */

private import actions
private import codeql.util.Unit
private import codeql.actions.DataFlow
private import codeql.actions.dataflow.FlowSources

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to all
 * taint configurations.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for all configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/**
 * A file source step followed by a Run step may read the file.
 */
predicate fileDownloadToRunStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(FileSource source, Run run |
    pred = source and
    source.asExpr().(Step).getAFollowingStep() = run and
    succ.asExpr() = run.getScript() and
    exists(run.getScript().getAFileReadCommand())
  )
}

/**
 * A read of the _files field of the dorny/paths-filter action.
 */
predicate dornyPathsFilterTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof DornyPathsFilterSource and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    o.getFieldName().matches("%_files") and
    succ.asExpr() = o
  )
}

/**
 * A read of user-controlled field of the tj-actions/changed-files action.
 */
predicate tjActionsChangedFilesTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof TJActionsChangedFilesSource and
    o.getTarget() = pred.asExpr() and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    o.getFieldName() =
      [
        "added_files", "copied_files", "deleted_files", "modified_files", "renamed_files",
        "all_old_new_renamed_files", "type_changed_files", "unmerged_files", "unknown_files",
        "all_changed_and_modified_files", "all_changed_files", "other_changed_files",
        "all_modified_files", "other_modified_files", "other_deleted_files", "modified_keys",
        "changed_keys"
      ] and
    succ.asExpr() = o
  )
}

/**
 * A read of user-controlled field of the tj-actions/verify-changed-files action.
 */
predicate tjActionsVerifyChangedFilesTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof TJActionsVerifyChangedFilesSource and
    o.getTarget() = pred.asExpr() and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    o.getFieldName() = "changed_files" and
    succ.asExpr() = o
  )
}

/**
 * A read of user-controlled field of the xt0rted/slash-command-action action.
 */
predicate xt0rtedSlashCommandActionTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof Xt0rtedSlashCommandSource and
    o.getTarget() = pred.asExpr() and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    o.getFieldName() = "command-arguments" and
    succ.asExpr() = o
  )
}

/**
 * A read of user-controlled field of the zentered/issue-forms-body-parser action.
 */
predicate zenteredIssueFormBodyParserSource(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof ZenteredIssueFormBodyParserSource and
    o.getTarget() = pred.asExpr() and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    (
      not o instanceof JsonReferenceExpression and
      o.getFieldName() = "data"
      or
      o instanceof JsonReferenceExpression and
      o.(JsonReferenceExpression).getInnerExpression().matches("%.data")
    ) and
    succ.asExpr() = o
  )
}

/**
 * A read of user-controlled field of the octokit/request-action action.
 */
predicate octokitRequestActionTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof OctokitRequestActionSource and
    o.getTarget() = pred.asExpr() and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    succ.asExpr() = o and
    (
      not o instanceof JsonReferenceExpression and
      o.getFieldName() = "data"
      or
      o instanceof JsonReferenceExpression and
      o.(JsonReferenceExpression).getInnerExpression().matches("%.data") and
      o.(JsonReferenceExpression)
          .getAccessPath()
          .matches([
              "%.title",
              "%.user.login",
              "%.body",
              "%.head.ref",
              "%.head.repo.full_name",
              "%.commit.author.email",
              "%.commit.commiter.email",
              "%.commit.message",
              "%.email",
              "%.name",
            ])
    )
  )
}

class TaintSteps extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    dornyPathsFilterTaintStep(node1, node2) or
    tjActionsChangedFilesTaintStep(node1, node2) or
    tjActionsVerifyChangedFilesTaintStep(node1, node2) or
    xt0rtedSlashCommandActionTaintStep(node1, node2) or
    xt0rtedSlashCommandActionTaintStep(node1, node2) or
    zenteredIssueFormBodyParserSource(node1, node2) or
    octokitRequestActionTaintStep(node1, node2)
  }
}

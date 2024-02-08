private import codeql.actions.ast.internal.Actions
private import codeql.Locations

/**
 * Base class for the AST tree.
 * Based on YamlNode from the Yaml library but making mapping values children of the mapping keys:
 * eg: top:
 *        key: value
 * According to the Yaml library, both `key` and `value` are direct children of `top`
 * This Tree implementation makes `key` child od `top` and `value` child of `key`
 */
class AstNode instanceof YamlNode {
  AstNode getParentNode() { result = super.getParentNode() }

  // AstNode getParentNode() {
  //   if exists(YamlMapping m | m.maps(_, this))
  //   then exists(YamlMapping m | m.maps(result, this))
  //   else result = super.getParentNode()
  // }
  AstNode getAChildNode() { result = super.getAChildNode() }

  // AstNode getAChildNode() {
  //   if this instanceof YamlMapping
  //   then this.(YamlMapping).maps(result, _)
  //   else
  //     if this instanceof YamlCollection
  //     then result = super.getChildNode(_)
  //     else
  //       if this instanceof YamlScalar and exists(YamlMapping m | m.maps(this, _))
  //       then exists(YamlMapping m | m.maps(this, result))
  //       else none()
  // }
  // /**
  //  * This should be getAChildNode(int i)
  //  */
  // AstNode getChildNodeByOrder(int i) {
  //   result =
  //     rank[i](Expression child, Location l |
  //       child = this.getAChildNode() and
  //       child.getLocation() = l
  //     |
  //       child
  //       order by
  //         l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
  //     )
  // }
  string toString() { result = super.toString() }

  string getAPrimaryQlClass() { result = super.getAPrimaryQlClass() }

  Location getLocation() { result = super.getLocation() }
}

/**
 * A statement is a group of expressions and/or statements that you design to carry out a task or an action.
 * Any statement that can return a value is automatically qualified to be used as an expression.
 */
class Statement extends AstNode { }

/**
 * An expression is any word or group of words or symbols that is a value. In programming, an expression is a value, or anything that executes and ends up being a value.
 */
class Expression extends Statement { }

/**
 * A Github Actions Workflow
 */
class WorkflowStmt extends Statement instanceof Actions::Workflow {
  JobStmt getAJob() { result = super.getJob(_) }

  JobStmt getJob(string id) { result = super.getJob(id) }
}

/**
 * A Job is a collection of steps that run in an execution environment.
 */
class JobStmt extends Statement instanceof Actions::Job {
  /**
   * Gets the ID of this job, as a string.
   * This is the job's key within the `jobs` mapping.
   */
  string getId() { result = super.getId() }

  /** Gets the step at the given index within this job. */
  StepStmt getStep(int index) { result = super.getStep(index) }

  /** Gets any steps that are defined within this job. */
  StepStmt getAStep() { result = super.getStep(_) }

  /**
   * Gets a needed job.
   * eg:
   *     - needs: [job1, job2]
   */
  JobStmt getNeededJob() {
    exists(Actions::Needs needs |
      needs.getJob() = this and
      result = needs.getANeededJob().(JobStmt)
    )
  }

  /**
   * Gets the declaration of the outputs for the job.
   * eg:
   *   out1: ${steps.foo.bar}
   *   out2: ${steps.foo.baz}
   */
  JobOutputStmt getOutputStmt() { result = this.(Actions::Job).lookup("outputs") }
}

/**
 * Declaration of the outputs for the job.
 * eg:
 *   out1: ${steps.foo.bar}
 *   out2: ${steps.foo.baz}
 */
class JobOutputStmt extends Statement instanceof YamlMapping {
  JobStmt job;

  JobOutputStmt() { job.(YamlMapping).lookup("outputs") = this }

  YamlMapping asYamlMapping() { result = this }

  /**
   * Gets a specific value expression
   * eg: ${steps.foo.bar}
   */
  Expression getOutputExpr(string id) {
    this.(YamlMapping).maps(any(YamlScalar s | s.getValue() = id), result)
  }
}

/**
 * A Step is a single task that can be executed as part of a job.
 */
class StepStmt extends Statement instanceof Actions::Step {
  string getId() { result = super.getId() }

  JobStmt getJob() { result = super.getJob() }
}

/**
 * A Uses step represents a call to an action that is defined in a GitHub repository.
 */
class UsesExpr extends StepStmt, Expression {
  Actions::Uses uses;

  UsesExpr() { uses.getStep() = this }

  string getTarget() { result = uses.getGitHubRepository() }

  string getVersion() { result = uses.getVersion() }

  Expression getArgument(string key) {
    exists(Actions::With with |
      with.getStep() = this and
      result = with.lookup(key)
    )
  }
}

/**
 * A Run step represents the evaluation of a provided script
 */
class RunExpr extends StepStmt, Expression {
  Actions::Run scriptExpr;

  RunExpr() { scriptExpr.getStep() = this }

  Expression getScriptExpr() { result = scriptExpr }

  Expression getEnvExpr(string name) {
    exists(Actions::StepEnv env |
      env.getStep() = this and
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
    )
  }

  string getScript() { result = scriptExpr.getValue() }
}

/**
 * Evaluation of a workflow expression ${{}}.
 */
class ExprAccessExpr extends Expression instanceof YamlString {
  string expr;

  ExprAccessExpr() { expr = Actions::getASimpleReferenceExpression(this) }

  string getExpression() { result = expr }

  JobStmt getJob() { result.getAChildNode*() = this }
  //override string toString() { result = expr }
}

/**
 * A ExprAccessExpr where the expression evaluated is a step output read.
 * eg: `${{ steps.changed-files.outputs.all_changed_files }}`
 */
class StepOutputAccessExpr extends ExprAccessExpr {
  string stepId;
  string varName;

  StepOutputAccessExpr() {
    stepId =
      this.getExpression().regexpCapture("steps\\.([A-Za-z0-9_-]+)\\.outputs\\.[A-Za-z0-9_-]+", 1) and
    varName =
      this.getExpression().regexpCapture("steps\\.[A-Za-z0-9_-]+\\.outputs\\.([A-Za-z0-9_-]+)", 1)
  }

  string getStepId() { result = stepId }

  string getVarName() { result = varName }

  StepStmt getStep() { result.getId() = stepId }
}

/**
 * A ExprAccessExpr where the expression evaluated is a job output read.
 * eg: `${{ needs.job1.outputs.foo}}`
 */
class JobOutputAccessExpr extends ExprAccessExpr {
  string jobId;
  string varName;

  JobOutputAccessExpr() {
    jobId =
      this.getExpression().regexpCapture("needs\\.([A-Za-z0-9_-]+)\\.outputs\\.[A-Za-z0-9_-]+", 1) and
    varName =
      this.getExpression().regexpCapture("needs\\.[A-Za-z0-9_-]+\\.outputs\\.([A-Za-z0-9_-]+)", 1)
  }

  string getVarName() { result = varName }

  Expression getOutputExpr() {
    exists(JobStmt job |
      job.getId() = jobId and
      job.getLocation().getFile() = this.getLocation().getFile() and
      job.getOutputStmt().getOutputExpr(varName) = result
    )
  }
}

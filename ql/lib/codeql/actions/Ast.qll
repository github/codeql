private import codeql.actions.ast.internal.Actions
private import codeql.Locations

class AstNode instanceof YamlNode {
  AstNode getParentNode() {
    if exists(YamlMapping m | m.maps(_, this))
    then exists(YamlMapping m | m.maps(result, this))
    else result = super.getParentNode()
  }

  AstNode getAChildNode() {
    if this instanceof YamlMapping
    then this.(YamlMapping).maps(result, _)
    else
      if this instanceof YamlCollection
      then result = super.getChildNode(_)
      else
        if this instanceof YamlScalar and exists(YamlMapping m | m.maps(this, _))
        then exists(YamlMapping m | m.maps(this, result))
        else none()
  }

  AstNode getChildNodeByOrder(int i) {
    result =
      rank[i](Expression child, Location l |
        child = this.getAChildNode() and
        child.getLocation() = l
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }

  string toString() { result = super.toString() }

  string getAPrimaryQlClass() { result = super.getAPrimaryQlClass() }

  Location getLocation() { result = super.getLocation() }
}

class Statement extends AstNode {
  // narrow down to something that is a statement
  // A statement is a group of expressions and/or statements that you design to carry out a task or an action.
  // Any statement that can return a value is automatically qualified to be used as an expression.
}

class Expression extends Statement {
  // narrow down to something that is an expression
  // An expression is any word or group of words or symbols that is a value. In programming, an expression is a value, or anything that executes and ends up being a value.
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

  /** Gets the human-readable name of this job, if any, as a string. */
  string getName() {
    result = super.getId()
    or
    not exists(string s | s = super.getId()) and result = "unknown"
  }

  /** Gets the step at the given index within this job. */
  StepStmt getStep(int index) { result = super.getStep(index) }

  /** Gets any steps that are defined within this job. */
  StepStmt getAStep() { result = super.getStep(_) }

  JobStmt getNeededJob() {
    exists(Actions::Needs needs |
      needs.getJob() = this and
      result = needs.getANeededJob().(JobStmt)
    )
  }

  Expression getJobOutputExpr(string varName) {
    this.(Actions::Job)
        .lookup("outputs")
        .(YamlMapping)
        .maps(any(YamlScalar a | a.getValue() = varName), result)
  }

  JobOutputStmt getJobOutputStmt() { result = this.(Actions::Job).lookup("outputs") }

  Statement getSuccNode(int i) {
    result =
      rank[i](Expression child, Location l |
        (child = this.getAStep() or child = this.getJobOutputStmt()) and
        l = child.getLocation()
      |
        child
        order by
          l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
      )
  }
}

class JobOutputStmt extends Statement instanceof YamlMapping {
  JobStmt job;

  JobOutputStmt() { job.(YamlMapping).lookup("outputs") = this }

  StepOutputAccessExpr getSuccNode(int i) { result = this.(YamlMapping).getValueNode(i) }
}

/**
 * A Step is a single task that can be executed as part of a job.
 */
class StepStmt extends Statement instanceof Actions::Step {
  string getId() { result = super.getId() }

  string getName() {
    result = super.getId()
    or
    not exists(string s | s = super.getId()) and result = "unknown"
  }

  JobStmt getJob() { result = super.getJob() }

  abstract AstNode getSuccNode(int i);
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

  Expression getArgumentByOrder(int i) {
    exists(Actions::With with |
      with.getStep() = uses.getStep() and
      result =
        rank[i](Expression child, Location l |
          child = with.lookup(_) and l = child.getLocation()
        |
          child
          order by
            l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
        )
    )
  }

  Expression getAnArgument() {
    exists(Actions::With with |
      with.getStep() = this and
      result = with.lookup(_)
    )
  }

  override AstNode getSuccNode(int i) { result = this.getArgumentByOrder(i) }
}

/**
 * An argument passed to a UsesExpr.
 */
class ArgumentExpr extends Expression {
  UsesExpr uses;

  ArgumentExpr() { this = uses.getAnArgument() }
}

/**
 * A Run step represents a call to an inline script or executable on the runner machine.
 */
class RunExpr extends StepStmt {
  Actions::Run scriptExpr;

  RunExpr() { scriptExpr.getStep() = this }

  Expression getScriptExpr() { result = scriptExpr }

  string getScript() { result = scriptExpr.getValue() }

  override AstNode getSuccNode(int i) { result = this.getScriptExpr() and i = 0 }
}

/**
 * A YAML string containing a workflow expression.
 */
class ExprAccessExpr extends Expression instanceof YamlString {
  string expr;

  ExprAccessExpr() { expr = Actions::getASimpleReferenceExpression(this) }

  string getExpression() { result = expr }

  JobStmt getJob() { result.getAChildNode*() = this }
}

/**
 * A ExprAccessExpr where the expression references a step output.
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
 * A ExprAccessExpr where the expression references a job output.
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
      job.getJobOutputExpr(varName) = result
    )
  }
}

private import codeql.actions.ast.internal.Actions
private import codeql.Locations

/**
 * Base class for the AST tree. Based on YamlNode from the Yaml library.
 */
class AstNode instanceof YamlNode {
  AstNode getParentNode() { result = super.getParentNode() }

  AstNode getAChildNode() { result = super.getAChildNode() }

  string toString() { result = super.toString() }

  string getAPrimaryQlClass() { result = super.getAPrimaryQlClass() }

  Location getLocation() { result = super.getLocation() }
}

/**
 * A statement is a group of expressions and/or statements that you design to carry out a task or an action.
 * Any statement that can return a value is automatically qualified to be used as an expression.
 */
class Statement extends AstNode {
  /** Gets the workflow that this job is a part of. */
  WorkflowStmt getEnclosingWorkflowStmt() { this = result.getAChildNode*() }
}

/**
 * An expression is any word or group of words or symbols that is a value. In programming, an expression is a value, or anything that executes and ends up being a value.
 */
class Expression extends Statement { }

/**
 * A composite action
 */
class CompositeActionStmt extends Statement instanceof Actions::CompositeAction {
  RunsStmt getRunsStmt() { result = super.getRuns() }

  InputsStmt getInputsStmt() { result = this.(YamlMapping).lookup("inputs") }

  OutputsStmt getOutputsStmt() { result = this.(YamlMapping).lookup("outputs") }

  string getName() { result = this.getLocation().getFile().getRelativePath() }
}

class RunsStmt extends Statement instanceof Actions::Runs {
  StepStmt getAStepStmt() { result = super.getSteps().getElementNode(_) }

  StepStmt getStepStmt(int i) { result = super.getSteps().getElementNode(i) }
}

/**
 * A Github Actions Workflow
 */
class WorkflowStmt extends Statement instanceof Actions::Workflow {
  JobStmt getAJobStmt() { result = super.getJob(_) }

  JobStmt getJobStmt(string id) { result = super.getJob(id) }

  predicate hasTriggerEvent(string trigger) {
    exists(YamlNode n | n = super.getOn().(YamlMappingLikeNode).getNode(trigger))
  }

  string getATriggerEvent() {
    exists(YamlNode n | n = super.getOn().(YamlMappingLikeNode).getNode(result))
  }
}

class ReusableWorkflowStmt extends WorkflowStmt {
  YamlValue workflow_call;

  ReusableWorkflowStmt() {
    this.(Actions::Workflow).getOn().getNode("workflow_call") = workflow_call
  }

  InputsStmt getInputsStmt() { result = workflow_call.(YamlMapping).lookup("inputs") }

  OutputsStmt getOutputsStmt() { result = workflow_call.(YamlMapping).lookup("outputs") }

  string getName() { result = this.getLocation().getFile().getRelativePath() }
}

class InputsStmt extends Statement instanceof YamlMapping {
  YamlMapping parent;

  InputsStmt() { parent.lookup("inputs") = this }

  /**
   * Gets a specific input expression (YamlMapping) by name.
   */
  InputExpr getInputExpr(string name) {
    result.(YamlString).getValue() = name and
    this.(YamlMapping).maps(result, _)
  }
}

class OutputsStmt extends Statement instanceof YamlMapping {
  YamlMapping parent;

  OutputsStmt() { parent.lookup("outputs") = this }

  /**
   * Gets a specific output expression (YamlMapping) by name.
   */
  OutputExpr getOutputExpr(string name) {
    this.(YamlMapping).lookup(name).(YamlMapping).lookup("value") = result or
    this.(YamlMapping).lookup(name) = result
  }

  string getAnOutputName() { this.(YamlMapping).maps(any(YamlString s | s.getValue() = result), _) }
}

class InputExpr extends Expression instanceof YamlString {
  InputExpr() { exists(InputsStmt inputs | inputs.(YamlMapping).maps(this, _)) }
}

class OutputExpr extends Expression instanceof YamlString {
  OutputExpr() {
    exists(OutputsStmt outputs |
      outputs.(YamlMapping).lookup(_).(YamlMapping).lookup("value") = this or
      outputs.(YamlMapping).lookup(_) = this
    )
  }
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
  StepStmt getStepStmt(int index) { result = super.getStep(index) }

  /** Gets any steps that are defined within this job. */
  StepStmt getAStepStmt() { result = super.getStep(_) }

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
  OutputsStmt getOutputsStmt() { result = this.(Actions::Job).lookup("outputs") }

  /**
   * Reusable workflow jobs may have Uses children
   * eg:
   * call-job:
   *   uses: ./.github/workflows/reusable_workflow.yml
   *   with:
   *     arg1: value1
   */
  JobUsesExpr getUsesExpr() { result.getJobStmt() = this }

  predicate usesReusableWorkflow() {
    this.(YamlMapping).maps(any(YamlString s | s.getValue() = "uses"), _)
  }

  IfStmt getIfStmt() { result = super.getIf() }
}

/**
 * A Step is a single task that can be executed as part of a job.
 */
class StepStmt extends Statement instanceof Actions::Step {
  string getId() { result = super.getId() }

  JobStmt getJobStmt() { result = super.getJob() }

  IfStmt getIfStmt() { result = super.getIf() }
}

/**
 * An If node representing a conditional statement.
 */
class IfStmt extends Statement {
  YamlMapping parent;

  IfStmt() {
    (parent instanceof Actions::Step or parent instanceof Actions::Job) and
    parent.lookup("if") = this
  }

  Statement getEnclosingStatement() { result = parent }

  string getCondition() { result = this.(YamlScalar).getValue() }
}

/**
 * Abstract class representing a call to a 3rd party action or reusable workflow.
 */
abstract class UsesExpr extends Expression {
  abstract string getCallee();

  abstract string getVersion();

  abstract Expression getArgumentExpr(string key);

  abstract Expression getEnvExpr(string name);
}

/**
 * A Uses step represents a call to an action that is defined in a GitHub repository.
 */
class StepUsesExpr extends StepStmt, UsesExpr {
  Actions::Uses uses;

  StepUsesExpr() { uses.getStep() = this }

  override string getCallee() { result = uses.getGitHubRepository() }

  override string getVersion() { result = uses.getVersion() }

  override Expression getArgumentExpr(string key) {
    exists(Actions::With with |
      with.getStep() = this and
      result = with.lookup(key)
    )
  }

  /**
   * Gets a environment variable expression by name in the scope of the current step.
   */
  override Expression getEnvExpr(string name) {
    exists(Actions::StepEnv env |
      env.getStep() = this and
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
    )
    or
    exists(Actions::JobEnv env |
      env.getJob() = this.getJobStmt() and
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
    )
    or
    exists(Actions::WorkflowEnv env |
      env.getWorkflow() = this.getJobStmt().getEnclosingWorkflowStmt() and
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
    )
  }
}

/**
 * A Uses step represents a call to an action that is defined in a GitHub repository.
 */
class JobUsesExpr extends UsesExpr instanceof YamlMapping {
  JobUsesExpr() {
    this instanceof JobStmt and this.maps(any(YamlString s | s.getValue() = "uses"), _)
  }

  JobStmt getJobStmt() { result = this }

  /**
   * Gets a regular expression that parses an `owner/repo@version` reference within a `uses` field in an Actions job step.
   * local repo: octo-org/this-repo/.github/workflows/workflow-1.yml@172239021f7ba04fe7327647b213799853a9eb89
   * local repo: ./.github/workflows/workflow-2.yml
   * remote repo: octo-org/another-repo/.github/workflows/workflow.yml@v1
   */
  private string repoUsesParser() { result = "([^/]+)/([^/]+)/([^@]+)@(.+)" }

  private string pathUsesParser() { result = "\\./(.+)" }

  override string getCallee() {
    exists(YamlString name |
      this.(YamlMapping).lookup("uses") = name and
      if name.getValue().matches("./%")
      then result = name.getValue().regexpCapture(this.pathUsesParser(), 1)
      else
        result =
          name.getValue().regexpCapture(this.repoUsesParser(), 1) + "/" +
            name.getValue().regexpCapture(this.repoUsesParser(), 2) + "/" +
            name.getValue().regexpCapture(this.repoUsesParser(), 3)
    )
  }

  /** Gets the version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`. */
  override string getVersion() {
    exists(YamlString name |
      this.(YamlMapping).lookup("uses") = name and
      if not name.getValue().matches("\\.%")
      then result = name.getValue().regexpCapture(this.repoUsesParser(), 4)
      else none()
    )
  }

  override Expression getArgumentExpr(string key) {
    this.(YamlMapping).lookup("with").(YamlMapping).lookup(key) = result
  }

  /**
   * Gets a environment variable expression by name in the scope of the current node.
   */
  override Expression getEnvExpr(string name) {
    this.(YamlMapping).lookup("env").(YamlMapping).lookup(name) = result
    or
    exists(Actions::JobEnv env |
      env.getJob() = this.getJobStmt() and
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
    )
    or
    exists(Actions::WorkflowEnv env |
      env.getWorkflow() = this.getJobStmt().getEnclosingWorkflowStmt() and
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
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

  string getScript() { result = scriptExpr.getValue() }

  /**
   * Gets a environment variable expression by name in the scope of the current node.
   */
  Expression getEnvExpr(string name) {
    exists(Actions::StepEnv env |
      env.getStep() = this and
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
    )
    or
    exists(Actions::JobEnv env |
      env.getJob() = this.getJobStmt() and
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
    )
    or
    exists(Actions::WorkflowEnv env |
      env.getWorkflow() = this.getJobStmt().getEnclosingWorkflowStmt() and
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
    )
  }
}

/**
 * Evaluation of a workflow expression ${{}}.
 */
class ExprAccessExpr extends Expression instanceof YamlString {
  string expr;

  ExprAccessExpr() { expr = Actions::getASimpleReferenceExpression(this) }

  string getExpression() { result = expr }

  JobStmt getJobStmt() { result.getAChildNode*() = this }
}

/**
 * A context access expression.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 */
class CtxAccessExpr extends ExprAccessExpr {
  CtxAccessExpr() {
    expr.regexpMatch([
        stepsCtxRegex(), needsCtxRegex(), jobsCtxRegex(), envCtxRegex(), inputsCtxRegex()
      ])
  }

  abstract string getFieldName();

  abstract Expression getRefExpr();
}

private string stepsCtxRegex() {
  result = "\\bsteps\\.([A-Za-z0-9_-]+)\\.outputs\\.([A-Za-z0-9_-]+)\\b"
}

private string needsCtxRegex() {
  result = "\\bneeds\\.([A-Za-z0-9_-]+)\\.outputs\\.([A-Za-z0-9_-]+)\\b"
}

private string jobsCtxRegex() {
  result = "\\bjobs\\.([A-Za-z0-9_-]+)\\.outputs\\.([A-Za-z0-9_-]+)\\b"
}

private string envCtxRegex() { result = "\\benv\\.([A-Za-z0-9_-]+)\\b" }

private string inputsCtxRegex() {
  result = "\\binputs\\.([A-Za-z0-9_-]+)\\b" or
  result = "\\bgithub\\.event\\.inputs\\.([A-Za-z0-9_-]+)\\b"
}

/**
 * Holds for an expression accesing the `steps` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ steps.changed-files.outputs.all_changed_files }}`
 */
class StepsCtxAccessExpr extends CtxAccessExpr {
  string stepId;
  string fieldName;

  StepsCtxAccessExpr() {
    expr.regexpMatch(stepsCtxRegex()) and
    stepId = expr.regexpCapture(stepsCtxRegex(), 1) and
    fieldName = expr.regexpCapture(stepsCtxRegex(), 2)
  }

  override string getFieldName() { result = fieldName }

  override Expression getRefExpr() {
    this.getLocation().getFile() = result.getLocation().getFile() and
    result.(StepStmt).getId() = stepId
  }
}

/**
 * Holds for an expression accesing the `needs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ needs.job1.outputs.foo}}`
 */
class NeedsCtxAccessExpr extends CtxAccessExpr {
  JobStmt job;
  string jobId;
  string fieldName;

  NeedsCtxAccessExpr() {
    expr.regexpMatch(needsCtxRegex()) and
    jobId = expr.regexpCapture(needsCtxRegex(), 1) and
    fieldName = expr.regexpCapture(needsCtxRegex(), 2) and
    job.getId() = jobId
  }

  predicate usesReusableWorkflow() { job.usesReusableWorkflow() }

  override string getFieldName() { result = fieldName }

  override Expression getRefExpr() {
    job.getLocation().getFile() = this.getLocation().getFile() and
    (
      // regular jobs
      job.getOutputsStmt() = result
      or
      // reusable workflow calling jobs
      job.getUsesExpr() = result
    )
  }
}

/**
 * Holds for an expression accesing the `jobs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ jobs.job1.outputs.foo}}` (within reusable workflows)
 */
class JobsCtxAccessExpr extends CtxAccessExpr {
  string jobId;
  string fieldName;

  JobsCtxAccessExpr() {
    expr.regexpMatch(jobsCtxRegex()) and
    jobId = expr.regexpCapture(jobsCtxRegex(), 1) and
    fieldName = expr.regexpCapture(jobsCtxRegex(), 2)
  }

  override string getFieldName() { result = fieldName }

  override Expression getRefExpr() {
    exists(JobStmt job |
      job.getId() = jobId and
      job.getLocation().getFile() = this.getLocation().getFile() and
      job.getOutputsStmt() = result
    )
  }
}

/**
 * Holds for an expression the `inputs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ inputs.foo }}`
 */
class InputsCtxAccessExpr extends CtxAccessExpr {
  string fieldName;

  InputsCtxAccessExpr() {
    expr.regexpMatch(inputsCtxRegex()) and
    fieldName = expr.regexpCapture(inputsCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override Expression getRefExpr() {
    exists(ReusableWorkflowStmt w |
      w.getLocation().getFile() = this.getLocation().getFile() and
      w.getInputsStmt().getInputExpr(fieldName) = result
    )
    or
    exists(CompositeActionStmt a |
      a.getLocation().getFile() = this.getLocation().getFile() and
      a.getInputsStmt().getInputExpr(fieldName) = result
    )
  }
}

/**
 * Holds for an expression accesing the `env` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ env.foo }}`
 */
class EnvCtxAccessExpr extends CtxAccessExpr {
  string fieldName;

  EnvCtxAccessExpr() {
    expr.regexpMatch(envCtxRegex()) and
    fieldName = expr.regexpCapture(envCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override Expression getRefExpr() {
    exists(JobUsesExpr s | s.getEnvExpr(fieldName) = result)
    or
    exists(StepUsesExpr s | s.getEnvExpr(fieldName) = result)
    or
    exists(RunExpr s | s.getEnvExpr(fieldName) = result)
  }
}

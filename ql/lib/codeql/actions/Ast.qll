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

  predicate isReusable() { this instanceof ReusableWorkflowStmt }
}

class ReusableWorkflowStmt extends WorkflowStmt {
  YamlValue workflow_call;

  ReusableWorkflowStmt() {
    this.(Actions::Workflow).getOn().getNode("workflow_call") = workflow_call
  }

  InputsStmt getInputs() { result = workflow_call.(YamlMapping).lookup("inputs") }

  OutputsStmt getOutputs() { result = workflow_call.(YamlMapping).lookup("outputs") }

  string getName() { result = this.getLocation().getFile().getRelativePath() }
}

class InputsStmt extends Statement instanceof YamlMapping {
  InputsStmt() {
    exists(Actions::On on | on.getNode("workflow_call").(YamlMapping).lookup("inputs") = this)
  }

  /**
   * Gets a specific parameter expression (YamlMapping) by name.
   * eg:
   * on:
   *   workflow_call:
   *     inputs:
   *       config-path:
   *         required: true
   *         type: string
   *     secrets:
   *       token:
   *         required: true
   */
  InputExpr getInputExpr(string name) {
    result.(YamlString).getValue() = name and
    this.(YamlMapping).maps(result, _)
  }
}

class InputExpr extends Expression instanceof YamlString { }

class OutputsStmt extends Statement instanceof YamlMapping {
  OutputsStmt() {
    exists(Actions::On on | on.getNode("workflow_call").(YamlMapping).lookup("outputs") = this)
  }

  /**
   * Gets a specific parameter expression (YamlMapping) by name.
   * eg:
   * on:
   *   workflow_call:
   *     outputs:
   *       firstword:
   *         description: "The first output string"
   *         value: ${{ jobs.example_job.outputs.output1 }}
   *       secondword:
   *         description: "The second output string"
   *         value: ${{ jobs.example_job.outputs.output2 }}
   */
  OutputExpr getOutputExpr(string name) {
    this.(YamlMapping).lookup(name).(YamlMapping).lookup("value") = result
  }
}

class OutputExpr extends Expression instanceof YamlString { }

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

  /**
   * Reusable workflow jobs may have Uses children
   * eg:
   * call-job:
   *   uses: ./.github/workflows/reusable_workflow.yml
   *   with:
   *     arg1: value1
   */
  JobUsesExpr getUsesExpr() { result.getJob() = this }
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
 * Abstract class representing a call to a 3rd party action or reusable workflow.
 */
abstract class UsesExpr extends Expression {
  abstract string getCallee();

  abstract string getVersion();

  abstract Expression getArgument(string key);
}

/**
 * A Uses step represents a call to an action that is defined in a GitHub repository.
 */
class StepUsesExpr extends StepStmt, UsesExpr {
  Actions::Uses uses;

  StepUsesExpr() { uses.getStep() = this }

  override string getCallee() { result = uses.getGitHubRepository() }

  override string getVersion() { result = uses.getVersion() }

  override Expression getArgument(string key) {
    exists(Actions::With with |
      with.getStep() = this and
      result = with.lookup(key)
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

  JobStmt getJob() { result = this }

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

  override Expression getArgument(string key) {
    this.(YamlMapping).lookup("with").(YamlMapping).lookup(key) = result
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
 * eg: `${{ jobs.job1.outputs.foo}}` (for reusable workflows)
 */
class JobOutputAccessExpr extends ExprAccessExpr {
  string jobId;
  string varName;

  JobOutputAccessExpr() {
    jobId =
      this.getExpression()
          .regexpCapture("(needs|jobs)\\.([A-Za-z0-9_-]+)\\.outputs\\.[A-Za-z0-9_-]+", 2) and
    varName =
      this.getExpression()
          .regexpCapture("(needs|jobs)\\.[A-Za-z0-9_-]+\\.outputs\\.([A-Za-z0-9_-]+)", 2)
  }

  string getVarName() { result = varName }

  Expression getOutputExpr() {
    exists(JobStmt job |
      job.getId() = jobId and
      job.getLocation().getFile() = this.getLocation().getFile() and
      (
        // A Job can have multiple outputs, so we need to check both
        // jobs.<job_id>.outputs.<output_name>
        job.getOutputStmt().getOutputExpr(varName) = result
        or
        // jobs.<job_id>.uses (variables returned from the reusable workflow
        job.getUsesExpr() = result
      )
    )
  }
}

/**
 * A ExprAccessExpr where the expression evaluated is a reusable workflow input read.
 * eg: `${{ inputs.foo}}`
 */
class ReusableWorkflowInputAccessExpr extends ExprAccessExpr {
  string paramName;

  ReusableWorkflowInputAccessExpr() {
    paramName = this.getExpression().regexpCapture("inputs\\.([A-Za-z0-9_-]+)", 1)
  }

  string getParamName() { result = paramName }

  Expression getInputExpr() {
    exists(ReusableWorkflowStmt w |
      w.getLocation().getFile() = this.getLocation().getFile() and
      w.getInputs().getInputExpr(paramName) = result
    )
  }
}

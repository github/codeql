private import codeql.actions.ast.internal.Actions
private import codeql.Locations

/**
 * Base class for thejAST tree. Based on YamlNode from the Yaml library.
 */
class AstNode instanceof YamlNode {
  AstNode getParentNode() { result = super.getParentNode() }

  AstNode getAChildNode() { result = super.getAChildNode() }

  string toString() { result = super.toString() }

  string getAPrimaryQlClass() { result = super.getAPrimaryQlClass() }

  Location getLocation() { result = super.getLocation() }

  /**
   * Gets the enclosing workflow statement.
   */
  Workflow getEnclosingWorkflow() { this = result.getAChildNode*() }

  /**
   * Gets a environment variable expression by name in the scope of the current node.
   */
  EnvExpr getEnvExpr(string name) {
    exists(Actions::Env env |
      env.(YamlMapping).maps(any(YamlScalar s | s.getValue() = name), result)
    |
      env.(Actions::StepEnv).getStep().getAChildNode*() = this
      or
      env.(Actions::JobEnv).getJob().getAChildNode*() = this
      or
      env.(Actions::WorkflowEnv).getWorkflow().getAChildNode*() = this
    )
  }
}

/**
 * A composite action
 */
class CompositeAction extends AstNode instanceof Actions::CompositeAction {
  Runs getRuns() { result = super.getRuns() }

  Inputs getInputs() { result = this.(YamlMapping).lookup("inputs") }

  Outputs getOutputs() { result = this.(YamlMapping).lookup("outputs") }
}

class Runs extends AstNode instanceof Actions::Runs {
  Step getAStep() { result = super.getSteps().getElementNode(_) }

  Step getStep(int i) { result = super.getSteps().getElementNode(i) }
}

/**
 * A Github Actions Workflow
 */
class Workflow extends AstNode instanceof Actions::Workflow {
  string getName() { result = super.getName() }

  Job getAJob() { result = super.getJob(_) }

  Job getJob(string id) { result = super.getJob(id) }

  predicate hasTriggerEvent(string trigger) {
    exists(YamlNode n | n = super.getOn().(YamlMappingLikeNode).getNode(trigger))
  }

  string getATriggerEvent() {
    exists(YamlNode n | n = super.getOn().(YamlMappingLikeNode).getNode(result))
  }

  Permissions getPermissions() { result = this.(YamlMapping).lookup("permissions") }

  Strategy getStrategy() { result = this.(YamlMapping).lookup("strategy") }
}

class ReusableWorkflow extends Workflow {
  YamlValue workflow_call;

  ReusableWorkflow() { this.(Actions::Workflow).getOn().getNode("workflow_call") = workflow_call }

  Inputs getInputs() { result = workflow_call.(YamlMapping).lookup("inputs") }

  Outputs getOutputs() { result = workflow_call.(YamlMapping).lookup("outputs") }
}

class Inputs extends AstNode instanceof YamlMapping {
  YamlMapping parent;

  Inputs() { parent.lookup("inputs") = this }

  /**
   * Gets a specific input expression (YamlMapping) by name.
   */
  InputExpr getInputExpr(string name) {
    result.(YamlString).getValue() = name and
    this.(YamlMapping).maps(result, _)
  }
}

class Outputs extends AstNode instanceof YamlMapping {
  YamlMapping parent;

  Outputs() { parent.lookup("outputs") = this }

  /**
   * Gets a specific output expression (YamlMapping) by name.
   */
  OutputExpr getOutputExpr(string name) {
    this.(YamlMapping).lookup(name).(YamlMapping).lookup("value") = result or
    this.(YamlMapping).lookup(name) = result
  }

  string getAnOutputName() { this.(YamlMapping).maps(any(YamlString s | s.getValue() = result), _) }
}

class Permissions extends AstNode instanceof YamlMapping {
  YamlMapping parent;

  Permissions() { parent.lookup("permissions") = this }
}

class Strategy extends AstNode instanceof YamlMapping {
  YamlMapping parent;

  Strategy() { parent.lookup("strategy") = this }

  /**
   * Gets a specific matric expression (YamlMapping) by name.
   */
  MatrixVariableExpr getMatrixVariableExpr(string name) {
    this.(YamlMapping).lookup("matrix").(YamlMapping).lookup(name) = result
  }

  string getAMatrixVariableName() {
    this.(YamlMapping).maps(any(YamlString s | s.getValue() = result), _)
  }
}

/**
 * A Job is a collection of steps that run in an execution environment.
 */
class Job extends AstNode instanceof Actions::Job {
  /**
   * Gets the ID of this job, as a string.
   * This is the job's key within the `jobs` mapping.
   */
  string getId() { result = super.getId() }

  /** Gets the step at the given index within this job. */
  Step getStep(int index) { result = super.getStep(index) }

  /** Gets any steps that are defined within this job. */
  Step getAStep() { result = super.getStep(_) }

  /**
   * Gets a needed job.
   * eg:
   *     - needs: [job1, job2]
   */
  Job getNeededJob() {
    exists(Actions::Needs needs |
      needs.getJob() = this and
      result = needs.getANeededJob()
    )
  }

  /**
   * Gets the declaration of the outputs for the job.
   * eg:
   *   out1: ${steps.foo.bar}
   *   out2: ${steps.foo.baz}
   */
  Outputs getOutputs() { result = this.(Actions::Job).lookup("outputs") }

  /**
   * Reusable workflow jobs may have Uses children
   * eg:
   * call-job:
   *   uses: ./.github/workflows/reusable_workflow.yml
   *   with:
   *     arg1: value1
   */
  JobUses getUses() { result.getJob() = this }

  predicate usesReusableWorkflow() {
    this.(YamlMapping).maps(any(YamlString s | s.getValue() = "uses"), _)
  }

  If getIf() { result = super.getIf() }

  Permissions getPermissions() { result = this.(YamlMapping).lookup("permissions") }

  Strategy getStrategy() { result = this.(YamlMapping).lookup("strategy") }
}

/**
 * A Step is a single task that can be executed as part of a job.
 */
class Step extends AstNode instanceof Actions::Step {
  string getId() { result = super.getId() }

  Job getJob() { result = super.getJob() }

  If getIf() { result = super.getIf() }
}

/**
 * An If node representing a conditional statement.
 */
class If extends AstNode {
  YamlMapping parent;

  If() {
    (parent instanceof Actions::Step or parent instanceof Actions::Job) and
    parent.lookup("if") = this
  }

  AstNode getEnclosingNode() { result = parent }

  string getCondition() { result = this.(YamlScalar).getValue() }
}

/**
 * Abstract class representing a call to a 3rd party action or reusable workflow.
 */
abstract class Uses extends AstNode {
  abstract string getCallee();

  abstract string getVersion();

  abstract Expression getArgumentExpr(string key);
}

/**
 * A Uses step represents a call to an action that is defined in a GitHub repository.
 */
class StepUses extends Step, Uses {
  Actions::Uses uses;

  StepUses() { uses.getStep() = this }

  override string getCallee() { result = uses.getGitHubRepository() }

  override string getVersion() {
    result = uses.getVersion()
    or
    not exists(uses.getVersion()) and
    result = "main"
  }

  override Expression getArgumentExpr(string key) {
    exists(Actions::With with |
      with.getStep() = this and
      result = with.lookup(key)
    )
  }
}

/**
 * A Uses step represents a call to an action that is defined in a GitHub repository.
 */
class JobUses extends Uses instanceof YamlMapping {
  JobUses() { this instanceof Job and this.maps(any(YamlString s | s.getValue() = "uses"), _) }

  Job getJob() { result = this }

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
}

/**
 * A Run step represents the evaluation of a provided script
 */
class Run extends Step {
  Actions::Run scriptExpr;

  Run() { scriptExpr.getStep() = this }

  Expression getScriptExpr() { result = scriptExpr }

  string getScript() { result = scriptExpr.getValue() }
}

/**
 * An AST node associated with a Reusable Workflow input.
 */
class InputExpr extends AstNode {
  InputExpr() { exists(Inputs inputs | inputs.(YamlMapping).maps(this, _)) }
}

/**
 * An AST node holding an Env var value.
 */
class EnvExpr extends AstNode {
  EnvExpr() { exists(Actions::Env env | env.(YamlMapping).lookup(_) = this) }
}

/**
 * An AST node holding a job or workflow output var.
 */
class OutputExpr extends AstNode {
  OutputExpr() {
    exists(Outputs outputs |
      outputs.(YamlMapping).lookup(_).(YamlMapping).lookup("value") = this or
      outputs.(YamlMapping).lookup(_) = this
    )
  }
}

/**
 * An AST node holding a matrix var.
 */
class MatrixVariableExpr extends AstNode {
  MatrixVariableExpr() {
    exists(Strategy outputs | outputs.(YamlMapping).lookup("matrix").(YamlMapping).lookup(_) = this)
  }
}

/**
 * Evaluation of a workflow expression ${{}}.
 */
class Expression extends AstNode instanceof YamlString {
  string expr;

  Expression() { expr = Actions::getASimpleReferenceExpression(this) }

  string getExpression() { result = expr }

  Job getJob() { result.getAChildNode*() = this }
}

/**
 * A ${{}} expression accessing a context variable.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 */
class ContextExpression extends Expression {
  ContextExpression() {
    expr.regexpMatch([
        stepsCtxRegex(), needsCtxRegex(), jobsCtxRegex(), envCtxRegex(), inputsCtxRegex(),
        matrixCtxRegex()
      ])
  }

  abstract string getFieldName();

  abstract AstNode getTarget();
}

private string stepsCtxRegex() {
  result = wrapRegexp("steps\\.([A-Za-z0-9_-]+)\\.outputs\\.([A-Za-z0-9_-]+)")
}

private string needsCtxRegex() {
  result = wrapRegexp("needs\\.([A-Za-z0-9_-]+)\\.outputs\\.([A-Za-z0-9_-]+)")
}

private string jobsCtxRegex() {
  result = wrapRegexp("jobs\\.([A-Za-z0-9_-]+)\\.outputs\\.([A-Za-z0-9_-]+)")
}

private string envCtxRegex() { result = wrapRegexp("env\\.([A-Za-z0-9_-]+)") }

private string matrixCtxRegex() { result = wrapRegexp("matrix\\.([A-Za-z0-9_-]+)") }

private string inputsCtxRegex() {
  result = wrapRegexp(["inputs\\.([A-Za-z0-9_-]+)", "github\\.event\\.inputs\\.([A-Za-z0-9_-]+)"])
}

bindingset[regex]
private string wrapRegexp(string regex) {
  result = ["\\b" + regex + "\\b", "fromJSON\\(" + regex + "\\)", "toJSON\\(" + regex + "\\)"]
}

/**
 * Holds for an expression accesing the `steps` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ steps.changed-files.outputs.all_changed_files }}`
 */
class StepsExpression extends ContextExpression {
  string stepId;
  string fieldName;

  StepsExpression() {
    expr.regexpMatch(stepsCtxRegex()) and
    stepId = expr.regexpCapture(stepsCtxRegex(), 1) and
    fieldName = expr.regexpCapture(stepsCtxRegex(), 2)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    this.getLocation().getFile() = result.getLocation().getFile() and
    result.(Step).getId() = stepId
  }
}

/**
 * Holds for an expression accesing the `needs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ needs.job1.outputs.foo}}`
 */
class NeedsExpression extends ContextExpression {
  Job job;
  string jobId;
  string fieldName;

  NeedsExpression() {
    expr.regexpMatch(needsCtxRegex()) and
    jobId = expr.regexpCapture(needsCtxRegex(), 1) and
    fieldName = expr.regexpCapture(needsCtxRegex(), 2) and
    job.getId() = jobId
  }

  predicate usesReusableWorkflow() { job.usesReusableWorkflow() }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    job.getLocation().getFile() = this.getLocation().getFile() and
    (
      // regular jobs
      job.getOutputs() = result
      or
      // reusable workflow calling jobs
      job.getUses() = result
    )
  }
}

/**
 * Holds for an expression accesing the `jobs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ jobs.job1.outputs.foo}}` (within reusable workflows)
 */
class JobsExpression extends ContextExpression {
  string jobId;
  string fieldName;

  JobsExpression() {
    expr.regexpMatch(jobsCtxRegex()) and
    jobId = expr.regexpCapture(jobsCtxRegex(), 1) and
    fieldName = expr.regexpCapture(jobsCtxRegex(), 2)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    exists(Job job |
      job.getId() = jobId and
      job.getLocation().getFile() = this.getLocation().getFile() and
      job.getOutputs() = result
    )
  }
}

/**
 * Holds for an expression the `inputs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ inputs.foo }}`
 */
class InputsExpression extends ContextExpression {
  string fieldName;

  InputsExpression() {
    expr.regexpMatch(inputsCtxRegex()) and
    fieldName = expr.regexpCapture(inputsCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    result.getLocation().getFile() = this.getLocation().getFile() and
    (
      exists(ReusableWorkflow w | w.getInputs().getInputExpr(fieldName) = result)
      or
      exists(CompositeAction a | a.getInputs().getInputExpr(fieldName) = result)
    )
  }
}

/**
 * Holds for an expression accesing the `env` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ env.foo }}`
 */
class EnvExpression extends ContextExpression {
  string fieldName;

  EnvExpression() {
    expr.regexpMatch(envCtxRegex()) and
    fieldName = expr.regexpCapture(envCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    exists(AstNode s |
      s.getEnvExpr(fieldName) = result and
      s.getAChildNode*() = this
    )
  }
}

/**
 * Holds for an expression accesing the `matrix` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ matrix.foo }}`
 */
class MatrixExpression extends ContextExpression {
  string fieldName;

  MatrixExpression() {
    expr.regexpMatch(matrixCtxRegex()) and
    fieldName = expr.regexpCapture(matrixCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    exists(Workflow w |
      w.getStrategy().getMatrixVariableExpr(fieldName) = result and
      w.getAChildNode*() = this
    )
    or
    exists(Job j |
      j.getStrategy().getMatrixVariableExpr(fieldName) = result and
      j.getAChildNode*() = this
    )
  }
}

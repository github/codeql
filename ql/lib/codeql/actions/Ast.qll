private import codeql.actions.ast.internal.Ast
private import codeql.Locations
import codeql.actions.Helper

class AstNode instanceof AstNodeImpl {
  AstNode getAChildNode() { result = super.getAChildNode() }

  AstNode getParentNode() { result = super.getParentNode() }

  string getAPrimaryQlClass() { result = super.getAPrimaryQlClass() }

  Location getLocation() { result = super.getLocation() }

  string toString() { result = super.toString() }

  Job getEnclosingJob() { result = super.getEnclosingJob() }

  Workflow getEnclosingWorkflow() { result = super.getEnclosingWorkflow() }

  CompositeAction getEnclosingCompositeAction() { result = super.getEnclosingCompositeAction() }

  Expression getInScopeEnvVarExpr(string name) { result = super.getInScopeEnvVarExpr(name) }
}

class ScalarValue extends AstNode instanceof ScalarValueImpl {
  string getValue() { result = super.getValue() }
}

class Expression extends AstNode instanceof ExpressionImpl {
  string expression;
  string rawExpression;

  Expression() {
    expression = this.getExpression() and
    rawExpression = this.getRawExpression()
  }

  string getExpression() { result = expression }

  string getRawExpression() { result = rawExpression }

  string getNormalizedExpression() { result = normalizeExpr(expression) }
}

/** A common class for `env` in workflow, job or step. */
abstract class Env extends AstNode instanceof EnvImpl {
  /** Gets an environment variable value given its name. */
  ScalarValueImpl getEnvVarValue(string name) { result = super.getEnvVarValue(name) }

  /** Gets an environment variable value. */
  ScalarValueImpl getAnEnvVarValue() { result = super.getAnEnvVarValue() }

  /** Gets an environment variable expressin given its name. */
  ExpressionImpl getEnvVarExpr(string name) { result = super.getEnvVarExpr(name) }

  /** Gets an environment variable expression. */
  ExpressionImpl getAnEnvVarExpr() { result = super.getAnEnvVarExpr() }
}

/**
 * A custom composite action. This is a mapping at the top level of an Actions YAML action file.
 * See https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions.
 */
class CompositeAction extends AstNode instanceof CompositeActionImpl {
  Runs getRuns() { result = super.getRuns() }

  Outputs getOutputs() { result = super.getOutputs() }

  Expression getAnOutputExpr() { result = super.getAnOutputExpr() }

  Expression getOutputExpr(string outputName) { result = super.getOutputExpr(outputName) }

  Input getAnInput() { result = super.getAnInput() }

  Input getInput(string inputName) { result = super.getInput(inputName) }

  LocalJob getACaller() { result = super.getACaller() }

  predicate isPrivileged() { super.isPrivileged() }
}

/**
 * An `runs` mapping in a custom composite action YAML.
 * See https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions#runs
 */
class Runs extends AstNode instanceof RunsImpl {
  CompositeAction getAction() { result = super.getAction() }

  Step getAStep() { result = super.getAStep() }

  Step getStep(int i) { result = super.getStep(i) }
}

/**
 * An Actions workflow. This is a mapping at the top level of an Actions YAML workflow file.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions.
 */
class Workflow extends AstNode instanceof WorkflowImpl {
  Env getEnv() { result = super.getEnv() }

  string getName() { result = super.getName() }

  Job getAJob() { result = super.getAJob() }

  Job getJob(string jobId) { result = super.getJob(jobId) }

  Event getATriggerEvent() { result = super.getATriggerEvent() }

  Permissions getPermissions() { result = super.getPermissions() }

  Strategy getStrategy() { result = super.getStrategy() }

  On getOn() { result = super.getOn() }
}

class ReusableWorkflow extends Workflow instanceof ReusableWorkflowImpl {
  Outputs getOutputs() { result = super.getOutputs() }

  Expression getAnOutputExpr() { result = super.getAnOutputExpr() }

  Expression getOutputExpr(string outputName) { result = super.getOutputExpr(outputName) }

  Input getAnInput() { result = super.getAnInput() }

  Input getInput(string inputName) { result = super.getInput(inputName) }

  ExternalJob getACaller() { result = super.getACaller() }
}

class Input extends AstNode instanceof InputImpl { }

class Outputs extends AstNode instanceof OutputsImpl {
  Expression getAnOutputExpr() { result = super.getAnOutputExpr() }

  Expression getOutputExpr(string outputName) { result = super.getOutputExpr(outputName) }

  override string toString() { result = "Job outputs node" }
}

class Permissions extends AstNode instanceof PermissionsImpl {
  bindingset[perm]
  string getPermission(string perm) { result = super.getPermission(perm) }

  string getAPermission() { result = super.getAPermission() }
}

class Strategy extends AstNode instanceof StrategyImpl {
  Expression getMatrixVarExpr(string varName) { result = super.getMatrixVarExpr(varName) }

  Expression getAMatrixVarExpr() { result = super.getAMatrixVarExpr() }
}

/**
 * https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idneeds
 */
class Needs extends AstNode instanceof NeedsImpl {
  Job getANeededJob() { result = super.getANeededJob() }
}

class On extends AstNode instanceof OnImpl {
  Event getAnEvent() { result = super.getAnEvent() }
}

class Event extends AstNode instanceof EventImpl {
  string getName() { result = super.getName() }

  string getAnActivityType() { result = super.getAnActivityType() }

  string getAPropertyValue(string prop) { result = super.getAPropertyValue(prop) }

  predicate hasProperty(string prop) { super.hasProperty(prop) }
}

/**
 * An Actions job within a workflow.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobs.
 */
abstract class Job extends AstNode instanceof JobImpl {
  string getId() { result = super.getId() }

  Workflow getWorkflow() { result = super.getWorkflow() }

  Job getANeededJob() { result = super.getANeededJob() }

  Outputs getOutputs() { result = super.getOutputs() }

  Expression getAnOutputExpr() { result = super.getAnOutputExpr() }

  Expression getOutputExpr(string outputName) { result = super.getOutputExpr(outputName) }

  Env getEnv() { result = super.getEnv() }

  If getIf() { result = super.getIf() }

  Permissions getPermissions() { result = super.getPermissions() }

  Event getATriggerEvent() { result = super.getATriggerEvent() }

  Strategy getStrategy() { result = super.getStrategy() }

  predicate isPrivileged() { super.isPrivileged() }

  predicate isExternallyTriggerable() { super.isExternallyTriggerable() }

  string getARunsOnLabel() { result = super.getARunsOnLabel() }
}

class LocalJob extends Job instanceof LocalJobImpl {
  Step getAStep() { result = super.getAStep() }

  Step getStep(int i) { result = super.getStep(i) }
}

/**
 * A step within an Actions job.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idsteps.
 */
class Step extends AstNode instanceof StepImpl {
  string getId() { result = super.getId() }

  Env getEnv() { result = super.getEnv() }

  If getIf() { result = super.getIf() }

  Step getAFollowingStep() { result = super.getAFollowingStep() }
}

/**
 * An If node representing a conditional statement.
 */
class If extends AstNode instanceof IfImpl {
  string getCondition() { result = super.getCondition() }

  Expression getConditionExpr() { result = super.getConditionExpr() }

  string getConditionStyle() { result = super.getConditionStyle() }
}

abstract class Uses extends AstNode instanceof UsesImpl {
  string getCallee() { result = super.getCallee() }

  string getVersion() { result = super.getVersion() }

  int getMajorVersion() { result = super.getMajorVersion() }

  string getArgument(string argName) { result = super.getArgument(argName) }

  Expression getArgumentExpr(string argName) { result = super.getArgumentExpr(argName) }
}

class UsesStep extends Step, Uses instanceof UsesStepImpl { }

class ExternalJob extends Job, Uses instanceof ExternalJobImpl { }

/**
 * A `run` field within an Actions job step, which runs command-line programs using an operating system shell.
 * See https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepsrun.
 */
class Run extends Step instanceof RunImpl {
  string getScript() { result = super.getScript() }

  ScalarValue getScriptScalar() { result = super.getScriptScalar() }

  Expression getAnScriptExpr() { result = super.getAnScriptExpr() }
}

abstract class SimpleReferenceExpression extends AstNode instanceof SimpleReferenceExpressionImpl {
  string getFieldName() { result = super.getFieldName() }

  AstNode getTarget() { result = super.getTarget() }
}

class SecretsExpression extends SimpleReferenceExpression instanceof SecretsExpressionImpl { }

class StepsExpression extends SimpleReferenceExpression instanceof StepsExpressionImpl {
  string getStepId() { result = super.getStepId() }
}

class NeedsExpression extends SimpleReferenceExpression instanceof NeedsExpressionImpl { }

class JobsExpression extends SimpleReferenceExpression instanceof JobsExpressionImpl { }

class InputsExpression extends SimpleReferenceExpression instanceof InputsExpressionImpl { }

class EnvExpression extends SimpleReferenceExpression instanceof EnvExpressionImpl { }

class MatrixExpression extends SimpleReferenceExpression instanceof MatrixExpressionImpl { }

private import codeql.actions.ast.internal.Ast
private import codeql.Locations
import codeql.actions.Helper

class AstNode instanceof AstNodeImpl {
  AstNode getAChildNode() { result = super.getAChildNode() }

  AstNode getParentNode() { result = super.getParentNode() }

  string getAPrimaryQlClass() { result = super.getAPrimaryQlClass() }

  Location getLocation() { result = super.getLocation() }

  string toString() { result = super.toString() }

  Step getEnclosingStep() { result = super.getEnclosingStep() }

  Job getEnclosingJob() { result = super.getEnclosingJob() }

  Event getATriggerEvent() { result = super.getATriggerEvent() }

  Workflow getEnclosingWorkflow() { result = super.getEnclosingWorkflow() }

  CompositeAction getEnclosingCompositeAction() { result = super.getEnclosingCompositeAction() }

  Expression getInScopeEnvVarExpr(string name) { result = super.getInScopeEnvVarExpr(name) }

  ScalarValue getInScopeDefaultValue(string name, string prop) {
    result = super.getInScopeDefaultValue(name, prop)
  }
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

  LocalJob getACallerJob() { result = super.getACallerJob() }

  UsesStep getACallerStep() { result = super.getACallerStep() }

  predicate isPrivileged() { super.isPrivileged() }
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

class Default extends AstNode instanceof DefaultsImpl {
  ScalarValue getValue(string name, string prop) { result = super.getValue(name, prop) }
}

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

  predicate isExternallyTriggerable() { super.isExternallyTriggerable() }

  predicate isPrivileged() { super.isPrivileged() }
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

  Environment getEnvironment() { result = super.getEnvironment() }

  Permissions getPermissions() { result = super.getPermissions() }

  Strategy getStrategy() { result = super.getStrategy() }

  string getARunsOnLabel() { result = super.getARunsOnLabel() }

  predicate isPrivileged() { super.isPrivileged() }

  predicate isPrivilegedExternallyTriggerable(Event event) {
    super.isPrivilegedExternallyTriggerable(event)
  }
}

abstract class StepsContainer extends AstNode instanceof StepsContainerImpl {
  Step getAStep() { result = super.getAStep() }

  Step getStep(int i) { result = super.getStep(i) }
}

/**
 * An `runs` mapping in a custom composite action YAML.
 * See https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions#runs
 */
class Runs extends StepsContainer instanceof RunsImpl {
  CompositeAction getAction() { result = super.getAction() }
}

/**
 * An Actions job within a workflow which is composed of steps.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobs.
 */
class LocalJob extends Job, StepsContainer instanceof LocalJobImpl { }

/**
 * A step within an Actions job.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idsteps.
 */
class Step extends AstNode instanceof StepImpl {
  string getId() { result = super.getId() }

  Env getEnv() { result = super.getEnv() }

  If getIf() { result = super.getIf() }

  StepsContainer getContainer() { result = super.getContainer() }

  Step getNextStep() { result = super.getNextStep() }

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

/**
 * An Environemnt node representing a deployment environment.
 */
class Environment extends AstNode instanceof EnvironmentImpl {
  string getName() { result = super.getName() }

  Expression getNameExpr() { result = super.getNameExpr() }
}

abstract class Uses extends AstNode instanceof UsesImpl {
  string getCallee() { result = super.getCallee() }

  ScalarValue getCalleeNode() { result = super.getCalleeNode() }

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
  ShellScript getScript() { result = super.getScript() }

  Expression getAnScriptExpr() { result = super.getAnScriptExpr() }

  string getWorkingDirectory() { result = super.getWorkingDirectory() }

  string getShell() { result = super.getShell() }
}

class ShellScript extends ScalarValueImpl instanceof ShellScriptImpl {
  string getRawScript() { result = super.getRawScript() }

  string getStmt(int i) { result = super.getStmt(i) }

  string getAStmt() { result = super.getAStmt() }

  string getCommand(int i) { result = super.getCommand(i) }

  string getACommand() { result = super.getACommand() }

  string getFileReadCommand(int i) { result = super.getFileReadCommand(i) }

  string getAFileReadCommand() { result = super.getAFileReadCommand() }

  predicate getAssignment(int i, string name, string data) { super.getAssignment(i, name, data) }

  predicate getAnAssignment(string name, string data) { super.getAnAssignment(name, data) }

  predicate getAWriteToGitHubEnv(string name, string data) {
    super.getAWriteToGitHubEnv(name, data)
  }

  predicate getAWriteToGitHubOutput(string name, string data) {
    super.getAWriteToGitHubOutput(name, data)
  }

  predicate getAWriteToGitHubPath(string data) { super.getAWriteToGitHubPath(data) }

  predicate getAnEnvReachingGitHubOutputWrite(string var, string output_field) {
    super.getAnEnvReachingGitHubOutputWrite(var, output_field)
  }

  predicate getACmdReachingGitHubOutputWrite(string cmd, string output_field) {
    super.getACmdReachingGitHubOutputWrite(cmd, output_field)
  }

  predicate getAnEnvReachingGitHubEnvWrite(string var, string output_field) {
    super.getAnEnvReachingGitHubEnvWrite(var, output_field)
  }

  predicate getACmdReachingGitHubEnvWrite(string cmd, string output_field) {
    super.getACmdReachingGitHubEnvWrite(cmd, output_field)
  }

  predicate getAnEnvReachingGitHubPathWrite(string var) {
    super.getAnEnvReachingGitHubPathWrite(var)
  }

  predicate getACmdReachingGitHubPathWrite(string cmd) { super.getACmdReachingGitHubPathWrite(cmd) }

  predicate getAnEnvReachingArgumentInjectionSink(string var, string command, string argument) {
    super.getAnEnvReachingArgumentInjectionSink(var, command, argument)
  }

  predicate getACmdReachingArgumentInjectionSink(string cmd, string command, string argument) {
    super.getACmdReachingArgumentInjectionSink(cmd, command, argument)
  }

  predicate fileToGitHubEnv(string path) { super.fileToGitHubEnv(path) }

  predicate fileToGitHubOutput(string path) { super.fileToGitHubOutput(path) }

  predicate fileToGitHubPath(string path) { super.fileToGitHubPath(path) }
}

abstract class SimpleReferenceExpression extends AstNode instanceof SimpleReferenceExpressionImpl {
  string getFieldName() { result = super.getFieldName() }

  AstNode getTarget() { result = super.getTarget() }
}

class JsonReferenceExpression extends AstNode instanceof JsonReferenceExpressionImpl {
  string getAccessPath() { result = super.getAccessPath() }

  string getInnerExpression() { result = super.getInnerExpression() }
}

class GitHubExpression extends SimpleReferenceExpression instanceof GitHubExpressionImpl { }

class SecretsExpression extends SimpleReferenceExpression instanceof SecretsExpressionImpl { }

class StepsExpression extends SimpleReferenceExpression instanceof StepsExpressionImpl {
  string getStepId() { result = super.getStepId() }
}

class NeedsExpression extends SimpleReferenceExpression instanceof NeedsExpressionImpl {
  string getNeededJobId() { result = super.getNeededJobId() }
}

class JobsExpression extends SimpleReferenceExpression instanceof JobsExpressionImpl { }

class InputsExpression extends SimpleReferenceExpression instanceof InputsExpressionImpl { }

class EnvExpression extends SimpleReferenceExpression instanceof EnvExpressionImpl { }

class MatrixExpression extends SimpleReferenceExpression instanceof MatrixExpressionImpl { }

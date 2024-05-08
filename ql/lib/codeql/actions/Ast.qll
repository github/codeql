private import codeql.actions.ast.internal.Ast
private import codeql.Locations

module Utils {
  bindingset[expr]
  string normalizeExpr(string expr) {
    result =
      expr.regexpReplaceAll("\\['([a-zA-Z0-9_\\*\\-]+)'\\]", ".$1")
          .regexpReplaceAll("\\[\"([a-zA-Z0-9_\\*\\-]+)\"\\]", ".$1")
          .regexpReplaceAll("\\s*\\.\\s*", ".")
  }

  bindingset[regex]
  string wrapRegexp(string regex) {
    result =
      [
        "\\b" + regex + "\\b", "fromJSON\\(\\s*" + regex + "\\s*\\)",
        "toJSON\\(\\s*" + regex + "\\s*\\)"
      ]
  }

  bindingset[str]
  private string trimQuotes(string str) {
    result = str.trim().regexpReplaceAll("^(\"|')", "").regexpReplaceAll("(\"|')$", "")
  }

  bindingset[line, var]
  predicate extractLineAssignment(string line, string var, string key, string value) {
    exists(string assignment |
      // single line assignment
      assignment =
        line.regexpCapture("(echo|Write-Output)\\s+(.*)>>\\s*(\"|')?\\$(\\{)?GITHUB_" +
            var.toUpperCase() + "(\\})?(\"|')?", 2) and
      count(assignment.splitAt("=")) = 2 and
      key = trimQuotes(assignment.splitAt("=", 0)) and
      value = trimQuotes(assignment.splitAt("=", 1))
      or
      // workflow command assignment
      assignment =
        line.regexpCapture("(echo|Write-Output)\\s+(\"|')?::set-" + var.toLowerCase() +
            "\\s+name=(.*)(\"|')?", 3).regexpReplaceAll("^\"", "").regexpReplaceAll("\"$", "") and
      key = trimQuotes(assignment.splitAt("::", 0)) and
      value = trimQuotes(assignment.splitAt("::", 1))
    )
  }

  bindingset[var]
  private string multilineAssignmentRegex(string var) {
    // eg:
    // echo "PR_TITLE<<EOF" >> $GITHUB_ENV
    // echo "$TITLE" >> $GITHUB_ENV
    // echo "EOF" >> $GITHUB_ENV
    result =
      ".*(echo|Write-Output)\\s+(.*)<<[\\-]*\\s*([A-Z]*)EOF(.+)(echo|Write-Output)\\s+(\"|')?([A-Z]*)EOF(\"|')?\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_"
        + var.toUpperCase() + "(\\})?(\"|')?.*"
  }

  bindingset[var]
  private string multilineBlockAssignmentRegex(string var) {
    // eg:
    // {
    //   echo 'JSON_RESPONSE<<EOF'
    //   echo "$TITLE" >> "$GITHUB_ENV"
    //   echo EOF
    // } >> "$GITHUB_ENV"
    result =
      ".*\\{(\\s|::NEW_LINE::)*(echo|Write-Output)\\s+(.*)<<[\\-]*\\s*([A-Z]*)EOF(.+)(echo|Write-Output)\\s+(\"|')?([A-Z]*)EOF(\"|')?(\\s|::NEW_LINE::)*\\}\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_"
        + var.toUpperCase() + "(\\})?(\"|')?.*"
  }

  bindingset[var]
  private string multilineHereDocAssignmentRegex(string var) {
    // eg:
    // cat <<-EOF >> "$GITHUB_ENV"
    //   echo "FOO=$TITLE"
    // EOF
    result =
      ".*cat\\s*<<[\\-]*\\s*[A-Z]*EOF\\s*>>\\s*[\"']*\\$[\\{]*GITHUB_.*" + var.toUpperCase() +
        "[\\}]*[\"']*.*(echo|Write-Output)\\s+([^=]+)=(.*)::NEW_LINE::.*EOF.*"
  }

  bindingset[script, var]
  predicate extractMultilineAssignment(string script, string var, string key, string value) {
    // multiline assignment
    exists(string flattenedScript |
      flattenedScript = script.replaceAll("\n", "::NEW_LINE::") and
      value =
        "$(" +
          trimQuotes(flattenedScript.regexpCapture(multilineAssignmentRegex(var), 4))
              .regexpReplaceAll("\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_" + var.toUpperCase() +
                  "(\\})?(\"|')?", "")
              .replaceAll("::NEW_LINE::", "\n")
              .trim()
              .splitAt("\n") + ")" and
      key = trimQuotes(flattenedScript.regexpCapture(multilineAssignmentRegex(var), 2))
    )
    or
    // multiline block assignment
    exists(string flattenedScript |
      flattenedScript = script.replaceAll("\n", "::NEW_LINE::") and
      value =
        "$(" +
          trimQuotes(flattenedScript.regexpCapture(multilineBlockAssignmentRegex(var), 5))
              .regexpReplaceAll("\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_" + var.toUpperCase() +
                  "(\\})?(\"|')?", "")
              .replaceAll("::NEW_LINE::", "\n")
              .trim()
              .splitAt("\n") + ")" and
      key = trimQuotes(flattenedScript.regexpCapture(multilineBlockAssignmentRegex(var), 3))
    )
    or
    // multiline heredoc assignment
    exists(string flattenedScript |
      flattenedScript = script.replaceAll("\n", "::NEW_LINE::") and
      value =
        trimQuotes(flattenedScript.regexpCapture(multilineHereDocAssignmentRegex(var), 3))
            .regexpReplaceAll("\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_" + var.toUpperCase() +
                "(\\})?(\"|')?", "")
            .replaceAll("::NEW_LINE::", "\n")
            .trim()
            .splitAt("\n") and
      key = trimQuotes(flattenedScript.regexpCapture(multilineHereDocAssignmentRegex(var), 2))
    )
  }

  bindingset[line]
  predicate extractPathAssignment(string line, string value) {
    exists(string path |
      // single path assignment
      path =
        line.regexpCapture("(echo|Write-Output)\\s+(.*)>>\\s*(\"|')?\\$(\\{)?GITHUB_PATH(\\})?(\"|')?",
          2) and
      value = trimQuotes(path)
      or
      // workflow command assignment
      path =
        line.regexpCapture("(echo|Write-Output)\\s+(\"|')?::add-path::(.*)(\"|')?", 3)
            .regexpReplaceAll("^\"", "")
            .regexpReplaceAll("\"$", "") and
      value = trimQuotes(path)
    )
  }

  predicate writeToGitHubEnv(Run run, string key, string value) {
    extractLineAssignment(run.getScript().splitAt("\n"), "ENV", key, value) or
    extractMultilineAssignment(run.getScript(), "ENV", key, value)
  }

  predicate writeToGitHubOutput(Run run, string key, string value) {
    extractLineAssignment(run.getScript().splitAt("\n"), "OUTPUT", key, value) or
    extractMultilineAssignment(run.getScript(), "OUTPUT", key, value)
  }

  predicate writeToGitHubPath(Run run, string value) {
    extractPathAssignment(run.getScript().splitAt("\n"), value)
  }
}

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

  string getNormalizedExpression() { result = Utils::normalizeExpr(expression) }
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

  predicate hasTriggerEvent(string trigger) { super.hasTriggerEvent(trigger) }

  string getATriggerEvent() { result = super.getATriggerEvent() }

  Permissions getPermissions() { result = super.getPermissions() }

  Strategy getStrategy() { result = super.getStrategy() }
}

class ReusableWorkflow extends Workflow instanceof ReusableWorkflowImpl {
  Outputs getOutputs() { result = super.getOutputs() }

  Expression getAnOutputExpr() { result = super.getAnOutputExpr() }

  Expression getOutputExpr(string outputName) { result = super.getOutputExpr(outputName) }

  Input getAnInput() { result = super.getAnInput() }

  Input getInput(string inputName) { result = super.getInput(inputName) }
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

  predicate hasTriggerEvent(string trigger) { super.hasTriggerEvent(trigger) }

  string getATriggerEvent() { result = super.getATriggerEvent() }

  Strategy getStrategy() { result = super.getStrategy() }

  predicate isPrivileged() { super.isPrivileged() }

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

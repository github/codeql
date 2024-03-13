private import codeql.actions.ast.internal.Yaml
private import codeql.Locations
private import codeql.actions.Ast::Utils as Utils

/**
 * Gets the length of each line in the StringValue .
 */
bindingset[text]
int lineLength(string text, int idx) {
  exists(string line | line = text.splitAt("\n", idx) and result = line.length() + 1)
}

/**
 * Gets the sum of the length of the lines up to the given index.
 */
bindingset[text]
int partialLineLengthSum(string text, int i) {
  i in [0 .. count(text.splitAt("\n"))] and
  result = sum(int j, int length | j in [0 .. i] and length = lineLength(text, j) | length)
}

/**
 * Holds if `${{ e }}` is a GitHub Actions expression evaluated within this YAML string.
 * See https://docs.github.com/en/free-pro-team@latest/actions/reference/context-and-expression-syntax-for-github-actions.
 * Only finds simple expressions like `${{ github.event.comment.body }}`, where the expression contains only alphanumeric characters, underscores, dots, or dashes.
 * Does not identify more complicated expressions like `${{ fromJSON(env.time) }}`, or ${{ format('{{Hello {0}!}}', github.event.head_commit.author.name) }}
 */
string getASimpleReferenceExpression(YamlString s, int offset) {
  // We use `regexpFind` to obtain *all* matches of `${{...}}`,
  // not just the last (greedy match) or first (reluctant match).
  result =
    s.getValue()
        .regexpFind("\\$\\{\\{\\s*[A-Za-z0-9_\\[\\]\\*\\(\\)\\.\\-]+\\s*\\}\\}", _, offset)
        .regexpCapture("(\\$\\{\\{\\s*[A-Za-z0-9_\\[\\]\\*\\((\\)\\.\\-]+\\s*\\}\\})", 1)
}

private newtype TAstNode =
  TExpressionNode(YamlNode key, YamlScalar value, string raw, int exprOffset) {
    raw = getASimpleReferenceExpression(value, exprOffset) and
    exists(YamlMapping m |
      (
        exists(int i | value = m.getValueNode(i) and key = m.getKeyNode(i))
        or
        exists(int i |
          m.getValueNode(i).(YamlSequence).getElementNode(_) = value and key = m.getKeyNode(i)
        )
      )
    )
    or
    // if's conditions do not need to be delimted with ${{}}
    exists(YamlMapping m |
      m.maps(key, value) and
      key.(YamlScalar).getValue() = ["if"] and
      value.getValue() = raw and
      exprOffset = 1
    )
  } or
  TCompositeAction(YamlMapping n) {
    n instanceof YamlDocument and
    n.getFile().getBaseName() = ["action.yml", "action.yaml"] and
    n.lookup("runs").(YamlMapping).lookup("using").(YamlScalar).getValue() = "composite"
  } or
  TWorkflowNode(YamlMapping n) {
    n instanceof YamlDocument and
    n.lookup("jobs") instanceof YamlMapping
  } or
  TRunsNode(YamlMapping n) { exists(CompositeActionImpl a | a.getNode().lookup("runs") = n) } or
  TInputsNode(YamlMapping n) { exists(YamlMapping m | m.lookup("inputs") = n) } or
  TInputNode(YamlValue n) { exists(YamlMapping m | m.lookup("inputs").(YamlMapping).maps(n, _)) } or
  TOutputsNode(YamlMapping n) { exists(YamlMapping m | m.lookup("outputs") = n) } or
  TPermissionsNode(YamlMapping n) { exists(YamlMapping m | m.lookup("permissions") = n) } or
  TStrategyNode(YamlMapping n) { exists(YamlMapping m | m.lookup("strategy") = n) } or
  TNeedsNode(YamlMappingLikeNode n) { exists(YamlMapping m | m.lookup("needs") = n) } or
  TJobNode(YamlMapping n) { exists(YamlMapping w | w.lookup("jobs").(YamlMapping).lookup(_) = n) } or
  TStepNode(YamlMapping n) {
    exists(YamlMapping m | m.lookup("steps").(YamlSequence).getElementNode(_) = n)
  } or
  TIfNode(YamlValue n) { exists(YamlMapping m | m.lookup("if") = n) } or
  TEnvNode(YamlMapping n) { exists(YamlMapping m | m.lookup("env") = n) } or
  TScalarValueNode(YamlScalar n) {
    exists(YamlMapping m | m.maps(_, n) or m.lookup(_).(YamlSequence).getElementNode(_) = n)
  }

abstract class AstNodeImpl extends TAstNode {
  abstract AstNodeImpl getAChildNode();

  abstract AstNodeImpl getParentNode();

  abstract string getAPrimaryQlClass();

  abstract Location getLocation();

  abstract YamlNode getNode();

  abstract string toString();

  /**
   * Gets the enclosing Job.
   */
  JobImpl getEnclosingJob() { result.getAChildNode*() = this.getParentNode() }

  /**
   * Gets the enclosing workflow statement.
   */
  WorkflowImpl getEnclosingWorkflow() { this = result.getAChildNode*() }

  /**
   * Gets a environment variable expression by name in the scope of the current node.
   */
  ExpressionImpl getInScopeEnvVarExpr(string name) {
    exists(EnvImpl env |
      env.getNode().maps(any(YamlScalar s | s.getValue() = name), result.getParentNode().getNode()) and
      env.getParentNode().getAChildNode*() = this
    )
  }
}

class ScalarValueImpl extends AstNodeImpl, TScalarValueNode {
  YamlScalar value;

  ScalarValueImpl() { this = TScalarValueNode(value) }

  override string toString() { result = value.getValue() }

  override ExpressionImpl getAChildNode() { result.getParentNode() = this }

  override AstNodeImpl getParentNode() {
    exists(AstNodeImpl n | n.getAChildNode() = this and result = n)
  }

  override string getAPrimaryQlClass() { result = "ScalarValueImpl" }

  override Location getLocation() { result = value.getLocation() }

  override YamlScalar getNode() { result = value }
}

class ExpressionImpl extends AstNodeImpl, TExpressionNode {
  YamlNode key;
  YamlString value;
  string rawExpression;
  string expression;
  int exprOffset;

  ExpressionImpl() {
    this = TExpressionNode(key, value, rawExpression, exprOffset - 1) and
    if rawExpression.trim().regexpMatch("\\$\\{\\{.*\\}\\}")
    then expression = rawExpression.trim().regexpCapture("\\$\\{\\{\\s*(.*)\\s*\\}\\}", 1).trim()
    else expression = rawExpression.trim()
  }

  override string toString() { result = expression }

  override AstNodeImpl getAChildNode() { none() }

  override ScalarValueImpl getParentNode() { result.getNode() = value }

  override string getAPrimaryQlClass() { result = "ExpressionNode" }

  override YamlNode getNode() { none() }

  string getExpression() { result = expression }

  string getRawExpression() { result = rawExpression }

  /**
   * Gets the absolute coordinates of the expression.
   */
  predicate expressionLocation(int sl, int sc, int el, int ec) {
    exists(int lineDiff, string text, string style, Location loc |
      text = value.getValue() and
      loc = value.getLocation() and
      lineDiff = loc.getEndLine() - loc.getStartLine() and
      style = value.getStyle()
    |
      // eg:
      //  - run: echo "hello"
      //  - run: 'echo "hello"'
      //  - run: "echo 'hello'"
      style = ["", "\"", "'"] and
      lineDiff = 0 and
      sl = loc.getStartLine() and
      el = sl and
      sc = loc.getStartColumn() + exprOffset and
      ec = sc + rawExpression.length() - 1
      or
      // eg:
      //  - run: "echo 'hello'
      //      echo 'hello'"
      //  - run: "echo 'hello'
      //     echo 'hello'
      //     echo 'hello'"
      style = ["", "\"", "'"] and
      lineDiff > 0 and
      sl = loc.getStartLine() and
      el = loc.getEndLine() and
      sc = loc.getStartColumn() and
      ec = loc.getEndColumn()
      or
      // eg:
      //  - run: |
      //      echo "hello"
      //  - run: |
      //      echo "hello"
      //      echo "bye"
      style = "|" and
      exists(int r |
        (
          r > 0 and
          partialLineLengthSum(text, r - 1) < exprOffset and
          partialLineLengthSum(text, r) >= exprOffset and
          sl = loc.getStartLine() + r + 1 and
          el = sl and
          sc =
            key.getLocation().getStartColumn() + exprOffset - partialLineLengthSum(text, r - 1) + 2 -
              1 and
          ec = sc + rawExpression.length() - 1
          or
          r = 0 and
          partialLineLengthSum(text, r) > exprOffset and
          sl = loc.getStartLine() + r + 1 and
          el = sl and
          sc = key.getLocation().getStartColumn() + 2 + exprOffset and
          ec = sc + rawExpression.length() - 1
        )
      )
      or
      // eg:
      //  - run: >
      //      echo "hello"
      //  - run: >
      //      echo "hello"
      //      echo "hello"
      style = ">" and
      sl = loc.getStartLine() + 1 and
      el = loc.getEndLine() and
      sc = key.getLocation().getStartColumn() and
      ec = loc.getEndColumn()
    )
  }

  override Location getLocation() {
    exists(Location loc |
      this.hasLocationInfo(loc.getFile().getAbsolutePath(), loc.getStartLine(),
        loc.getStartColumn(), loc.getEndLine(), loc.getEndColumn()) and
      result = loc
    )
  }

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = value.getFile().getAbsolutePath() and
    this.expressionLocation(sl, sc, el, ec)
  }
}

class CompositeActionImpl extends AstNodeImpl, TCompositeAction {
  YamlMapping n;

  CompositeActionImpl() { this = TCompositeAction(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() { none() }

  override string getAPrimaryQlClass() { result = "CompositeActionImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  RunsImpl getRuns() { result.getNode() = n.lookup("runs") }

  OutputsImpl getOutputs() { result.getNode() = n.lookup("outputs") }

  ExpressionImpl getAnOutputExpr() { result = this.getOutputs().getAnOutputExpr() }

  ExpressionImpl getOutputExpr(string name) { result = this.getOutputs().getOutputExpr(name) }

  InputsImpl getInputs() { result.getNode() = n.lookup("inputs") }

  InputImpl getAnInput() { n.lookup("inputs").(YamlMapping).maps(result.getNode(), _) }

  InputImpl getInput(string name) {
    n.lookup("inputs").(YamlMapping).maps(result.getNode(), _) and
    result.getNode().getValue() = name
  }
}

class WorkflowImpl extends AstNodeImpl, TWorkflowNode {
  YamlMapping n;

  WorkflowImpl() { this = TWorkflowNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() { none() }

  override string getAPrimaryQlClass() { result = "WorkflowImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  /** Gets the 'global' `env` mapping in this workflow. */
  EnvImpl getEnv() { result.getNode() = n.lookup("env") }

  /** Gets the name of the workflow. */
  string getName() { result = n.lookup("name").(YamlString).getValue() }

  /** Gets the job within this workflow with the given job ID. */
  JobImpl getJob(string jobId) { result.getWorkflow() = this and result.getId() = jobId }

  /** Gets a job within this workflow */
  JobImpl getAJob() { result = this.getJob(_) }

  /** Workflow is triggered by given trigger event */
  predicate hasTriggerEvent(string trigger) {
    exists(YamlNode y | y = n.lookup("on").(YamlMappingLikeNode).getNode(trigger))
  }

  /** Gets the trigger event that starts this workflow. */
  string getATriggerEvent() {
    exists(YamlNode y | y = n.lookup("on").(YamlMappingLikeNode).getNode(result))
  }

  /** Gets the permissions granted to this workflow. */
  PermissionsImpl getPermissions() { result.getNode() = n.lookup("permissions") }

  /** Gets the strategy for this workflow. */
  StrategyImpl getStrategy() { result.getNode() = n.lookup("strategy") }
}

class ReusableWorkflowImpl extends AstNodeImpl, WorkflowImpl {
  YamlValue workflow_call;

  ReusableWorkflowImpl() {
    n.lookup("on").(YamlMappingLikeNode).getNode("workflow_call") = workflow_call
  }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  OutputsImpl getOutputs() { result.getNode() = workflow_call.(YamlMapping).lookup("outputs") }

  ExpressionImpl getAnOutputExpr() { result = this.getOutputs().getAnOutputExpr() }

  ExpressionImpl getOutputExpr(string name) { result = this.getOutputs().getOutputExpr(name) }

  InputsImpl getInputs() { result.getNode() = workflow_call.(YamlMapping).lookup("inputs") }

  InputImpl getAnInput() {
    workflow_call.(YamlMapping).lookup("inputs").(YamlMapping).maps(result.getNode(), _)
  }

  InputImpl getInput(string name) {
    workflow_call.(YamlMapping).lookup("inputs").(YamlMapping).maps(result.getNode(), _) and
    result.getNode().(YamlString).getValue() = name
  }
}

class RunsImpl extends AstNodeImpl, TRunsNode {
  YamlMapping n;

  RunsImpl() { this = TRunsNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override CompositeActionImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "RunsImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  /** Gets the action that this `runs` mapping is in. */
  CompositeActionImpl getAction() { result = this.getParentNode() }

  /** Gets any steps that are defined within this job. */
  StepImpl getAStep() { result.getNode() = n.lookup("steps").(YamlSequence).getElementNode(_) }

  /** Gets the step at the given index within this job. */
  StepImpl getStep(int i) { result.getNode() = n.lookup("steps").(YamlSequence).getElementNode(i) }
}

class InputsImpl extends AstNodeImpl, TInputsNode {
  YamlMapping n;

  InputsImpl() { this = TInputsNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  //override AstNodeImpl getAChildNode() { result = this.getAnInput() }
  override AstNodeImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "InputsImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  InputImpl getAnInput() { n.maps(result.getNode(), _) }

  InputImpl getInput(string name) {
    n.maps(result.getNode(), _) and
    result.getNode().(YamlString).getValue() = name
  }
}

class InputImpl extends AstNodeImpl, TInputNode {
  YamlValue n;

  InputImpl() { this = TInputNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override InputsImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "InputImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlScalar getNode() { result = n }
}

class OutputsImpl extends AstNodeImpl, TOutputsNode {
  YamlMapping n;

  OutputsImpl() { this = TOutputsNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "OutputsImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  /** Gets an output expression. */
  ExpressionImpl getAnOutputExpr() { result = this.getOutputExpr(_) }

  /** Gets a specific output expression by name. */
  ExpressionImpl getOutputExpr(string name) {
    exists(YamlScalar l |
      l = result.getParentNode().getNode() and
      (
        n.lookup(name).(YamlMapping).lookup("value") = l or
        n.lookup(name) = l
      )
    )
  }

  string getAnOutputName() { n.maps(any(YamlString s | s.getValue() = result), _) }
}

class PermissionsImpl extends AstNodeImpl, TPermissionsNode {
  YamlMapping n;

  PermissionsImpl() { this = TPermissionsNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "PermissionsImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }
}

class StrategyImpl extends AstNodeImpl, TStrategyNode {
  YamlMapping n;

  StrategyImpl() { this = TStrategyNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "StrategyImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  /** Gets a specific matric expression (YamlMapping) by name. */
  ExpressionImpl getMatrixVarExpr(string name) {
    n.lookup("matrix").(YamlMapping).lookup(name) = result.getNode()
  }

  /** Gets a specific matric expression (YamlMapping) by name. */
  ExpressionImpl getAMatrixVarExpr() {
    n.lookup("matrix").(YamlMapping).lookup(_) = result.getNode()
  }
}

class NeedsImpl extends AstNodeImpl, TNeedsNode {
  YamlMappingLikeNode n;

  NeedsImpl() { this = TNeedsNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override JobImpl getParentNode() { result.getNode().lookup("needs") = n }

  override string getAPrimaryQlClass() { result = "NeedsImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMappingLikeNode getNode() { result = n }

  /** Gets a job that needs to be run before the job defining these needs. */
  JobImpl getANeededJob() {
    result.getId() = n.getNode(_).(YamlString).getValue() and
    result.getLocation().getFile() = n.getLocation().getFile()
  }
}

class JobImpl extends AstNodeImpl, TJobNode {
  YamlMapping n;
  string jobId;
  WorkflowImpl workflow;

  JobImpl() {
    this = TJobNode(n) and
    workflow.getNode().lookup("jobs").(YamlMapping).lookup(jobId) = n
  }

  override string toString() { result = "Job: " + jobId }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override WorkflowImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "JobImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  /** Gets the ID of this job, as a string. */
  string getId() { result = jobId }

  /** Gets the workflow this job belongs to. */
  WorkflowImpl getWorkflow() { result = workflow }

  EnvImpl getEnv() { result.getNode() = n.lookup("env") }

  /** Gets a needed job. */
  JobImpl getANeededJob() {
    exists(NeedsImpl needs |
      needs.getParentNode() = this and
      result = needs.getANeededJob()
    )
  }

  /** Gets the declaration of the outputs for the job. */
  OutputsImpl getOutputs() { result.getNode() = n.lookup("outputs") }

  /** Gets a Job output expression. */
  ExpressionImpl getAnOutputExpr() { result = this.getOutputs().getAnOutputExpr() }

  /** Gets a Job output expression given its name. */
  ExpressionImpl getOutputExpr(string name) { result = this.getOutputs().getOutputExpr(name) }

  /** Gets the condition that must be satisfied for this job to run. */
  IfImpl getIf() { result.getNode() = n.lookup("if") }

  /** Gets the permissions for this job. */
  PermissionsImpl getPermissions() { result.getNode() = n.lookup("permissions") }

  /** Gets the strategy for this job. */
  StrategyImpl getStrategy() { result.getNode() = n.lookup("strategy") }
}

class LocalJobImpl extends JobImpl {
  LocalJobImpl() { n.maps(any(YamlString s | s.getValue() = "steps"), _) }

  /** Gets any steps that are defined within this job. */
  StepImpl getAStep() { result.getNode() = n.lookup("steps").(YamlSequence).getElementNode(_) }

  /** Gets the step at the given index within this job. */
  StepImpl getStep(int i) { result.getNode() = n.lookup("steps").(YamlSequence).getElementNode(i) }
}

class StepImpl extends AstNodeImpl, TStepNode {
  YamlMapping n;

  StepImpl() { this = TStepNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override JobImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "StepImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  EnvImpl getEnv() { result.getNode() = n.lookup("env") }

  /** Gets the ID of this step, if any. */
  string getId() { result = n.lookup("id").(YamlString).getValue() }

  /** Gets the value of the `if` field in this step, if any. */
  IfImpl getIf() { result.getNode() = n.lookup("if") }
}

class IfImpl extends AstNodeImpl, TIfNode {
  YamlValue n;

  IfImpl() { this = TIfNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "IfImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlScalar getNode() { result = n }

  /** Gets the condition that must be satisfied for this job to run. */
  string getCondition() { result = n.(YamlScalar).getValue() }

  /** Gets the condition that must be satisfied for this job to run. */
  ExpressionImpl getConditionExpr() { result.getParentNode().getNode() = n }
}

class EnvImpl extends AstNodeImpl, TEnvNode {
  YamlMapping n;

  EnvImpl() { this = TEnvNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() {
    result.(JobImpl).getEnv() = this or
    result.(StepImpl).getEnv() = this or
    result.(WorkflowImpl).getEnv() = this
  }

  override string getAPrimaryQlClass() { result = "EnvImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  /** Gets an environment variable value given its name. */
  ScalarValueImpl getEnvVarValue(string name) { n.lookup(name) = result.getNode() }

  /** Gets an environment variable value. */
  ScalarValueImpl getAnEnvVarValue() { n.lookup(_) = result.getNode() }

  /** Gets an environment variable expressin given its name. */
  ExpressionImpl getEnvVarExpr(string name) { n.lookup(name) = result.getParentNode().getNode() }

  /** Gets an environment variable expression. */
  ExpressionImpl getAnEnvVarExpr() { n.lookup(_) = result.getParentNode().getNode() }
}

abstract class UsesImpl extends AstNodeImpl {
  abstract string getCallee();

  abstract string getVersion();

  abstract ExpressionImpl getArgumentExpr(string key);
}

/**
 * Gets a regular expression that parses an `owner/repo@version` reference within a `uses` field in an Actions job step.
 * The capture groups are:
 * 1: The owner of the repository where the Action comes from, e.g. `actions` in `actions/checkout@v2`
 * 2: The name of the repository where the Action comes from, e.g. `checkout` in `actions/checkout@v2`.
 * 3: The version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`.
 */
private string usesParser() { result = "([^/]+)/([^/@]+)@(.+)" }

/** A Uses step represents a call to an action that is defined in a GitHub repository. */
class UsesStepImpl extends StepImpl, UsesImpl {
  YamlScalar u;

  UsesStepImpl() { this.getNode().lookup("uses") = u }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  /** Gets the owner and name of the repository where the Action comes from, e.g. `actions/checkout` in `actions/checkout@v2`. */
  override string getCallee() {
    result =
      (
        u.getValue().regexpCapture(usesParser(), 1) + "/" +
          u.getValue().regexpCapture(usesParser(), 2)
      ).toLowerCase()
  }

  /** Gets the version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`. */
  override string getVersion() { result = u.getValue().regexpCapture(usesParser(), 3) }

  /** Gets the argument expression for the given key. */
  override ExpressionImpl getArgumentExpr(string key) {
    result.getParentNode().getNode() = n.lookup("with").(YamlMapping).lookup(key)
  }

  override string toString() {
    if exists(this.getId()) then result = "Uses Step: " + this.getId() else result = "Uses Step"
  }
}

/**
 * Gets a regular expression that parses an `owner/repo@version` reference within a `uses` field in an Actions job step.
 * local repo: octo-org/this-repo/.github/workflows/workflow-1.yml@172239021f7ba04fe7327647b213799853a9eb89
 * local repo: ./.github/workflows/workflow-2.yml
 * remote repo: octo-org/another-repo/.github/workflows/workflow.yml@v1
 */
private string repoUsesParser() { result = "([^/]+)/([^/]+)/([^@]+)@(.+)" }

private string pathUsesParser() { result = "\\./(.+)" }

class ExternalJobImpl extends JobImpl, UsesImpl {
  YamlScalar u;

  ExternalJobImpl() { n.lookup("uses") = u }

  override string getCallee() {
    if u.getValue().matches("./%")
    then result = u.getValue().regexpCapture(pathUsesParser(), 1)
    else
      result =
        u.getValue().regexpCapture(repoUsesParser(), 1) + "/" +
          u.getValue().regexpCapture(repoUsesParser(), 2) + "/" +
          u.getValue().regexpCapture(repoUsesParser(), 3)
  }

  /** Gets the version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`. */
  override string getVersion() {
    exists(YamlString name |
      n.lookup("uses") = name and
      if not name.getValue().matches("\\.%")
      then result = name.getValue().regexpCapture(repoUsesParser(), 4)
      else none()
    )
  }

  /** Gets the argument expression for the given key. */
  override ExpressionImpl getArgumentExpr(string key) {
    result.getParentNode().getNode() = n.lookup("with").(YamlMapping).lookup(key)
  }
}

class RunImpl extends StepImpl {
  YamlScalar script;

  RunImpl() { this.getNode().lookup("run") = script }

  string getScript() { result = script.getValue() }

  ExpressionImpl getAnScriptExpr() { result.getParentNode().getNode() = script }

  override string toString() {
    if exists(this.getId()) then result = "Run Step: " + this.getId() else result = "Run Step"
  }
}

/**
 * A ${{}} expression accessing a context variable such as steps, needs, jobs, env, inputs, or matrix.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 */
abstract class ContextExpressionImpl extends ExpressionImpl {
  abstract string getFieldName();

  abstract AstNodeImpl getTarget();
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
class StepsExpressionImpl extends ContextExpressionImpl {
  string stepId;
  string fieldName;

  StepsExpressionImpl() {
    Utils::normalizeExpr(expression).regexpMatch(stepsCtxRegex()) and
    stepId = Utils::normalizeExpr(expression).regexpCapture(stepsCtxRegex(), 1) and
    fieldName = Utils::normalizeExpr(expression).regexpCapture(stepsCtxRegex(), 2)
  }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() {
    this.getLocation().getFile() = result.getLocation().getFile() and
    result.(StepImpl).getId() = stepId
  }
}

/**
 * Holds for an expression accesing the `needs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ needs.job1.outputs.foo}}`
 */
class NeedsExpressionImpl extends ContextExpressionImpl {
  JobImpl neededJob;
  string fieldName;

  NeedsExpressionImpl() {
    Utils::normalizeExpr(expression).regexpMatch(needsCtxRegex()) and
    fieldName = Utils::normalizeExpr(expression).regexpCapture(needsCtxRegex(), 2) and
    neededJob.getId() = Utils::normalizeExpr(expression).regexpCapture(needsCtxRegex(), 1) and
    neededJob.getLocation().getFile() = this.getLocation().getFile()
  }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() {
    this.getEnclosingJob().getANeededJob() = neededJob and
    (
      // regular jobs
      neededJob.getOutputs() = result
      or
      // reusable workflow calling jobs
      neededJob.(ExternalJobImpl) = result
    )
  }
}

/**
 * Holds for an expression accesing the `jobs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ jobs.job1.outputs.foo}}` (within reusable workflows)
 */
class JobsExpressionImpl extends ContextExpressionImpl {
  string jobId;
  string fieldName;

  JobsExpressionImpl() {
    Utils::normalizeExpr(expression).regexpMatch(jobsCtxRegex()) and
    jobId = Utils::normalizeExpr(expression).regexpCapture(jobsCtxRegex(), 1) and
    fieldName = Utils::normalizeExpr(expression).regexpCapture(jobsCtxRegex(), 2)
  }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() {
    exists(JobImpl job |
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
class InputsExpressionImpl extends ContextExpressionImpl {
  string fieldName;

  InputsExpressionImpl() {
    Utils::normalizeExpr(expression).regexpMatch(inputsCtxRegex()) and
    fieldName = Utils::normalizeExpr(expression).regexpCapture(inputsCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() {
    result.getLocation().getFile() = this.getLocation().getFile() and
    (
      exists(ReusableWorkflowImpl w | w.getInput(fieldName) = result)
      or
      exists(CompositeActionImpl a | a.getInput(fieldName) = result)
    )
  }
}

/**
 * Holds for an expression accesing the `env` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ env.foo }}`
 */
class EnvExpressionImpl extends ContextExpressionImpl {
  string fieldName;

  EnvExpressionImpl() {
    Utils::normalizeExpr(expression).regexpMatch(envCtxRegex()) and
    fieldName = Utils::normalizeExpr(expression).regexpCapture(envCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() {
    exists(AstNodeImpl s |
      s.getInScopeEnvVarExpr(fieldName) = result and
      s.getAChildNode*() = this
    )
  }
}

/**
 * Holds for an expression accesing the `matrix` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ matrix.foo }}`
 */
class MatrixExpressionImpl extends ContextExpressionImpl {
  string fieldName;

  MatrixExpressionImpl() {
    Utils::normalizeExpr(expression).regexpMatch(matrixCtxRegex()) and
    fieldName = Utils::normalizeExpr(expression).regexpCapture(matrixCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() {
    exists(WorkflowImpl w |
      w.getStrategy().getMatrixVarExpr(fieldName) = result and
      w.getAChildNode*() = this
    )
    or
    exists(JobImpl j |
      j.getStrategy().getMatrixVarExpr(fieldName) = result and
      j.getAChildNode*() = this
    )
  }
}

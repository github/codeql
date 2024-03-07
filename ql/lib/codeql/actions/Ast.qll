private import codeql.actions.ast.internal.Yaml
private import codeql.Locations

newtype TAstNode =
  TWorflowNode(YamlNode n) or
  TExpressionNode(StringValue n, string expression, int exprOffset) {
    expression = getASimpleReferenceExpression(n, exprOffset)
  }

class AstNode extends TAstNode {
  abstract AstNode getAChildNode();

  abstract AstNode getParentNode();

  abstract string getAPrimaryQlClass();

  abstract string toString();

  abstract Location getLocation();

  abstract File getFile();

  /**
   * Gets the enclosing workflow statement.
   */
  Workflow getEnclosingWorkflow() { this = result.getAChildNode*() }

  /**
   * Gets a environment variable expression by name in the scope of the current node.
   */
  ExpressionNode getInScopeEnvVarExpr(string name) {
    exists(StringValue l, Env env |
      env.asYamlMapping().maps(any(YamlScalar s | s.getValue() = name), l.asYamlNode()) and
      l.getAnExpression() = result
    |
      env.(StepEnv).getStep().getAChildNode*() = this
      or
      env.(JobEnv).getJob().getAChildNode*() = this
      or
      env.(WorkflowEnv).getWorkflow().getAChildNode*() = this
    )
  }
}

class ExpressionNode extends AstNode, TExpressionNode {
  StringValue n;
  string rawExpression;
  string expression;
  int exprOffset;

  ExpressionNode() {
    this = TExpressionNode(n, rawExpression, exprOffset - 1) and
    expression =
      rawExpression.regexpCapture("\\$\\{\\{\\s*([A-Za-z0-9_\\[\\]\\*\\((\\)\\.\\-]+)\\s*\\}\\}", 1)
  }

  override string toString() { result = expression }

  override AstNode getAChildNode() { none() }

  override AstNode getParentNode() { result = n }

  override string getAPrimaryQlClass() { result = "ExpressionNode" }

  string getExpression() { result = expression }

  string getRawExpression() { result = rawExpression }

  Job getJob() { result.getAChildNode*() = n }

  /**
   * Gets the length of each line in the StringValue .
   */
  int lineLength(int idx) {
    exists(string line | line = n.getValue().splitAt("\n", idx) and result = line.length() + 1)
  }

  /**
   * Gets the sum of the length of the lines up to the given index.
   */
  int partialLineLengthSum(int i) {
    i in [0 .. count(n.getValue().splitAt("\n"))] and
    result = sum(int j, int length | j in [0 .. i] and length = this.lineLength(j) | length)
  }

  /**
   * Gets the absolute coordinates of the expression.
   */
  predicate expressionLocation(int sl, int sc, int el, int ec) {
    exists(int lineDiff, string style, Location loc |
      loc = n.asYamlNode().getLocation() and
      lineDiff = loc.getEndLine() - loc.getStartLine() and
      style = n.asYamlNode().(YamlString).getStyle()
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
          this.partialLineLengthSum(r - 1) < exprOffset and
          this.partialLineLengthSum(r) >= exprOffset and
          sl = loc.getStartLine() + r + 1 and
          el = sl and
          sc =
            n.getKeyNode().getLocation().getStartColumn() + exprOffset -
                  this.partialLineLengthSum(r - 1) + 2 - 1 and
          ec = sc + rawExpression.length() - 1
          or
          r = 0 and
          this.partialLineLengthSum(r) > exprOffset and
          sl = loc.getStartLine() + r + 1 and
          el = sl and
          sc = n.getKeyNode().getLocation().getStartColumn() + 2 + exprOffset and
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
      sc = n.getKeyNode().getLocation().getStartColumn() and
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
    path = n.asYamlNode().getFile().getAbsolutePath() and
    this.expressionLocation(sl, sc, el, ec)
  }

  override File getFile() { result = n.asYamlNode().getFile() }
}

/**
 * Base class for the AST tree. Based on YamlNode from the Yaml library.
 */
class WorkflowNode extends AstNode, TWorflowNode {
  YamlNode n;

  WorkflowNode() { this = TWorflowNode(n) }

  override AstNode getParentNode() { result = TWorflowNode(n.getParentNode()) }

  override AstNode getAChildNode() {
    result = TWorflowNode(n.getAChildNode())
    or
    exists(ExpressionNode e | e.getParentNode() = this | result = e)
  }

  override string getAPrimaryQlClass() { result = n.getAPrimaryQlClass() }

  override Location getLocation() { result = n.getLocation() }

  override File getFile() { result = n.getFile() }

  YamlNode asYamlNode() { result = n }

  YamlMapping asYamlMapping() { result = n }

  override string toString() { result = n.toString() }
}

/** A common class for `env` in workflow, job or step. */
abstract class Env extends WorkflowNode { }

/** A workflow level `env` mapping. */
class WorkflowEnv extends Env {
  Workflow workflow;

  WorkflowEnv() {
    n instanceof YamlMapping and
    workflow.asYamlMapping().lookup("env") = this.asYamlNode()
  }

  /** Gets the workflow this field belongs to. */
  Workflow getWorkflow() { result = workflow }
}

/** A job level `env` mapping. */
class JobEnv extends Env {
  Job job;

  JobEnv() { job.asYamlMapping().lookup("env") = this.asYamlNode() }

  /** Gets the job this field belongs to. */
  Job getJob() { result = job }
}

/** A step level `env` mapping. */
class StepEnv extends Env {
  Step step;

  StepEnv() { step.asYamlMapping().lookup("env") = this.asYamlNode() }

  /** Gets the step this field belongs to. */
  Step getStep() { result = step }
}

/**
 * A custom composite action. This is a mapping at the top level of an Actions YAML action file.
 * See https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions.
 */
class CompositeAction extends WorkflowNode {
  //class CompositeAction extends WorkflowNode, YamlDocument, YamlMapping {
  CompositeAction() {
    n instanceof YamlDocument and
    n instanceof YamlMapping and
    this.getFile().getBaseName() = ["action.yml", "action.yaml"] and
    this.asYamlMapping().lookup("runs").(YamlMapping).lookup("using").(YamlScalar).getValue() =
      "composite"
  }

  /** Gets the `runs` mapping. */
  Runs getRuns() { result.asYamlNode() = this.asYamlMapping().lookup("runs") }

  Outputs getOutputs() { result.asYamlNode() = this.asYamlMapping().lookup("outputs") }

  ExpressionNode getAnOutputExpr() { result = this.getOutputs().getAnOutputExpr() }

  ExpressionNode getOutputExpr(string name) { result = this.getOutputs().getOutputExpr(name) }

  Input getAnInput() {
    this.asYamlMapping().lookup("inputs").(YamlMapping).maps(result.asYamlNode(), _)
  }

  Input getInput(string name) {
    this.asYamlMapping().lookup("inputs").(YamlMapping).maps(result.asYamlNode(), _) and
    result.asYamlNode().(YamlString).getValue() = name
  }
}

/**
 * An `runs` mapping in a custom composite action YAML.
 * See https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions#runs
 */
class Runs extends WorkflowNode {
  CompositeAction action;

  Runs() {
    n instanceof YamlMapping and
    action.asYamlMapping().lookup("runs") = this.asYamlNode()
  }

  /** Gets the action that this `runs` mapping is in. */
  CompositeAction getAction() { result = action }

  /** Gets any steps that are defined within this job. */
  Step getAStep() {
    result.asYamlNode() = this.asYamlMapping().lookup("steps").(YamlSequence).getElementNode(_)
  }

  /** Gets the step at the given index within this job. */
  Step getStep(int i) {
    result.asYamlNode() = this.asYamlMapping().lookup("steps").(YamlSequence).getElementNode(i)
  }
}

/**
 * An Actions workflow. This is a mapping at the top level of an Actions YAML workflow file.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions.
 */
class Workflow extends WorkflowNode {
  Workflow() { n instanceof YamlDocument and n instanceof YamlMapping }

  /** Gets the `jobs` mapping from job IDs to job definitions in this workflow. */
  YamlMapping getJobs() { result = this.asYamlMapping().lookup("jobs") }

  /** Gets the 'global' `env` mapping in this workflow. */
  WorkflowEnv getEnv() { result.asYamlNode() = this.asYamlMapping().lookup("env") }

  /** Gets the name of the workflow. */
  string getName() { result = this.asYamlMapping().lookup("name").(YamlString).getValue() }

  /** Gets the job within this workflow with the given job ID. */
  Job getJob(string jobId) { result.getWorkflow() = this and result.getId() = jobId }

  /** Gets a job within this workflow */
  Job getAJob() { result = this.getJob(_) }

  predicate hasTriggerEvent(string trigger) {
    exists(YamlNode y |
      y = this.asYamlMapping().lookup("on").(YamlMappingLikeNode).getNode(trigger)
    )
  }

  string getATriggerEvent() {
    exists(YamlNode y | y = this.asYamlMapping().lookup("on").(YamlMappingLikeNode).getNode(result))
  }

  Permissions getPermissions() { result.asYamlNode() = this.asYamlMapping().lookup("permissions") }

  Strategy getStrategy() { result.asYamlNode() = this.asYamlMapping().lookup("strategy") }
}

class ReusableWorkflow extends Workflow {
  YamlValue workflow_call;

  ReusableWorkflow() {
    n instanceof YamlMapping and
    this.asYamlMapping().lookup("on").(YamlMappingLikeNode).getNode("workflow_call") = workflow_call
  }

  Outputs getOutputs() { result.asYamlNode() = workflow_call.(YamlMapping).lookup("outputs") }

  ExpressionNode getAnOutputExpr() { result = this.getOutputs().getAnOutputExpr() }

  ExpressionNode getOutputExpr(string name) { result = this.getOutputs().getOutputExpr(name) }

  Input getAnInput() {
    workflow_call.(YamlMapping).lookup("inputs").(YamlMapping).maps(result.asYamlNode(), _)
  }

  Input getInput(string name) {
    workflow_call.(YamlMapping).lookup("inputs").(YamlMapping).maps(result.asYamlNode(), _) and
    result.asYamlNode().(YamlString).getValue() = name
  }
}

class Input extends WorkflowNode {
  YamlMapping parent;

  Input() { parent.lookup("inputs").(YamlMapping).maps(this.asYamlNode(), _) }
}

class Outputs extends WorkflowNode {
  YamlMapping parent;

  Outputs() {
    n instanceof YamlMapping and
    parent.lookup("outputs") = this.asYamlNode()
  }

  /**
   * Gets an output expression.
   */
  ExpressionNode getAnOutputExpr() { result = this.getOutputExpr(_) }

  /**
   * Gets a specific output expression by name.
   */
  ExpressionNode getOutputExpr(string name) {
    exists(StringValue l |
      l.getAnExpression() = result and
      (
        this.asYamlMapping().lookup(name).(YamlMapping).lookup("value") = l.asYamlNode() or
        this.asYamlMapping().lookup(name) = l.asYamlNode()
      )
    )
  }

  string getAnOutputName() {
    this.asYamlMapping().maps(any(YamlString s | s.getValue() = result), _)
  }

  override string toString() { result = "Job outputs node" }
}

class Permissions extends WorkflowNode {
  YamlMapping parent;

  Permissions() {
    n instanceof YamlMapping and
    parent.lookup("permissions") = this.asYamlNode()
  }
}

class Strategy extends WorkflowNode {
  YamlMapping parent;

  Strategy() {
    n instanceof YamlMapping and
    parent.lookup("strategy") = this.asYamlNode()
  }

  /**
   * Gets a specific matric expression (YamlMapping) by name.
   */
  StringValue getMatrixVar(string name) {
    this.asYamlMapping().lookup("matrix").(YamlMapping).lookup(name) = result.asYamlNode()
  }

  /**
   * Gets a specific matric expression (YamlMapping) by name.
   */
  StringValue getAMatrixVar() {
    this.asYamlMapping().lookup("matrix").(YamlMapping).lookup(_) = result.asYamlNode()
  }
}

/**
 * https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idneeds
 */
class Needs extends WorkflowNode {
  Job job;

  Needs() {
    n instanceof YamlMappingLikeNode and
    job.asYamlMapping().lookup("needs") = this.asYamlNode()
  }

  Job getJob() { result = job }

  Job getANeededJob() {
    result.getId() = this.asYamlNode().(YamlMappingLikeNode).getNode(_).(YamlString).getValue() and
    result.getFile() = job.getFile()
  }
}

/**
 * An Actions job within a workflow.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobs.
 */
class Job extends WorkflowNode {
  string jobId;
  Workflow workflow;

  Job() {
    n instanceof YamlMapping and
    this.asYamlNode() = workflow.getJobs().lookup(jobId)
  }

  /**
   * Gets the ID of this job, as a string.
   * This is the job's key within the `jobs` mapping.
   */
  string getId() { result = jobId }

  /** Gets any steps that are defined within this job. */
  Step getAStep() {
    result.asYamlNode() = this.asYamlMapping().lookup("steps").(YamlSequence).getElementNode(_)
  }

  /** Gets the step at the given index within this job. */
  Step getStep(int i) {
    result.asYamlNode() = this.asYamlMapping().lookup("steps").(YamlSequence).getElementNode(i)
  }

  /** Gets the workflow this job belongs to. */
  Workflow getWorkflow() { result = workflow }

  /**
   * Gets a needed job.
   * eg:
   *     - needs: [job1, job2]
   */
  Job getANeededJob() {
    exists(Needs needs |
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
  Outputs getOutputs() { result.asYamlNode() = this.asYamlMapping().lookup("outputs") }

  ExpressionNode getAnOutputExpr() { result = this.getOutputs().getAnOutputExpr() }

  ExpressionNode getOutputExpr(string name) { result = this.getOutputs().getOutputExpr(name) }

  /**
   * Reusable workflow jobs may have Uses children
   * eg:
   * call-job:
   *   uses: ./.github/workflows/reusable_workflow.yml
   *   with:
   *     arg1: value1
   */
  UsesJob getUses() { result.getJob() = this }

  predicate usesReusableWorkflow() {
    this.asYamlMapping().maps(any(YamlString s | s.getValue() = "uses"), _)
  }

  If getIf() { result.asYamlNode() = this.asYamlMapping().lookup("if") }

  Permissions getPermissions() { result.asYamlNode() = this.asYamlMapping().lookup("permissions") }

  Strategy getStrategy() { result.asYamlNode() = this.asYamlMapping().lookup("strategy") }

  override string toString() { result = "Job: " + jobId }
}

/**
 * A step within an Actions job.
 * See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idsteps.
 */
class Step extends WorkflowNode {
  YamlMapping parent;

  Step() { parent.lookup("steps").(YamlSequence).getElementNode(_) = this.asYamlNode() }

  /** Gets the ID of this step, if any. */
  string getId() { result = this.asYamlMapping().lookup("id").(YamlString).getValue() }

  /** Gets the `job` this step belongs to, if the step belongs to a `job` in a workflow. Has no result if the step belongs to `runs` in a custom composite action. */
  Job getJob() { result.asYamlNode() = parent }

  /** Gets the value of the `if` field in this step, if any. */
  If getIf() { result.asYamlNode() = this.asYamlMapping().lookup("if") }
}

/**
 * An If node representing a conditional statement.
 */
class If extends WorkflowNode {
  WorkflowNode parent;

  If() {
    (parent instanceof Step or parent instanceof Job) and
    parent.asYamlMapping().lookup("if") = this.asYamlNode()
  }

  WorkflowNode getEnclosingNode() { result = parent }

  string getCondition() { result = this.asYamlNode().(YamlScalar).getValue() }
}

/**
 * Abstract class representing a call to a 3rd party action or reusable workflow.
 */
abstract class Uses extends WorkflowNode {
  abstract string getCallee();

  abstract string getVersion();

  abstract ExpressionNode getArgumentExpr(string key);

  override string toString() { result = "Uses Step" }
}

/**
 * Gets a regular expression that parses an `owner/repo@version` reference within a `uses` field in an Actions job step.
 * The capture groups are:
 * 1: The owner of the repository where the Action comes from, e.g. `actions` in `actions/checkout@v2`
 * 2: The name of the repository where the Action comes from, e.g. `checkout` in `actions/checkout@v2`.
 * 3: The version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`.
 */
private string usesParser() { result = "([^/]+)/([^/@]+)@(.+)" }

/**
 * A Uses step represents a call to an action that is defined in a GitHub repository.
 */
class UsesStep extends Step, Uses {
  YamlScalar uses;

  UsesStep() { this.asYamlMapping().maps(any(YamlScalar s | s.getValue() = "uses"), uses) }

  /** Gets the owner and name of the repository where the Action comes from, e.g. `actions/checkout` in `actions/checkout@v2`. */
  override string getCallee() {
    result =
      (
        uses.getValue().regexpCapture(usesParser(), 1) + "/" +
          uses.getValue().regexpCapture(usesParser(), 2)
      ).toLowerCase()
  }

  /** Gets the version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`. */
  override string getVersion() { result = uses.getValue().regexpCapture(usesParser(), 3) }

  override Expression getArgumentExpr(string key) {
    exists(StringValue l |
      l.asYamlNode() = this.asYamlMapping().lookup("with").(YamlMapping).lookup(key) and
      result = l.getAnExpression()
    )
  }

  override string toString() {
    if exists(this.getId()) then result = "Uses Step: " + this.getId() else result = "Uses Step"
  }
}

/**
 * A Uses step represents a call to an action that is defined in a GitHub repository.
 */
class UsesJob extends Uses {
  UsesJob() {
    this instanceof Job and
    this.asYamlMapping().maps(any(YamlString s | s.getValue() = "uses"), _)
  }

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
      this.asYamlMapping().lookup("uses") = name and
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
      this.asYamlMapping().lookup("uses") = name and
      if not name.getValue().matches("\\.%")
      then result = name.getValue().regexpCapture(this.repoUsesParser(), 4)
      else none()
    )
  }

  override ExpressionNode getArgumentExpr(string key) {
    exists(StringValue l |
      this.asYamlMapping().lookup("with").(YamlMapping).lookup(key) = l.asYamlNode() and
      result = l.getAnExpression()
    )
  }
}

/**
 * A `run` field within an Actions job step, which runs command-line programs using an operating system shell.
 * See https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepsrun.
 */
class Run extends Step {
  StringValue script;

  Run() { this.asYamlMapping().maps(any(YamlString s | s.getValue() = "run"), script.asYamlNode()) }

  StringValue getScript() { result = script }

  override string toString() {
    if exists(this.getId()) then result = "Run Step: " + this.getId() else result = "Run Step"
  }
}

/**
 * A YamlString part of a YamlSequence or YamlMapping values.
 */
class StringValue extends WorkflowNode {
  YamlNode keyNode;

  StringValue() {
    n instanceof YamlString and
    exists(YamlCollection c |
      c = keyNode and
      (
        c instanceof YamlMapping and
        //c.(YamlMapping).maps(_, this.asYamlNode())
        exists(int i | this.asYamlNode() = c.(YamlMapping).getValueNode(i))
        or
        c instanceof YamlSequence and
        c.(YamlSequence).getElementNode(_) = this.asYamlNode()
      )
    )
  }

  string getValue() { result = this.asYamlNode().(YamlString).getValue() }

  YamlNode getKeyNode() { result = keyNode }

  ExpressionNode getAnExpression() { result = this.getAChildNode() }
}

/**
 * Holds if `${{ e }}` is a GitHub Actions expression evaluated within this YAML string.
 * See https://docs.github.com/en/free-pro-team@latest/actions/reference/context-and-expression-syntax-for-github-actions.
 * Only finds simple expressions like `${{ github.event.comment.body }}`, where the expression contains only alphanumeric characters, underscores, dots, or dashes.
 * Does not identify more complicated expressions like `${{ fromJSON(env.time) }}`, or ${{ format('{{Hello {0}!}}', github.event.head_commit.author.name) }}
 */
string getASimpleReferenceExpression(StringValue node, int offset) {
  // We use `regexpFind` to obtain *all* matches of `${{...}}`,
  // not just the last (greedy match) or first (reluctant match).
  result =
    node.getValue()
        .regexpFind("\\$\\{\\{\\s*[A-Za-z0-9_\\[\\]\\*\\(\\)\\.\\-]+\\s*\\}\\}", _, offset)
        .regexpCapture("(\\$\\{\\{\\s*[A-Za-z0-9_\\[\\]\\*\\((\\)\\.\\-]+\\s*\\}\\})", 1)
}

class Expression extends ExpressionNode { }

/**
 * A ${{}} expression accessing a context variable such as steps, needs, jobs, env, inputs, or matrix.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 */
class ContextExpression extends Expression {
  ContextExpression() {
    expression
        .regexpMatch([
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
    expression.regexpMatch(stepsCtxRegex()) and
    stepId = expression.regexpCapture(stepsCtxRegex(), 1) and
    fieldName = expression.regexpCapture(stepsCtxRegex(), 2)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    this.getFile() = result.getFile() and
    result.(Step).getId() = stepId
  }
}

/**
 * Holds for an expression accesing the `needs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ needs.job1.outputs.foo}}`
 */
class NeedsExpression extends ContextExpression {
  Job neededJob;
  string neededJobId;
  string fieldName;

  NeedsExpression() {
    expression.regexpMatch(needsCtxRegex()) and
    neededJobId = expression.regexpCapture(needsCtxRegex(), 1) and
    fieldName = expression.regexpCapture(needsCtxRegex(), 2) and
    neededJob.getId() = neededJobId
  }

  predicate usesReusableWorkflow() { neededJob.usesReusableWorkflow() }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    neededJob.getFile() = this.getFile() and
    this.getJob().getANeededJob() = neededJob and
    (
      // regular jobs
      neededJob.getOutputs() = result
      or
      // reusable workflow calling jobs
      neededJob.getUses() = result
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
    expression.regexpMatch(jobsCtxRegex()) and
    jobId = expression.regexpCapture(jobsCtxRegex(), 1) and
    fieldName = expression.regexpCapture(jobsCtxRegex(), 2)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    exists(Job job |
      job.getId() = jobId and
      job.getFile() = this.getFile() and
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
    expression.regexpMatch(inputsCtxRegex()) and
    fieldName = expression.regexpCapture(inputsCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    result.getFile() = this.getFile() and
    (
      exists(ReusableWorkflow w | w.getInput(fieldName) = result)
      or
      exists(CompositeAction a | a.getInput(fieldName) = result)
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
    expression.regexpMatch(envCtxRegex()) and
    fieldName = expression.regexpCapture(envCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    exists(WorkflowNode s |
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
class MatrixExpression extends ContextExpression {
  string fieldName;

  MatrixExpression() {
    expression.regexpMatch(matrixCtxRegex()) and
    fieldName = expression.regexpCapture(matrixCtxRegex(), 1)
  }

  override string getFieldName() { result = fieldName }

  override AstNode getTarget() {
    exists(Workflow w |
      w.getStrategy().getMatrixVar(fieldName) = result and
      w.getAChildNode*() = this
    )
    or
    exists(Job j |
      j.getStrategy().getMatrixVar(fieldName) = result and
      j.getAChildNode*() = this
    )
  }
}

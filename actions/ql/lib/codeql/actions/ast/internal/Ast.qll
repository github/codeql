private import codeql.actions.ast.internal.Yaml
private import codeql.Locations
private import codeql.actions.Helper
private import codeql.actions.config.Config
private import codeql.actions.DataFlow

bindingset[text]
int numberOfLines(string text) { result = max(int i | exists(text.splitAt("\n", i))) }

/**
 * Gets the length of each line in the StringValue .
 */
bindingset[text]
int lineLength(string text, int i) { result = text.splitAt("\n", i).length() + 1 }

/**
 * Gets the sum of the length of the lines up to the given index.
 */
bindingset[text]
int partialLineLengthSum(string text, int i) {
  i in [0 .. numberOfLines(text)] and
  result = sum(int j, int length | j in [0 .. i] and length = lineLength(text, j) | length)
}

string getADelimitedExpression(YamlString s, int offset) {
  // We use `regexpFind` to obtain *all* matches of `${{...}}`,
  // not just the last (greedy match) or first (reluctant match).
  result =
    s.getValue()
        .regexpFind("\\$\\{\\{(?:[^}]|}(?!}))*\\}\\}", _, offset)
        .regexpCapture("(\\$\\{\\{(?:[^}]|}(?!}))*\\}\\})", 1)
        .trim()
}

private newtype TAstNode =
  TExpressionNode(YamlNode key, YamlScalar value, string raw, int exprOffset) {
    raw = getADelimitedExpression(value, exprOffset) and
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
    // `if`'s conditions do not need to be delimted with ${{}}
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
  TDefaultsNode(YamlMapping n) { exists(YamlMapping m | m.lookup("defaults") = n) } or
  TInputsNode(YamlMapping n) { exists(YamlMapping m | m.lookup("inputs") = n) } or
  TInputNode(YamlValue n) { exists(YamlMapping m | m.lookup("inputs").(YamlMapping).maps(n, _)) } or
  TOutputsNode(YamlMapping n) { exists(YamlMapping m | m.lookup("outputs") = n) } or
  TPermissionsNode(YamlMappingLikeNode n) { exists(YamlMapping m | m.lookup("permissions") = n) } or
  TStrategyNode(YamlMapping n) { exists(YamlMapping m | m.lookup("strategy") = n) } or
  TNeedsNode(YamlMappingLikeNode n) { exists(YamlMapping m | m.lookup("needs") = n) } or
  TJobNode(YamlMapping n) { exists(YamlMapping w | w.lookup("jobs").(YamlMapping).lookup(_) = n) } or
  TOnNode(YamlMappingLikeNode n) { exists(YamlMapping w | w.lookup("on") = n) } or
  TEventNode(YamlScalar event, YamlMappingLikeNode n) {
    exists(OnImpl o |
      o.getNode().(YamlMapping).maps(event, n)
      or
      o.getNode().(YamlSequence).getAChildNode() = event and event = n
      or
      o.getNode().(YamlScalar) = n and event = n
    )
  } or
  TStepNode(YamlMapping n) {
    exists(YamlMapping m | m.lookup("steps").(YamlSequence).getElementNode(_) = n)
  } or
  TIfNode(YamlValue n) { exists(YamlMapping m | m.lookup("if") = n) } or
  TEnvironmentNode(YamlValue n) { exists(YamlMapping m | m.lookup("environment") = n) } or
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
  JobImpl getEnclosingJob() {
    result.getAChildNode*() = this.getParentNode() or
    result = this.getEnclosingCompositeAction().getACallerJob()
  }

  /**
   * Gets and Event triggering this node.
   */
  EventImpl getATriggerEvent() {
    result = this.getEnclosingJob().getATriggerEvent()
    or
    not exists(this.getEnclosingJob()) and result = this.getEnclosingWorkflow().getATriggerEvent()
  }

  /**
   * Gets the enclosing Step.
   */
  StepImpl getEnclosingStep() {
    if this instanceof StepImpl
    then result = this
    else
      if this instanceof ScalarValueImpl
      then result.getAChildNode*() = this.getParentNode()
      else none()
  }

  /**
   * Gets the enclosing workflow if any.
   */
  WorkflowImpl getEnclosingWorkflow() { this = result.getAChildNode*() }

  /**
   * Gets the enclosing composite action if any.
   */
  CompositeActionImpl getEnclosingCompositeAction() { this = result.getAChildNode*() }

  /**
   * Gets a environment variable expression by name in the scope of the current node.
   */
  ExpressionImpl getInScopeEnvVarExpr(string name) {
    exists(EnvImpl env |
      env.getNode().maps(any(YamlScalar s | s.getValue() = name), result.getParentNode().getNode()) and
      env.getParentNode().getAChildNode*() = this
    )
  }

  ScalarValueImpl getInScopeDefaultValue(string name, string prop) {
    exists(DefaultsImpl dft |
      this.getEnclosingJob().getNode().(YamlMapping).maps(_, dft.getNode()) and
      result = dft.getValue(name, prop)
    )
    or
    not exists(DefaultsImpl dft | this.getEnclosingJob() = dft.getParentNode()) and
    exists(DefaultsImpl dft |
      this.getEnclosingWorkflow().getNode().(YamlMapping).maps(_, dft.getNode()) and
      result = dft.getValue(name, prop)
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

  string getValue() { result = value.getValue() }
}

class ShellScriptImpl extends ScalarValueImpl {
  ShellScriptImpl() { exists(YamlMapping run | run.lookup("run").(YamlScalar) = this.getNode()) }

  string getRawScript() { result = this.getValue().regexpReplaceAll("\\\\\\s*\n", "") }

  RunImpl getEnclosingRun() { result.getNode().lookup("run") = this.getNode() }

  abstract string getStmt(int i);

  abstract string getAStmt();

  abstract string getCommand(int i);

  string getACommand() {
    if this.getEnclosingRun().getShell().matches("bash%")
    then result = this.(BashShellScript).getACommand()
    else
      if this.getEnclosingRun().getShell().matches("pwsh%")
      then result = this.(PowerShellScript).getACommand()
      else result = "NOT IMPLEMENTED"
  }

  abstract string getFileReadCommand(int i);

  abstract string getAFileReadCommand();

  abstract predicate getAssignment(int i, string name, string data);

  abstract predicate getAnAssignment(string name, string data);

  abstract predicate getAWriteToGitHubEnv(string name, string data);

  abstract predicate getAWriteToGitHubOutput(string name, string data);

  abstract predicate getAWriteToGitHubPath(string data);

  abstract predicate getAnEnvReachingGitHubOutputWrite(string var, string output_field);

  abstract predicate getACmdReachingGitHubOutputWrite(string cmd, string output_field);

  abstract predicate getAnEnvReachingGitHubEnvWrite(string var, string output_field);

  abstract predicate getACmdReachingGitHubEnvWrite(string cmd, string output_field);

  abstract predicate getAnEnvReachingGitHubPathWrite(string var);

  abstract predicate getACmdReachingGitHubPathWrite(string cmd);

  abstract predicate getAnEnvReachingArgumentInjectionSink(
    string var, string command, string argument
  );

  abstract predicate getACmdReachingArgumentInjectionSink(
    string cmd, string command, string argument
  );

  abstract predicate fileToGitHubEnv(string path);

  abstract predicate fileToGitHubOutput(string path);

  abstract predicate fileToGitHubPath(string path);
}

class ExpressionImpl extends AstNodeImpl, TExpressionNode {
  YamlNode key;
  YamlString value;
  string rawExpression;
  string fullExpression;
  int exprOffset;

  ExpressionImpl() {
    this = TExpressionNode(key, value, rawExpression, exprOffset - 1) and
    if rawExpression.trim().regexpMatch("\\$\\{\\{.*\\}\\}")
    then
      fullExpression = rawExpression.trim().regexpCapture("\\$\\{\\{\\s*(.*)\\s*\\}\\}", 1).trim()
    else fullExpression = rawExpression.trim()
  }

  override string toString() { result = fullExpression }

  override AstNodeImpl getAChildNode() { none() }

  override ScalarValueImpl getParentNode() { result.getNode() = value }

  override string getAPrimaryQlClass() { result = "ExpressionImpl" }

  override YamlNode getNode() { none() }

  string getExpression() { result = fullExpression }

  string getFullExpression() { result = fullExpression }

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

  LocalJobImpl getACallerJob() { result = this.getACallerStep().getEnclosingJob() }

  UsesStepImpl getACallerStep() {
    exists(DataFlow::CallNode call |
      call.getCalleeNode() = this and
      result = call.getCfgNode().getAstNode()
    )
  }

  string getResolvedPath() {
    result =
      ["", "./"] +
        this.getLocation()
            .getFile()
            .getRelativePath()
            .replaceAll(getRepoRoot(), "")
            .replaceAll("/action.yml", "")
            .replaceAll("/action.yaml", "")
            .replaceAll(".github/actions/external/", "")
  }

  private predicate hasExplicitSecretAccess() {
    // the job accesses a secret other than GITHUB_TOKEN
    exists(SecretsExpressionImpl expr |
      expr.getEnclosingCompositeAction() = this and not expr.getFieldName() = "GITHUB_TOKEN"
    )
  }

  private predicate hasExplicitWritePermission() {
    // a calling job has an explicit write permission
    this.getACallerJob().getPermissions().getAPermission().matches("%write")
  }

  /** Holds if the action is privileged. */
  predicate isPrivileged() {
    // there is a calling job that defines explicit write permissions
    this.hasExplicitWritePermission()
    or
    // the actions has an explicit secret accesses
    this.hasExplicitSecretAccess()
    or
    // there is a privileged caller job
    (
      this.getACallerJob().isPrivileged()
      or
      not this.getACallerJob().isPrivileged() and
      this.getACallerJob().getATriggerEvent().isPrivileged()
    )
  }

  override EventImpl getATriggerEvent() { result = this.getACallerJob().getATriggerEvent() }
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

  /** Gets the `on` trigger events for this workflow. */
  OnImpl getOn() { result.getNode() = n.lookup("on") }

  /** Gets the 'global' `env` mapping in this workflow. */
  EnvImpl getEnv() { result.getNode() = n.lookup("env") }

  /** Gets the name of the workflow. */
  string getName() { result = n.lookup("name").(YamlString).getValue() }

  /** Gets the job within this workflow with the given job ID. */
  JobImpl getJob(string jobId) { result.getEnclosingWorkflow() = this and result.getId() = jobId }

  /** Gets a job within this workflow */
  JobImpl getAJob() { result.getEnclosingWorkflow() = this }

  /** Gets the permissions granted to this workflow. */
  PermissionsImpl getPermissions() { result.getNode() = n.lookup("permissions") }

  /** Gets the trigger event that starts this workflow. */
  override EventImpl getATriggerEvent() { this.getOn().getAnEvent() = result }

  /** Gets the strategy for this workflow. */
  StrategyImpl getStrategy() { result.getNode() = n.lookup("strategy") }
}

class ReusableWorkflowImpl extends AstNodeImpl, WorkflowImpl {
  YamlValue workflow_call;

  ReusableWorkflowImpl() {
    n.lookup("on").(YamlMappingLikeNode).getNode("workflow_call") = workflow_call
  }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override EventImpl getATriggerEvent() {
    // The trigger event for a reusable workflow is the trigger event of the caller workflow
    this.getACaller().getEnclosingWorkflow().getOn().getAnEvent() = result
    or
    // or the trigger event of the workflow if it has any other than workflow_call
    this.getOn().getAnEvent() = result and not result.getName() = "workflow_call"
  }

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

  ExternalJobImpl getACaller() {
    exists(DataFlow::CallNode call |
      call.getCalleeNode() = this and
      result = call.getCfgNode().getAstNode()
    )
  }

  string getResolvedPath() {
    result =
      ["", "./"] +
        this.getLocation()
            .getFile()
            .getRelativePath()
            .replaceAll(getRepoRoot(), "")
            .replaceAll(".github/workflows/external/", "")
  }
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

class DefaultsImpl extends AstNodeImpl, TDefaultsNode {
  YamlMapping n;

  DefaultsImpl() { this = TDefaultsNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "DefaultsImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  ScalarValueImpl getValue(string name, string prop) {
    n.lookup(name).(YamlMapping).lookup(prop) = result.getNode()
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
  YamlMappingLikeNode n;

  PermissionsImpl() { this = TPermissionsNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "PermissionsImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMappingLikeNode getNode() { result = n }

  string getAScope() {
    result =
      [
        "actions", "attestations", "checks", "contents", "deployments", "discussions", "id-token",
        "issues", "packages", "pages", "pull-requests", "repository-projects", "security-events",
        "statuses"
      ]
  }

  string getAPermission() {
    exists(YamlMapping mapping, string scope |
      mapping = n and
      result = scope + ": " + mapping.lookup(scope).(YamlScalar).getValue()
    )
    or
    exists(YamlScalar scalar |
      scalar = n and
      (
        scalar.getValue() = "write-all" and
        result = this.getAScope() + ":write"
        or
        scalar.getValue() = "read-all" and
        result = this.getAScope() + ":read"
      )
    )
  }

  bindingset[perm]
  string getPermission(string perm) {
    exists(string p |
      p = this.getAPermission() and p.matches(perm + ":%") and result = p.splitAt(":", 1).trim()
    )
  }
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

  YamlMapping getMatrix() { result = n.lookup("matrix") }

  /** Gets a specific matrix expression (YamlMapping) by name. */
  ExpressionImpl getMatrixVarExpr(string accessPath) {
    exists(MatrixAccessPathImpl p, ScalarValueImpl v |
      p.toString() = accessPath and
      resolveMatrixAccessPath(n.lookup("matrix"), p).getNode(_) = v.getNode() and
      result.getParentNode() = v
    )
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

class OnImpl extends AstNodeImpl, TOnNode {
  YamlMappingLikeNode n;

  OnImpl() { this = TOnNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override WorkflowImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "OnImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMappingLikeNode getNode() { result = n }

  /** Gets an event that triggers the workflow. */
  EventImpl getAnEvent() { result.getParentNode() = this }
}

class EventImpl extends AstNodeImpl, TEventNode {
  YamlScalar e;
  YamlMappingLikeNode n;

  EventImpl() { this = TEventNode(e, n) }

  override string toString() { result = e.getValue() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override OnImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "EventImpl" }

  override Location getLocation() { result = e.getLocation() }

  override YamlScalar getNode() { result = e }

  /** Gets the name of the event that triggers the workflow. */
  string getName() { result = e.getValue() }

  /** Gets the Yaml Node associated with the event if any */
  YamlMappingLikeNode getValueNode() { result = n }

  /** Gets an activity type */
  string getAnActivityType() {
    result =
      n.(YamlMapping).lookup("types").(YamlMappingLikeNode).getNode(_).(YamlScalar).getValue()
  }

  /** Gets a string value for any property (eg: branches, branches-ignore, etc.) */
  string getAPropertyValue(string prop) {
    result = n.(YamlMapping).lookup(prop).(YamlMappingLikeNode).getNode(_).(YamlScalar).getValue()
  }

  /** Holds if the event has a property with the given name */
  predicate hasProperty(string prop) { exists(this.getAPropertyValue(prop)) }

  /** Holds if the event can be triggered by an external actor. */
  predicate isExternallyTriggerable() {
    // the job is triggered by an event that can be triggered externally
    // except for workflow_run which requires additional checks
    externallyTriggerableEventsDataModel(this.getName()) and
    not this.getName() = "workflow_run"
    or
    this.getName() = "workflow_run" and
    // workflow_run cannot be externally triggered if the triggering workflow runs in the context of the default branch
    // An attacker can change the triggering workflow from any event to `pull_request` to trigger the workflow
    // in that case, the triggering workflow will run in the context of the PR head branch
    not exists(this.getAPropertyValue("branches"))
    or
    // the event is `workflow_call` and there is a caller workflow that can be triggered externally
    this.getName() = "workflow_call" and
    (
      // there are hints that this workflow is meant to be called by external triggers
      exists(ExpressionImpl expr, string external_trigger |
        expr.getEnclosingWorkflow() = this.getEnclosingWorkflow() and
        expr.getExpression().matches("%github.event" + external_trigger + "%") and
        externallyTriggerableEventsDataModel(external_trigger)
      )
      or
      this.getEnclosingWorkflow()
          .(ReusableWorkflowImpl)
          .getACaller()
          .getATriggerEvent()
          .isExternallyTriggerable()
    )
  }

  predicate isPrivileged() {
    // the Job is triggered by an event other than `pull_request`, or `workflow_call`
    not this.getName() = "pull_request" and
    not this.getName() = "workflow_call"
    or
    // Reusable Workflow with a privileged caller or we cant find a caller
    this.getName() = "workflow_call" and
    (
      this.getEnclosingWorkflow().(ReusableWorkflowImpl).getACaller().isPrivileged() or
      not exists(this.getEnclosingWorkflow().(ReusableWorkflowImpl).getACaller())
    )
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

  /** Gets the deployment environment to run the job on. */
  EnvironmentImpl getEnvironment() { result.getNode() = n.lookup("environment") }

  /** Gets the permissions for this job. */
  PermissionsImpl getPermissions() { result.getNode() = n.lookup("permissions") }

  /** Gets the strategy for this job. */
  StrategyImpl getStrategy() { result.getNode() = n.lookup("strategy") }

  /** Gets the trigger event that starts this workflow. */
  override EventImpl getATriggerEvent() {
    if this.getEnclosingWorkflow() instanceof ReusableWorkflowImpl
    then
      result = this.getEnclosingWorkflow().(ReusableWorkflowImpl).getACaller().getATriggerEvent()
      or
      result = this.getEnclosingWorkflow().getATriggerEvent() and
      not result.getName() = "workflow_call"
    else result = this.getEnclosingWorkflow().getATriggerEvent()
  }

  /** Gets the runs-on field of the job. */
  string getARunsOnLabel() {
    exists(ScalarValueImpl lbl, YamlMappingLikeNode runson |
      runson = n.lookup("runs-on").(YamlMappingLikeNode)
    |
      (
        lbl.getNode() = runson.getNode(_) and
        not lbl.getNode() = runson.getNode("group")
        or
        lbl.getNode() = runson.getNode("labels").(YamlMappingLikeNode).getNode(_)
      ) and
      (
        not exists(MatrixExpressionImpl e | e.getParentNode() = lbl) and
        result =
          lbl.getValue()
              .trim()
              .regexpReplaceAll("^('|\")", "")
              .regexpReplaceAll("('|\")$", "")
              .trim()
        or
        exists(MatrixExpressionImpl e |
          e.getParentNode() = lbl and
          result = e.getLiteralValues()
        )
      )
    )
  }

  private predicate hasExplicitSecretAccess() {
    // the job accesses a secret other than GITHUB_TOKEN
    exists(SecretsExpressionImpl expr |
      (expr.getEnclosingJob() = this or not exists(expr.getEnclosingJob())) and
      expr.getEnclosingWorkflow() = this.getEnclosingWorkflow() and
      not expr.getFieldName() = "GITHUB_TOKEN"
    )
  }

  private predicate hasExplicitNonePermission() {
    exists(this.getPermissions()) and not exists(this.getPermissions().getAPermission())
  }

  private predicate hasExplicitReadPermission() {
    // the job has not an explicit write permission
    exists(this.getPermissions().getAPermission()) and
    not this.getPermissions().getAPermission().matches("%write")
  }

  private predicate hasExplicitWritePermission() {
    // the job has an explicit write permission
    this.getPermissions().getAPermission().matches("%write")
  }

  private predicate hasImplicitNonePermission() {
    not exists(this.getPermissions()) and
    exists(this.getEnclosingWorkflow().getPermissions()) and
    not exists(this.getEnclosingWorkflow().getPermissions().getAPermission())
    or
    not exists(this.getPermissions()) and
    not exists(this.getEnclosingWorkflow().getPermissions()) and
    exists(this.getEnclosingWorkflow().(ReusableWorkflowImpl).getACaller().getPermissions()) and
    not exists(
      this.getEnclosingWorkflow()
          .(ReusableWorkflowImpl)
          .getACaller()
          .getPermissions()
          .getAPermission()
    )
  }

  private predicate hasImplicitReadPermission() {
    // the job has not an explicit write permission
    not exists(this.getPermissions()) and
    exists(this.getEnclosingWorkflow().getPermissions().getAPermission()) and
    not this.getEnclosingWorkflow().getPermissions().getAPermission().matches("%write")
    or
    not exists(this.getPermissions()) and
    not exists(this.getEnclosingWorkflow().getPermissions()) and
    this.getEnclosingWorkflow()
        .(ReusableWorkflowImpl)
        .getACaller()
        .getPermissions()
        .getAPermission()
        .matches("%read")
  }

  private predicate hasImplicitWritePermission() {
    // the job has an explicit write permission
    not exists(this.getPermissions()) and
    this.getEnclosingWorkflow().getPermissions().getAPermission().matches("%write")
    or
    not exists(this.getPermissions()) and
    not exists(this.getEnclosingWorkflow().getPermissions()) and
    this.getEnclosingWorkflow()
        .(ReusableWorkflowImpl)
        .getACaller()
        .getPermissions()
        .getAPermission()
        .matches("%write")
  }

  private predicate hasRuntimeData() {
    exists(string path, string trigger, string name, string secrets_source, string perms |
      workflowDataModel(path, trigger, name, secrets_source, perms, _) and
      path.trim() = this.getLocation().getFile().getRelativePath() and
      name.trim().matches(this.getId() + "%")
    )
  }

  private predicate hasRuntimeWritePermissions() {
    // the effective runtime permissions have write access
    exists(string path, string trigger, string name, string secrets_source, string perms |
      workflowDataModel(path, trigger, name, secrets_source, perms, _) and
      path.trim() = this.getLocation().getFile().getRelativePath() and
      name.trim().matches(this.getId() + "%") and
      // We cannot trust the permissions for pull_request events since they depend on the
      // provenance of the head branch (local vs fork)
      not trigger.trim() = "pull_request" and
      perms.toLowerCase().matches("%write%")
    )
  }

  /** Holds if the job is privileged. */
  predicate isPrivileged() {
    // the job has privileged runtime permissions
    this.hasRuntimeWritePermissions()
    or
    // the job has an explicit secret accesses
    this.hasExplicitSecretAccess()
    or
    // the job has an explicit write permission
    this.hasExplicitWritePermission()
    or
    // the job has no explicit permissions but the workflow has write permissions
    not exists(this.getPermissions()) and
    this.hasImplicitWritePermission()
  }

  /** Holds if the action is privileged and externally triggerable. */
  predicate isPrivilegedExternallyTriggerable(EventImpl event) {
    this.getATriggerEvent() = event and
    // job is triggereable by an external user
    event.isExternallyTriggerable() and
    // no matter if `pull_request` is granted write permissions or access to secrets
    // when the job is triggered by a `pull_request` event from a fork, they will get revoked
    not event.getName() = "pull_request" and
    (
      // job is privileged (write access or access to secrets)
      this.isPrivileged()
      or
      // the trigger event is __normally__ privileged
      event.isPrivileged() and
      // and we have no runtime data to prove otherwise
      not this.hasRuntimeData() and
      // and the job is not explicitly non-privileged
      not (
        (
          this.hasExplicitNonePermission() or
          this.hasImplicitNonePermission() or
          this.hasExplicitReadPermission() or
          this.hasImplicitReadPermission()
        ) and
        not this.hasExplicitSecretAccess()
      )
    )
  }
}

abstract class StepsContainerImpl extends AstNodeImpl {
  /** Gets any steps that are defined within this job. */
  abstract StepImpl getAStep();

  /** Gets the step at the given index within this job. */
  abstract StepImpl getStep(int i);
}

class RunsImpl extends StepsContainerImpl, TRunsNode {
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
  override StepImpl getAStep() {
    result.getNode() = n.lookup("steps").(YamlSequence).getElementNode(_)
  }

  /** Gets the step at the given index within this job. */
  override StepImpl getStep(int i) {
    result.getNode() = n.lookup("steps").(YamlSequence).getElementNode(i)
  }
}

class LocalJobImpl extends JobImpl, StepsContainerImpl {
  LocalJobImpl() { n.maps(any(YamlString s | s.getValue() = "steps"), _) }

  /** Gets any steps that are defined within this job. */
  override StepImpl getAStep() {
    result.getNode() = n.lookup("steps").(YamlSequence).getElementNode(_)
  }

  /** Gets the step at the given index within this job. */
  override StepImpl getStep(int i) {
    result.getNode() = n.lookup("steps").(YamlSequence).getElementNode(i)
  }
}

class StepImpl extends AstNodeImpl, TStepNode {
  YamlMapping n;

  StepImpl() { this = TStepNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() {
    result.getAChildNode() = this and
    (result instanceof LocalJobImpl or result instanceof RunsImpl)
  }

  override string getAPrimaryQlClass() { result = "StepImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlMapping getNode() { result = n }

  override JobImpl getEnclosingJob() {
    // if a step is within a composite action, we should follow the caller job
    result = this.getEnclosingCompositeAction().getACallerJob() or
    result = super.getEnclosingJob()
  }

  override EventImpl getATriggerEvent() { result = this.getEnclosingJob().getATriggerEvent() }

  EnvImpl getEnv() { result.getNode() = n.lookup("env") }

  /** Gets the ID of this step, if any. */
  string getId() { result = n.lookup("id").(YamlString).getValue() }

  /** Gets the value of the `if` field in this step, if any. */
  IfImpl getIf() { result.getNode() = n.lookup("if") }

  /** Gets the Runs or LocalJob that this step is in. */
  StepsContainerImpl getContainer() {
    result = this.getParentNode().(RunsImpl) or
    result = this.getParentNode().(LocalJobImpl)
  }

  StepImpl getNextStep() {
    // if step is a uses step calling a local composite action, we should follow the called step
    this instanceof UsesStepImpl and
    exists(CompositeActionImpl a |
      a.getACallerStep() = this and
      result = a.getRuns().getStep(0)
    )
    or
    // if step is the last step in a composite action, we should follow the next step in the caller
    exists(RunsImpl runs, StepsContainerImpl caller_container, StepImpl caller, int i |
      this.getContainer() = runs and
      runs.getStep(count(StepImpl s | runs.getAStep() = s | s) - 1) = this and
      runs.getEnclosingCompositeAction().getACallerStep() = caller and
      caller.getContainer() = caller_container and
      caller_container.getStep(i) = caller and
      caller_container.getStep(i + 1) = result
    )
    or
    // next step in the same job/runs
    exists(int i |
      this.getContainer().getStep(i) = this and
      result = this.getContainer().getStep(i + 1)
    )
  }

  /** Gets a step that follows this step. */
  StepImpl getAFollowingStep() {
    (
      // next steps in the same job/runs
      exists(int i, int j |
        this.getContainer().getStep(i) = this and
        result = this.getContainer().getStep(j) and
        i < j
      )
      or
      // next steps of the caller (in a composite action step)
      result = this.getEnclosingCompositeAction().getACallerStep().getAFollowingStep()
      or
      // if any of the next steps is a call to a local composite actions, we should follow it
      exists(int i, int j, CompositeActionImpl a |
        this.getContainer().getStep(i) = this and
        this.getContainer().getStep(j) = a.getACallerStep() and
        i < j and
        result = a.getRuns().getAStep()
      )
    )
  }
}

class EnvironmentImpl extends AstNodeImpl, TEnvironmentNode {
  YamlValue n;

  EnvironmentImpl() { this = TEnvironmentNode(n) }

  override string toString() { result = n.toString() }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  override AstNodeImpl getParentNode() { result.getAChildNode() = this }

  override string getAPrimaryQlClass() { result = "EnvironmentImpl" }

  override Location getLocation() { result = n.getLocation() }

  override YamlScalar getNode() { result = n }

  /** Gets the environment name. */
  string getName() { result = n.(YamlScalar).getValue() }

  /** Gets the environmen name. */
  ExpressionImpl getNameExpr() { result.getParentNode().getNode() = n }
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

  /** Get condition scalar style. */
  string getConditionStyle() { result = n.(YamlScalar).getStyle() }
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

  abstract ScalarValueImpl getCalleeNode();

  abstract string getVersion();

  int getMajorVersion() {
    result = this.getVersion().regexpReplaceAll("^v", "").regexpReplaceAll("\\..*", "").toInt()
  }

  /** Gets the argument expression for the given key. */
  string getArgument(string key) {
    exists(ScalarValueImpl scalar |
      scalar.getNode() = this.getNode().(YamlMapping).lookup("with").(YamlMapping).lookup(key) and
      result = scalar.getValue()
    )
  }

  /** Gets the argument expression for the given key (if it exists). */
  ExpressionImpl getArgumentExpr(string key) {
    result.getParentNode().getNode() =
      this.getNode().(YamlMapping).lookup("with").(YamlMapping).lookup(key)
  }
}

/** A Uses step represents a call to an action that is defined in a GitHub repository. */
class UsesStepImpl extends StepImpl, UsesImpl {
  YamlScalar u;

  UsesStepImpl() { this.getNode().lookup("uses") = u }

  override AstNodeImpl getAChildNode() { result.getNode() = n.getAChildNode*() }

  /** Gets the owner and name of the repository where the Action comes from, e.g. `actions/checkout` in `actions/checkout@v2`. */
  override string getCallee() {
    if u.getValue().indexOf("@") > 0
    then result = u.getValue().prefix(u.getValue().indexOf("@"))
    else result = u.getValue()
  }

  override ScalarValueImpl getCalleeNode() { result.getNode() = u }

  /** Gets the version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`. */
  override string getVersion() { result = u.getValue().suffix(u.getValue().indexOf("@") + 1) }

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

  override ScalarValueImpl getCalleeNode() { result.getNode() = u }

  /** Gets the version reference used when checking out the Action, e.g. `v2` in `actions/checkout@v2`. */
  override string getVersion() {
    exists(YamlString name |
      n.lookup("uses") = name and
      if not name.getValue().matches("\\.%")
      then result = name.getValue().regexpCapture(repoUsesParser(), 4)
      else none()
    )
  }
}

class RunImpl extends StepImpl {
  YamlScalar script;
  ScalarValueImpl scriptScalar;

  RunImpl() {
    this.getNode().lookup("run") = script and
    scriptScalar = TScalarValueNode(script)
  }

  override string toString() {
    if exists(this.getId()) then result = "Run Step: " + this.getId() else result = "Run Step"
  }

  /** Gets the working directory for this `run` mapping. */
  string getWorkingDirectory() {
    if exists(n.lookup("working-directory").(YamlString).getValue())
    then
      result =
        n.lookup("working-directory")
            .(YamlString)
            .getValue()
            .regexpReplaceAll("^\\./", "GITHUB_WORKSPACE/")
    else result = "GITHUB_WORKSPACE/"
  }

  /** Gets the shell for this `run` mapping. */
  string getShell() {
    if exists(n.lookup("shell"))
    then result = n.lookup("shell").(YamlString).getValue()
    else
      if exists(this.getInScopeDefaultValue("run", "shell"))
      then result = this.getInScopeDefaultValue("run", "shell").getValue()
      else
        if this.getEnclosingJob().getARunsOnLabel().matches(["ubuntu%", "macos%"])
        then result = "bash"
        else
          if this.getEnclosingJob().getARunsOnLabel().matches("windows%")
          then result = "pwsh"
          else result = "bash"
  }

  ShellScriptImpl getScript() { result = scriptScalar }

  ExpressionImpl getAnScriptExpr() { result.getParentNode().getNode() = script }
}

/**
 * Holds if `${{ e }}` is a GitHub Actions expression evaluated within this YAML string.
 * See https://docs.github.com/en/free-pro-team@latest/actions/reference/context-and-expression-syntax-for-github-actions.
 * Only finds simple expressions like `${{ github.event.comment.body }}`, where the expression contains only alphanumeric characters, underscores, dots, or dashes.
 * Does not identify more complicated expressions like `${{ fromJSON(env.time) }}`, or ${{ format('{{Hello {0}!}}', github.event.head_commit.author.name) }}
 */
bindingset[s]
string getASimpleReferenceExpression(string s, int offset) {
  // If the expression is ${{ inputs.foo == "foo" }} we should not consider it as a simple reference
  // check that expression matches a simple reference or several simple references ORed with ||
  s.regexpMatch("([A-Za-z0-9'\\\"_\\[\\]\\*\\(\\)\\.\\-]+)(\\s*\\|\\|\\s*[A-Za-z0-9'\\\"_\\[\\]\\*\\(\\)\\.\\-]+)*") and
  // We use `regexpFind` to obtain *all* matches of `${{...}}`,
  // not just the last (greedy match) or first (reluctant match).
  result =
    s.trim()
        .regexpFind("[A-Za-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+", _, offset)
        .regexpCapture("([A-Za-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+)", _)
}

bindingset[s]
string getAFromJsonReferenceExpression(string s, int offset) {
  // We use `regexpFind` to obtain *all* matches of `${{...}}`,
  // not just the last (greedy match) or first (reluctant match).
  result =
    s.trim()
        .regexpFind("(?i)fromjson\\([a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+\\)[a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]*",
          _, offset)
        .regexpCapture("(?i)fromjson\\(([a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+)\\)[a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]*",
          1)
}

bindingset[s]
string getAToJsonReferenceExpression(string s, int offset) {
  // We use `regexpFind` to obtain *all* matches of `${{...}}`,
  // not just the last (greedy match) or first (reluctant match).
  result =
    s.trim()
        .regexpFind("(?i)tojson\\(\\s*[a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+\\)[a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]*",
          _, offset)
        .regexpCapture("(?i)tojson\\(\\s*([a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+)\\)[a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]*",
          1)
}

bindingset[s]
string getAJsonReferenceExpression(string s, int offset) {
  // We use `regexpFind` to obtain *all* matches of `${{...}}`,
  // not just the last (greedy match) or first (reluctant match).
  result =
    s.trim()
        .regexpFind("(?i)(from|to)json\\([a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+\\)[a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]*",
          _, offset)
        .regexpCapture("(?i)(from|to)json\\(([a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+)\\)[a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]*",
          2)
}

bindingset[s]
string getAJsonReferenceAccessPath(string s, int offset) {
  // We use `regexpFind` to obtain *all* matches of `${{...}}`,
  // not just the last (greedy match) or first (reluctant match).
  result =
    s.trim()
        .regexpFind("(?i)(from|to)json\\([a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+\\)[a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]*",
          _, offset)
        .regexpCapture("(?i)(from|to)json\\(([a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+)\\)([a-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]*)",
          3)
}

/**
 * A ${{}} expression accessing a sigcle context variable such as steps, needs, jobs, env, inputs, or matrix.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 */
class SimpleReferenceExpressionImpl extends ExpressionImpl {
  SimpleReferenceExpressionImpl() {
    exists(getASimpleReferenceExpression(this.getFullExpression(), _))
    or
    exists(getAJsonReferenceExpression(this.getFullExpression(), _))
  }

  override string getExpression() {
    (
      result = getASimpleReferenceExpression(this.getFullExpression(), _)
      or
      exists(getAJsonReferenceExpression(this.getFullExpression(), _)) and
      result = this.getFullExpression()
    )
  }

  abstract string getFieldName();

  abstract AstNodeImpl getTarget();

  override string toString() { result = this.getFullExpression() }
}

class JsonReferenceExpressionImpl extends ExpressionImpl {
  string innerExpression;
  string accessPath;

  JsonReferenceExpressionImpl() {
    innerExpression = getAJsonReferenceExpression(this.getExpression(), _) and
    accessPath = getAJsonReferenceAccessPath(this.getExpression(), _)
  }

  string getInnerExpression() { result = innerExpression }

  string getAccessPath() { result = accessPath }
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

private string matrixCtxRegex() { result = wrapRegexp("matrix\\.(.+)") }

private string inputsCtxRegex() {
  result = wrapRegexp(["inputs\\.([A-Za-z0-9_-]+)", "github\\.event\\.inputs\\.([A-Za-z0-9_-]+)"])
}

private string secretsCtxRegex() { result = wrapRegexp("secrets\\.([A-Za-z0-9_-]+)") }

private string githubCtxRegex() {
  result = wrapRegexp("github\\.([A-Za-z0-9'\"_\\[\\]\\*\\(\\)\\.\\-]+)")
}

/**
 * Holds for an expression accesing the `github` context.
 * e.g. `${{ github.head_ref }}`
 */
class GitHubExpressionImpl extends SimpleReferenceExpressionImpl {
  GitHubExpressionImpl() {
    exists(string expr |
      (
        exists(getAJsonReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression()).regexpCapture("(?i)fromjson\\((.*)\\).*", 1)
        or
        exists(getASimpleReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression())
      ) and
      expr.regexpMatch(githubCtxRegex())
    )
  }

  override string getFieldName() {
    exists(string expr |
      (
        exists(getAJsonReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression()).regexpCapture("(?i)fromjson\\((.*)\\).*", 1)
        or
        exists(getASimpleReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression())
      ) and
      result = expr.regexpCapture(githubCtxRegex(), 1)
    )
  }

  override AstNodeImpl getTarget() { none() }
}

/**
 * Holds for an expression accesing the `secrets` context.
 * e.g. `${{ secrets.FOO }}`
 */
class SecretsExpressionImpl extends SimpleReferenceExpressionImpl {
  string fieldName;

  SecretsExpressionImpl() {
    exists(string expr |
      (
        exists(getAJsonReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression()).regexpCapture("(?i)fromjson\\((.*)\\).*", 1)
        or
        exists(getASimpleReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression())
      ) and
      expr.regexpMatch(secretsCtxRegex()) and
      fieldName = expr.regexpCapture(secretsCtxRegex(), 1)
    )
  }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() { none() }
}

/**
 * Holds for an expression accesing the `steps` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ steps.changed-files.outputs.all_changed_files }}`
 */
class StepsExpressionImpl extends SimpleReferenceExpressionImpl {
  string stepId;
  string fieldName;

  StepsExpressionImpl() {
    exists(string expr |
      (
        exists(getAJsonReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression()).regexpCapture("(?i)(from|to)json\\((.*)\\).*", 2)
        or
        exists(getASimpleReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression())
      ) and
      expr.regexpMatch(stepsCtxRegex()) and
      stepId = expr.regexpCapture(stepsCtxRegex(), 1) and
      fieldName = expr.regexpCapture(stepsCtxRegex(), 2)
    )
  }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() {
    (
      this.getEnclosingJob() = result.getEnclosingJob()
      or
      exists(CompositeActionImpl a |
        a.getAChildNode*() = this and
        a.getAChildNode*() = result
      )
    ) and
    result.(StepImpl).getId() = stepId
  }

  string getStepId() { result = stepId }
}

/**
 * Holds for an expression accesing the `needs` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ needs.job1.outputs.foo}}`
 */
class NeedsExpressionImpl extends SimpleReferenceExpressionImpl {
  JobImpl neededJob;
  string fieldName;

  NeedsExpressionImpl() {
    exists(string expr |
      (
        exists(getAJsonReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression()).regexpCapture("(?i)(from|to)json\\((.*)\\).*", 2)
        or
        exists(getASimpleReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression())
      ) and
      expr.regexpMatch(needsCtxRegex()) and
      fieldName = expr.regexpCapture(needsCtxRegex(), 2) and
      neededJob.getId() = expr.regexpCapture(needsCtxRegex(), 1) and
      neededJob.getLocation().getFile() = this.getLocation().getFile()
    )
  }

  string getNeededJobId() { result = neededJob.getId() }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() {
    (
      this.getEnclosingJob().getANeededJob() = neededJob or
      this.getEnclosingJob() = neededJob
    ) and
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
class JobsExpressionImpl extends SimpleReferenceExpressionImpl {
  string jobId;
  string fieldName;

  JobsExpressionImpl() {
    exists(string expr |
      (
        exists(getAJsonReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression()).regexpCapture("(?i)(from|to)json\\((.*)\\).*", 2)
        or
        exists(getASimpleReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression())
      ) and
      expr.regexpMatch(jobsCtxRegex()) and
      jobId = expr.regexpCapture(jobsCtxRegex(), 1) and
      fieldName = expr.regexpCapture(jobsCtxRegex(), 2)
    )
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
class InputsExpressionImpl extends SimpleReferenceExpressionImpl {
  string fieldName;

  InputsExpressionImpl() {
    normalizeExpr(this.getExpression()).regexpMatch(inputsCtxRegex()) and
    fieldName = normalizeExpr(this.getExpression()).regexpCapture(inputsCtxRegex(), 1)
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
class EnvExpressionImpl extends SimpleReferenceExpressionImpl {
  string fieldName;

  EnvExpressionImpl() {
    exists(string expr |
      (
        exists(getAJsonReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression()).regexpCapture("(?i)(from|to)json\\((.*)\\).*", 2)
        or
        exists(getASimpleReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression())
      ) and
      expr.regexpMatch(envCtxRegex()) and
      fieldName = expr.regexpCapture(envCtxRegex(), 1)
    )
  }

  override string getFieldName() { result = fieldName }

  override AstNodeImpl getTarget() {
    exists(AstNodeImpl s |
      s.getInScopeEnvVarExpr(fieldName) = result and
      s.getAChildNode*() = this
    )
    or
    // Some Run steps may store taint in the enclosing job so we need to check the enclosing job
    result = this.getEnclosingJob()
  }
}

/**
 * Holds for an expression accesing the `matrix` context.
 * https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability
 * e.g. `${{ matrix.foo }}`
 */
class MatrixExpressionImpl extends SimpleReferenceExpressionImpl {
  string fieldAccess;

  MatrixExpressionImpl() {
    exists(string expr |
      (
        exists(getAJsonReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression()).regexpCapture("(?i)(from|to)json\\((.*)\\).*", 2)
        or
        exists(getASimpleReferenceExpression(this.getExpression(), _)) and
        expr = normalizeExpr(this.getExpression())
      ) and
      expr.regexpMatch(matrixCtxRegex()) and
      fieldAccess = expr.regexpCapture(matrixCtxRegex(), 1)
    )
  }

  override string getFieldName() { result = fieldAccess }

  override AstNodeImpl getTarget() {
    result = this.getEnclosingWorkflow().getStrategy().getMatrixVarExpr(fieldAccess) or
    result = this.getEnclosingJob().getStrategy().getMatrixVarExpr(fieldAccess)
  }

  string getLiteralValues() {
    exists(StrategyImpl s, MatrixAccessPathImpl p, ScalarValueImpl v |
      (s = this.getEnclosingJob().getStrategy() or s = this.getEnclosingWorkflow().getStrategy()) and
      p.toString() = fieldAccess and
      resolveMatrixAccessPath(s.getMatrix(), p).getNode(_) = v.getNode() and
      // Exclude values containing matrix expressions to avoid recursion
      not exists(MatrixExpressionImpl e | e.getParentNode() = v) and
      result = v.getValue()
    )
  }
}

bindingset[accessPath]
string explodeAccessPath(string accessPath) {
  result = accessPath or
  result = accessPath.suffix(accessPath.indexOf(".") + 1) or
  result = accessPath.prefix(accessPath.indexOf("."))
}

private newtype TAccessPath =
  TMatrixAccessPathNode(string accessPath) {
    exists(MatrixExpressionImpl e | accessPath = explodeAccessPath(e.getFieldName()))
  }

class MatrixAccessPathImpl extends TMatrixAccessPathNode {
  string accessPath;

  MatrixAccessPathImpl() { this = TMatrixAccessPathNode(accessPath) }

  string toString() { result = accessPath }
}

private YamlMappingLikeNode resolveMatrixAccessPath(
  // TODO: support `include` and `exclude` keys
  // https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs#expanding-or-adding-matrix-configurations
  YamlMappingLikeNode root, MatrixAccessPathImpl accessPath
) {
  // access path contains no dots. eg: "os"
  result = root.getNode(accessPath.toString())
  or
  // access path contains dots. eg: "plaform.os"
  exists(MatrixAccessPathImpl first, MatrixAccessPathImpl rest, YamlMappingLikeNode newRoot |
    first.toString() = accessPath.toString().splitAt(".", 0) and
    rest.toString() = accessPath.toString().suffix(first.toString().length() + 1) and
    newRoot = root.getNode(first.toString()) and
    if newRoot instanceof YamlSequence
    then result = resolveMatrixAccessPath(newRoot.(YamlSequence).getElementNode(_), rest)
    else result = resolveMatrixAccessPath(newRoot, rest)
  )
}

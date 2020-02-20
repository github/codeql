/**
 * Provides predicates and classes for working with useless uses of `cat`.
 */

import javascript
import semmle.javascript.security.dataflow.IndirectCommandArgument

/**
 * Gets a string representing an equivalent call to `fs.ReadFile` for a call to `cat`.
 */
string createReadFileCall(UselsesCatCandidates::UselessCatCandicate cat) {
  exists(string sync, string extraArg, string callback |
    (if cat.isSync() then sync = "Sync" else sync = "") and
    (
      if exists(cat.getOptionsArg())
      then extraArg = ", " + printOptionsArg(cat.getOptionsArg()) + ")"
      else extraArg = ""
    ) and
    if exists(cat.getCallback())
    then callback = ", function(" + getCallbackArgs(cat.getCallback()) + ") {...}"
    else callback = ""
  |
    result = "fs.readFile" + sync + "(" + cat.getFileArgument().trim() + extraArg + callback + ")"
  )
}

/**
 * Gets a string concatenation of the parameters to a function.
 */
private string getCallbackArgs(DataFlow::FunctionNode func) {
  result = concat(int i | i = [0 .. 2] | func.getParameter(i).getName(), ", ")
}

/**
 * Gets a string representation of the options argument from an exec-like call.
 */
private string printOptionsArg(DataFlow::Node node) {
  result = node.asExpr().(VarAccess).getVariable().getName()
  or
  // fall back to toString(), but ensure that we don't have dots in the middle.
  result = node.(DataFlow::ObjectLiteralNode).toString() and not result.regexpMatch(".*\\.\\..*")
}

/**
 * A call to a useless use of `cat`.
 */
class UselessCat extends DataFlow::CallNode {
  UselsesCatCandidates::UselessCatCandicate candidate;

  UselessCat() {
    this = candidate and
    // wildcards, pipes, redirections, and multiple files are OK.
    // (The multiple files detection relies on the fileArgument not containing spaces anywhere)
    not candidate.getFileArgument().regexpMatch(".*(\\*|\\||>|<| ).*") and
    // Only acceptable option is "encoding", everything else is non-trivial to emulate with fs.readFile.
    not exists(string prop |
      not prop = "encoding" and
      exists(candidate.getOptionsArg().getALocalSource().getAPropertyWrite(prop))
    ) and
    exists(createReadFileCall(this)) and
    // If there is a callback, then it must either have one or two arguments, or if there is a third argument it must be unused.
    (
      not exists(candidate.getCallback())
      or
      exists(DataFlow::FunctionNode func | func = candidate.getCallback() |
        func.getNumParameter() = 1
        or
        func.getNumParameter() = 2
        or
        // `exec` can use 3 parameters, `readFile` can only use two, so it is OK to have a third parameter if it is unused,
        func.getNumParameter() = 3 and
        not exists(DataFlow::Node node |
          not node = func.getParameter(2) and func.getParameter(2) = node.getALocalSource()
        )
      )
    )
  }
}

module UselsesCatCandidates {
  /**
   * A candidate for a useless use of `cat`.
   * Subclasses of this class specify the structure of the `exec`-like call.
   */
  abstract class UselessCatCandicate extends DataFlow::CallNode {
    /**
     * Holds if the call is synchronous (e.g. `execFileSync`).
     */
    abstract predicate isSync();

    /**
     * Gets a string representation of the expression that determines what file is read.
     */
    abstract string getFileArgument();

    /**
     * Gets the data-flow node for the options argument to the `exec`-like call.
     */
    abstract DataFlow::Node getOptionsArg();

    /**
     * Gets the callback used for the `exec` like call (if it exists).
     */
    abstract DataFlow::FunctionNode getCallback();
  }

  /**
   * Create a string representation of a string concatenation.
   */
  private string createConcatRepresentation(StringOps::ConcatenationRoot root) {
    // String concat
    not exists(root.getStringValue()) and
    not root.asExpr() instanceof TemplateLiteral and
    forall(Expr e | e = root.getALeaf().asExpr() | exists(createLeafRepresentation(e))) and
    result =
      concat(Expr leaf |
        leaf = root.getALeaf().asExpr()
      |
        createLeafRepresentation(leaf), "+" order by leaf.getFirstToken().getIndex()
      )
    or
    // Template string
    exists(TemplateLiteral template | template = root.asExpr() |
      forall(Expr e | e = template.getAChild() | exists(createTemplateElementRepresentation(e))) and
      result =
        "`" +
          concat(int i |
            i = [0 .. template.getNumChild() - 1]
          |
            createTemplateElementRepresentation(template.getChild(i)) order by i
          ) + "`"
    )
  }

  /**
   * Gets a string representing the expression needed to re-create the value for a leaf in a string-concatenation.
   */
  private string createLeafRepresentation(Expr e) {
    result = "\"" + e.getStringValue() + "\"" or
    result = e.(VarAccess).getVariable().getName()
  }

  /**
   * Gets a string representing the expression needed to re-create the value for an element of a template string.
   */
  private string createTemplateElementRepresentation(Expr e) {
    result = "${" + e.(VarAccess).getVariable().getName() + "}"
    or
    result = e.(TemplateElement).getValue()
  }

  /**
   * Gets a string used to call `cat`.
   */
  private string cat() {
    result = "cat" or result = "/bin/cat" or result = "sudo cat" or result = "sudo /bin/cat"
  }

  /**
   * Gets a string representing an expression that gets the file read by a call to `cat`.
   * The input `arg` is the node that determines the commandline where `cat` is invoked.
   */
  private string getFileArgumentWithoutCat(DataFlow::Node arg) {
    exists(string cat | cat = cat() |
      exists(string command | arg.mayHaveStringValue(command) |
        command.prefix(cat.length()) = cat and
        result = "\"" + command.suffix(cat.length()).trim() + "\""
      )
      or
      exists(StringOps::ConcatenationRoot root, string printed, string quote |
        root = arg and printed = createConcatRepresentation(root).suffix(1) // remove initial quote
      |
        (if root.asExpr() instanceof TemplateLiteral then quote = "`" else quote = "\"") and
        root.getFirstLeaf().getStringValue().prefix(cat.length()) = cat and
        // Remove an initial ""+ (e.g. in `""+file`)
        exists(string rawConcat | rawConcat = quote + printed.suffix(cat.length()).trim() |
          if rawConcat.prefix(3) = "\"\"+" then result = rawConcat.suffix(3) else result = rawConcat
        )
      )
    )
  }

  /**
   * A call to child_process.exec that might be a useless call to cat.
   */
  private class ExecCall extends UselessCatCandicate {
    string fileArgument;
    boolean hasOptions;

    ExecCall() {
      this = DataFlow::moduleImport("child_process").getAMemberCall("exec") and
      (
        this.getNumArgument() = 2 and hasOptions = false
        or
        this.getNumArgument() = 3 and hasOptions = true
      ) and
      fileArgument = getFileArgumentWithoutCat(getArgument(0))
    }

    override predicate isSync() { none() }

    override string getFileArgument() { result = fileArgument }

    override DataFlow::Node getOptionsArg() { hasOptions = true and result = getArgument(1) }

    override DataFlow::FunctionNode getCallback() { result = getLastArgument() }
  }

  /**
   * A call to child_process.execSync that might be a useless call to cat.
   */
  private class ExecSyncCall extends UselessCatCandicate {
    string fileArgument;
    boolean hasOptions;

    ExecSyncCall() {
      this = DataFlow::moduleImport("child_process").getAMemberCall("execSync") and
      (
        this.getNumArgument() = 1 and hasOptions = false
        or
        this.getNumArgument() = 2 and hasOptions = true
      ) and
      fileArgument = getFileArgumentWithoutCat(getArgument(0))
    }

    override predicate isSync() { any() }

    override string getFileArgument() { result = fileArgument }

    override DataFlow::Node getOptionsArg() { hasOptions = true and result = getArgument(1) }

    override DataFlow::FunctionNode getCallback() { none() }
  }

  /**
   * Gets the file that is read for a call to child_process.execFile/execFileSync.
   */
  string getFileThatIsRead(DataFlow::CallNode call) {
    exists(DataFlow::ArrayCreationNode array, DataFlow::Node element |
      array = call.getArgument(1).(DataFlow::ArrayCreationNode) and
      array.getSize() = 1 and
      element = array.getElement(0)
    |
      result = element.asExpr().(VarAccess).getVariable().getName() or
      result = "\"" + element.getStringValue() + "\"" or
      result = createConcatRepresentation(element)
    )
  }

  /**
   * A call to child_process.execFile that might be a useless call to cat.
   */
  private class ExecFileCall extends UselessCatCandicate {
    string fileArgument;
    boolean hasOptions;

    ExecFileCall() {
      this.getArgument(0).mayHaveStringValue(cat()) and
      this = DataFlow::moduleImport("child_process").getAMemberCall("execFile") and
      (
        this.getNumArgument() = 3 and hasOptions = false
        or
        this.getNumArgument() = 4 and hasOptions = true
      ) and
      fileArgument = getFileThatIsRead(this)
    }

    override predicate isSync() { none() }

    override string getFileArgument() { result = fileArgument }

    override DataFlow::Node getOptionsArg() { hasOptions = true and result = getArgument(2) }

    override DataFlow::FunctionNode getCallback() { result = getLastArgument() }
  }

  /**
   * A call to child_process.execFileSync that might be a useless call to cat.
   */
  private class ExecFileSyncCall extends UselessCatCandicate {
    string fileArgument;
    boolean hasOptions;

    ExecFileSyncCall() {
      this.getArgument(0).mayHaveStringValue(cat()) and
      this = DataFlow::moduleImport("child_process").getAMemberCall("execFileSync") and
      (
        this.getNumArgument() = 2 and hasOptions = false
        or
        this.getNumArgument() = 3 and hasOptions = true
      ) and
      fileArgument = getFileThatIsRead(this)
    }

    override predicate isSync() { any() }

    override string getFileArgument() { result = fileArgument }

    override DataFlow::Node getOptionsArg() { hasOptions = true and result = getArgument(2) }

    override DataFlow::FunctionNode getCallback() { none() }
  }
}

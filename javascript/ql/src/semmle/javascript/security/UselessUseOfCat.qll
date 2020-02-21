/**
 * Provides predicates and classes for working with useless uses of `cat`.
 */

import javascript

/**
 * Gets a string representation of an equivalent call to `fs.readFile` for a given command execution `cat`.
 */
string createReadFileCall(UselsesCatCandidates::UselessCatCandicate cat) {
  exists(string sync, string extraArg, string callback |
    (if cat.isSync() then sync = "Sync" else sync = "") and
    (
      extraArg = ", " + printOptionsArg(cat.getOptionsArg()) + ")"
      or
      extraArg = "" and not exists(cat.getOptionsArg())
    ) and
    (
      callback = constructCallbackString(cat.getCallback())
      or
      callback = "" and not exists(cat.getCallback())
    )
  |
    result = "fs.readFile" + sync + "(" + cat.getFileArgument().trim() + extraArg + callback + ")"
  )
}

/**
 * Constructs a string representing the callback `func`.
 */
string constructCallbackString(DataFlow::FunctionNode func) {
  exists(string args | args = getCallbackArgs(func) |
    if func.getFunction() instanceof ArrowFunctionExpr
    then
      if func.getFunction().getBody() instanceof Expr
      then result = ", (" + args + ") => ..."
      else result = ", (" + args + ") => {...}"
    else result = ", function(" + args + ") {...}"
  )
}

/**
 * Gets a string concatenation of the parameter names in a function `func`.
 */
private string getCallbackArgs(DataFlow::FunctionNode func) {
  result =
    concat(int i |
      i = [0 .. func.getNumParameter()]
    |
      func.getParameter(i).getName(), ", " order by i
    )
}

/**
 * Gets a string representation of the options argument `arg` from an exec-like call.
 */
private string printOptionsArg(DataFlow::Node arg) {
  result = arg.asExpr().(VarAccess).getVariable().getName()
  or
  // fall back to toString(), but ensure that we don't have dots in the middle.
  result = arg.(DataFlow::ObjectLiteralNode).toString() and not result.regexpMatch(".*\\.\\..*")
}

/**
 * A call to a useless use of `cat`.
 */
class UselessCat extends DataFlow::CallNode {
  UselsesCatCandidates::UselessCatCandicate candidate;

  UselessCat() {
    this = candidate and
    // We can create an equivalent `fs.readFile` call.
    exists(createReadFileCall(this)) and
    // There is a file to read, and not just a pair of quotes.
    candidate.getFileArgument().length() >= 3 and
    // wildcards, pipes, redirections, and multiple files are OK.
    // (The multiple files detection relies on the fileArgument not containing spaces anywhere)
    not candidate.getFileArgument().regexpMatch(".*(\\*|\\||>|<| ).*") and
    // Only acceptable option is "encoding", everything else is non-trivial to emulate with fs.readFile.
    (
      not exists(candidate.getOptionsArg())
      or
      forex(string prop |
        exists(candidate.getOptionsArg().getALocalSource().getAPropertyWrite(prop))
      |
        prop = "encoding"
      )
    ) and
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
        func.getNumParameter() = 3 and not exists(SSA::definition(func.getParameter(2).getParameter()))
      )
    )
  }
}

module UselsesCatCandidates {
  /**
   * A candidate for a useless use of `cat`.
   * This class describes the structure of a call to cat
   * This class does not determine whether it is a useless call, or even if it is a call to `cat`.
   */
  class UselessCatCandicate extends DataFlow::CallNode {
    SystemCommandExecution command;

    UselessCatCandicate() { this = command }

    /**
     * Holds if the call is synchronous (e.g. `execFileSync`).
     */
    predicate isSync() { command.isSync() }

    /**
     * Holds if the executed command execution has an argument list as a separate argument.
     */
    predicate hasArgumentList() { exists(command.getArgumentList()) }

    /**
     * Gets a string representation of the expression that determines what file is read by `cat`.
     */
    string getFileArgument() {
      if hasArgumentList()
      then
        getArgument(0).mayHaveStringValue(cat()) and
        result = getFileThatIsReadFromCommandList(this)
      else result = getFileArgumentWithoutCat(getArgument(0))
    }

    /**
     * Gets the data-flow node (if it exists) for the options argument to the `exec`-like call.
     */
    DataFlow::Node getOptionsArg() {
      exists(int n |
        n >= 1 and
        // If there is a command-list, then the options is at least the third argument.
        (not exists(command.getArgumentList()) or n >= 2) and
        // async calls have a callback as their last call.
        if this.isSync() then n < getNumArgument() else n < getNumArgument() - 1
      |
        result = getArgument(n)
      )
    }

    /**
     * Gets the callback (if it exists) for an async `exec` like call.
     */
    DataFlow::FunctionNode getCallback() {
      not this.isSync() and result = getLastArgument().getALocalSource()
    }
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
        exists(string rawConcat | rawConcat = quote + printed.suffix(cat.length()).trim() |
          result = getSimplifiedStringConcat(rawConcat)
        )
      )
    )
  }

  /**
   * Gets a simplified and equivalent string concatenation for a given string concatenation `str`
   */
  bindingset[str]
  private string getSimplifiedStringConcat(string str) {
    // Remove an initial ""+ (e.g. in `""+file`)
    if str.prefix(3) = "\"\"+"
    then result = str.suffix(3)
    else
      // prettify `${newpath}` to just newpath
      if
        str.prefix(3) = "`${" and
        str.suffix(str.length() - 2) = "}`" and
        not str.suffix(3).matches("%{%")
      then result = str.prefix(str.length() - 2).suffix(3)
      else result = str
  }

  /**
   * Gets the file that is read for a call with an explicit command list (e.g. `child_process.execFile/execFileSync`).
   */
  string getFileThatIsReadFromCommandList(DataFlow::CallNode call) {
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
}

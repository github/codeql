/**
 * Provides predicates and classes for working with useless uses of the unix command `cat`.
 */

import javascript
import Expressions.ExprHasNoEffect
import Declarations.UnusedVariable

/**
 * A call that executes a system command.
 * This class provides utility predicates for reasoning about command execution calls.
 */
private class CommandCall extends DataFlow::InvokeNode {
  SystemCommandExecution command;

  CommandCall() { this = command }

  /**
   * Holds if the call is synchronous (e.g. `execFileSync`).
   */
  predicate isSync() { command.isSync() }

  /**
   * Gets a list that specifies the arguments given to the command.
   */
  DataFlow::ArrayCreationNode getArgumentList() {
    result = command.getArgumentList().getALocalSource()
  }

  /**
   * Gets the callback (if it exists) for an async `exec`-like call.
   */
  DataFlow::FunctionNode getCallback() {
    not this.isSync() and result = this.getLastArgument().getALocalSource()
  }

  /**
   * Holds if the executed command execution has an argument list as a separate argument.
   */
  predicate hasArgumentList() { exists(this.getArgumentList()) }

  /**
   * Gets the data-flow node (if it exists) for an options argument for an `exec`-like call.
   */
  DataFlow::Node getOptionsArg() { result = command.getOptionsArg() }

  /**
   * Gets the constant-string parts that are not part of the command itself.
   * E.g. for a command execution `exec("/bin/cat foo bar")` this predicate will have result `"foo bar"`.
   */
  string getNonCommandConstantString() {
    if this.hasArgumentList()
    then
      result =
        getConstantStringParts(this.getArgumentList()
              .getALocalSource()
              .(DataFlow::ArrayCreationNode)
              .getElement(_))
    else
      exists(string commandString | commandString = getConstantStringParts(this.getArgument(0)) |
        result = commandString.suffix(1 + commandString.indexOf(" ", 0, 0))
      )
  }

  /**
   * Holds if this command execution invokes the executeable `name`.
   */
  bindingset[name]
  predicate isACallTo(string name) {
    if this.hasArgumentList()
    then this.getArgument(0).mayHaveStringValue(name)
    else
      exists(string arg | arg = getConstantStringParts(this.getArgument(0)) |
        arg.prefix(name.length()) = name
      )
  }
}

/**
 * Holds if the input `str` contains some character that might be interpreted in a non-trivial way by a shell.
 */
bindingset[str]
private predicate containsNonTrivialShellChar(string str) {
  exists(str.regexpFind("\\*|\\||>|<| |\\$|&|,|\\`| |;", _, _))
}

/**
 * Gets the constant string parts from a data-flow node.
 * Either the result is a constant string value that the node can hold, or the node is a string-concatenation and the result is the string parts from the concatenation.
 */
private string getConstantStringParts(DataFlow::Node node) {
  node.mayHaveStringValue(result)
  or
  result = node.(StringOps::ConcatenationRoot).getConstantStringParts()
}

/**
 * A call to a useless use of `cat`.
 */
class UselessCat extends CommandCall {
  UselessCat() {
    this = command and
    this.isACallTo(getACatExecuteable()) and
    // There is a file to read, it's not just spawning `cat`.
    not (
      not exists(this.getArgumentList()) and
      this.getArgument(0).mayHaveStringValue(getACatExecuteable())
    ) and
    // wildcards, pipes, redirections, other bash features, and multiple files (spaces) are OK.
    not containsNonTrivialShellChar(this.getNonCommandConstantString()) and
    // Only acceptable option is "encoding", everything else is non-trivial to emulate with fs.readFile.
    (
      not exists(this.getOptionsArg())
      or
      forex(string prop | exists(this.getOptionsArg().getALocalSource().getAPropertyWrite(prop)) |
        prop = "encoding"
      )
    ) and
    // If there is a callback, then it must either have one or two parameters, or if there is a third parameter it must be unused.
    (
      not exists(this.getCallback())
      or
      exists(DataFlow::FunctionNode func | func = this.getCallback() |
        func.getNumParameter() = 1
        or
        func.getNumParameter() = 2
        or
        // `exec` can use 3 parameters, `readFile` can only use two, so it is OK to have a third parameter if it is unused,
        func.getNumParameter() = 3 and
        not exists(SSA::definition(func.getParameter(2).getParameter()))
      )
    ) and
    // The process returned by an async call is unused.
    (
      this.isSync()
      or
      inVoidContext(this.getEnclosingExpr())
      or
      this.getEnclosingExpr() = any(UnusedLocal v).getAnAssignedExpr()
    )
  }
}

/**
 * Gets a string used to call `cat`.
 */
private string getACatExecuteable() { result = "cat" or result = "/bin/cat" }

/**
 * Predicates for creating an equivalent call to `fs.readFile` from a command execution of `cat`.
 */
module PrettyPrintCatCall {
  /**
   * Create a string representation of an equivalent call to `fs.readFile` for a given command execution `cat`.
   */
  string createReadFileCall(UselessCat cat) {
    exists(string sync, string extraArg, string callback, string fileArg |
      (if cat.isSync() then sync = "Sync" else sync = "") and
      (
        exists(cat.getOptionsArg()) and
        (
          extraArg = ", " + createOptionsArg(cat.getOptionsArg())
          or
          not exists(createOptionsArg(cat.getOptionsArg())) and
          extraArg = ", ..."
        )
        or
        extraArg = "" and not exists(cat.getOptionsArg())
      ) and
      (
        callback = createCallbackString(cat.getCallback())
        or
        callback = "" and not exists(cat.getCallback())
      ) and
      fileArg = createFileArgument(cat).trim() and
      // consistency check in case of surprising `toString` results, other uses of `containsNonTrivialBashChar` should ensure that this conjunct will hold most of the time
      not containsNonTrivialShellChar(fileArg.regexpReplaceAll("\\$|\\`| ", "")) // string concat might contain " ", template strings might contain "$" or `, and that is OK.
    |
      result = "fs.readFile" + sync + "(" + fileArg + extraArg + callback + ")"
    )
  }

  /**
   * Create a string representation of the expression that determines what file is read by `cat`.
   */
  string createFileArgument(CommandCall cat) {
    if cat.hasArgumentList()
    then
      cat.getArgument(0).mayHaveStringValue(getACatExecuteable()) and
      result = createFileThatIsReadFromCommandList(cat)
    else result = createFileArgumentWithoutCat(cat.getArgument(0))
  }

  /**
   * Create a string representing the callback `func`.
   */
  string createCallbackString(DataFlow::FunctionNode func) {
    exists(string params | params = createCallbackParams(func) |
      if func.getFunction() instanceof ArrowFunctionExpr
      then
        if func.getFunction().getBody() instanceof Expr
        then result = ", (" + params + ") => ..."
        else result = ", (" + params + ") => {...}"
      else result = ", function(" + params + ") {...}"
    )
  }

  /**
   * Create a string concatenation of the parameter names in a function `func`.
   */
  private string createCallbackParams(DataFlow::FunctionNode func) {
    result =
      concat(int i |
        i = [0 .. func.getNumParameter()]
      |
        func.getParameter(i).getName(), ", " order by i
      )
  }

  /**
   * Create a string representation of the options argument `arg` from an exec-like call.
   */
  private string createOptionsArg(DataFlow::Node arg) {
    result = arg.asExpr().(VarAccess).getVariable().getName()
    or
    // fall back to toString(), but ensure that we don't have dots in the middle.
    result = arg.(DataFlow::ObjectLiteralNode).toString() and not result.regexpMatch(".*\\.\\..*")
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
        createLeafRepresentation(leaf), " + "
        order by
          leaf.getLocation().getStartLine(), leaf.getLocation().getStartColumn()
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
   * Create a string representing the expression needed to re-create the value for a leaf in a string-concatenation.
   */
  private string createLeafRepresentation(Expr e) {
    result = "\"" + e.getStringValue() + "\"" or
    result = e.(VarAccess).getVariable().getName()
  }

  /**
   * Create a string representing the expression needed to re-create the value for an element of a template string.
   */
  private string createTemplateElementRepresentation(Expr e) {
    result = "${" + e.(VarAccess).getVariable().getName() + "}"
    or
    result = e.(TemplateElement).getValue()
  }

  /**
   * Create a string representing an expression that gets the file read by a call to `cat`.
   * The input `arg` is the node that determines the commandline where `cat` is invoked.
   */
  private string createFileArgumentWithoutCat(DataFlow::Node arg) {
    exists(string cat | cat = getACatExecuteable() |
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
          result = createSimplifiedStringConcat(rawConcat)
        )
      )
    )
  }

  /**
   * Create a simplified and equivalent string concatenation for a given string concatenation `str`
   */
  bindingset[str]
  private string createSimplifiedStringConcat(string str) {
    // Remove an initial ""+ (e.g. in `""+file`)
    if str.matches("\"\" + %")
    then result = str.suffix(5)
    else
      // prettify `${newpath}` to just newpath
      if str.matches("`${%") and str.matches("%}`") and not str.suffix(3).matches("%{%")
      then result = str.prefix(str.length() - 2).suffix(3)
      else result = str
  }

  /**
   * Create the file that is read for a call with an explicit command list (e.g. `child_process.execFile/execFileSync`).
   */
  string createFileThatIsReadFromCommandList(CommandCall call) {
    exists(DataFlow::ArrayCreationNode array, DataFlow::Node element |
      array = call.getArgumentList() and
      array.getSize() = 1 and
      element = array.getElement(0)
    |
      result = element.asExpr().(VarAccess).getVariable().getName() or
      result = "\"" + element.getStringValue() + "\"" or
      result = createConcatRepresentation(element)
    )
  }
}

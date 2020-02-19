/**
 * Provides predicates and classes for working with useless uses of `cat`.
 */

import javascript
import semmle.javascript.security.dataflow.IndirectCommandArgument

/**
 * Gets the first string from a string/string-concatenation.
 */
private string getStartingString(DataFlow::Node node) {
  node.mayHaveStringValue(result) or
  node.(StringOps::ConcatenationRoot).getFirstLeaf().mayHaveStringValue(result)
}

/**
 * Gets a string from a string/string-concatenation.
 */
private string getAString(DataFlow::Node node) {
  node.mayHaveStringValue(result) or
  node.(StringOps::ConcatenationRoot).getALeaf().mayHaveStringValue(result)
}

/**
 * An command-line execution of `cat` that only reads a file.
 */
class UselessCat extends DataFlow::Node {
  DataFlow::Node command;

  UselessCat() {
    command = this.(SystemCommandExecution).getACommandArgument() and
    exists(string cat |
      cat = "cat" or cat = "/bin/cat" or cat = "sudo cat" or cat = "sudo /bin/cat"
    |
      exists(string commandString |
        commandString = getStartingString(command).trim() and
        (commandString = cat or commandString.regexpMatch(cat + " .*"))
      ) and
      // `cat` is OK in combination with pipes, wildcards, and redirections.
      not getAString(command).regexpMatch(".*(\\*|\\||>|<).*") and
      // It is OK just to spawn "cat" without any arguments.
      not (
        command.mayHaveStringValue(cat) and
        not exists(
          this
              .(SystemCommandExecution)
              .getArgumentList()
              .(DataFlow::ArrayCreationNode)
              .getAnElement()
        )
      )
    )
  }

  /**
   * Gets the dataflow node determining the command executed.
   */
  DataFlow::Node getCommand() { result = command }
}

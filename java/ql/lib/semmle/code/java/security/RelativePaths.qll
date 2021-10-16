/* Detection of strings and arrays of strings containing relative paths. */
import java

/**
 * An element that starts with a relative path.
 */
predicate relativePath(Element tree, string command) {
  exists(StringLiteral lit, string text | tree = lit and text = lit.getLiteral() |
    text != "" and
    (
      text.regexpMatch("[^/\\\\ \t]*") or
      text.regexpMatch("[^/\\\\ \t]*[ \t].*")
    ) and
    command = text.replaceAll("\t", " ").splitAt(" ", 0).replaceAll("\"", "")
  )
  or
  exists(AddExpr add | tree = add | relativePath(add.getLeftOperand(), command))
}

/**
 * An element that holds an array where the first element of
 * the array is a relative path.
 */
predicate arrayStartingWithRelative(Element tree, string command) {
  exists(ArrayCreationExpr arrayCreation, ArrayInit arrayInit, Element firstElement |
    tree = arrayCreation and
    arrayInit = arrayCreation.getInit() and
    arrayInit.getInit(0) = firstElement and
    relativePath(firstElement, command)
  )
}

/**
 * A shell built-in command. These cannot be invoked with an absolute path,
 * because they do not correspond to files in the filesystem.
 */
predicate shellBuiltin(string command) {
  command = "." or
  command = "[" or
  command = "[[" or
  command = "alias" or
  command = "builtin" or
  command = "case" or
  command = "command" or
  command = "compgen" or
  command = "complete" or
  command = "compopt" or
  command = "echo" or
  command = "eval" or
  command = "exec" or
  command = "false" or
  command = "fc" or
  command = "for" or
  command = "getopts" or
  command = "help" or
  command = "history" or
  command = "if" or
  command = "kill" or
  command = "printf" or
  command = "pwd" or
  command = "select" or
  command = "source" or
  command = "test" or
  command = "time" or
  command = "times" or
  command = "trap" or
  command = "true" or
  command = "type" or
  command = "typeset" or
  command = "ulimit" or
  command = "until" or
  command = "while"
}

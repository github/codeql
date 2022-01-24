/* Detection of strings and arrays of strings containing relative paths. */
import java

/**
 * An element that starts with a relative path.
 */
predicate relativePath(Element tree, string command) {
  exists(StringLiteral lit, string text | tree = lit and text = lit.getValue() |
    text != "" and
    text.regexpMatch(["[^/\\\\ \t]*", "[^/\\\\ \t]*[ \t].*"]) and
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
  command =
    [
      ".", "[", "[[", "alias", "builtin", "case", "command", "compgen", "complete", "compopt",
      "echo", "eval", "exec", "false", "fc", "for", "getopts", "help", "history", "if", "kill",
      "printf", "pwd", "select", "source", "test", "time", "times", "trap", "true", "type",
      "typeset", "ulimit", "until", "while"
    ]
}

import semmle.code.cpp.Macro

/** A macro defining NULL. */
class NullMacro extends Macro {
  NullMacro() { this.getHead() = "NULL" }
}

/** DEPRECATED: Alias for NullMacro */
deprecated class NULLMacro = NullMacro;

/** A use of the NULL macro. */
class NULL extends Literal {
  NULL() { exists(NullMacro nm | this = nm.getAnInvocation().getAnExpandedElement()) }
}

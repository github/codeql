import semmle.code.cpp.Macro

/** A macro defining NULL. */
class NULLMacro extends Macro {
  NULLMacro() { this.getHead() = "NULL" }
}

/** A use of the NULL macro. */
class NULL extends Literal {
  NULL() { exists(NULLMacro nm | this = nm.getAnInvocation().getAnExpandedElement()) }
}

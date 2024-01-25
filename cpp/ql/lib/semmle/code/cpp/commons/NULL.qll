import semmle.code.cpp.Macro

/** A macro defining NULL. */
class NullMacro extends Macro {
  NullMacro() { this.getHead() = "NULL" }
}

/** A use of the NULL macro. */
class NULL extends Literal {
  NULL() { exists(NullMacro nm | this = nm.getAnInvocation().getAnExpandedElement()) }
}

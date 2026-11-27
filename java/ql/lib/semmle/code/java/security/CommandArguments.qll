/**
 * Definitions for reasoning about lists and arrays that are to be used as arguments to an external process.
 */
overlay[local?]
module;

import java
import semmle.code.java.dataflow.SSA
import semmle.code.java.Collections

/**
 * Holds if `ex` is used safely as an argument to a command;
 * i.e. it's not in a position that selects a command to execute, and the executed command is not a shell.
 */
predicate isSafeCommandArgument(Expr ex) {
  exists(ArrayInit ai, int i |
    ex = ai.getInit(i) and
    i > 0 and
    not isShell(ai.getInit(0)) and
    not exists(int cmdIndex | cmdIndex = delegatedCommandIndex(ai.getInit(0)) |
      i = cmdIndex
      or
      i > cmdIndex and isShellOrLauncher(ai.getInit(cmdIndex))
    )
  )
  or
  exists(CommandArgumentList cal, MethodCall add |
    not cal.isShell() and
    add = cal.getASubsequentAdd() and
    ex = add.getArgument(0) and
    not exists(int cmdIndex | cmdIndex = delegatedCommandIndex(cal.getAFirstAdd().getArgument(0)) |
      add = cal.getAnAddAtIndex(cmdIndex)
      or
      not add = cal.getAnAddAtIndex([1 .. cmdIndex - 1]) and
      isShellOrLauncher(cal.getAnAddAtIndex(cmdIndex).getArgument(0))
    )
  )
  or
  exists(CommandArgArrayImmutableFirst caa, int i |
    not caa.isShell() and
    i > 0 and
    ex = caa.getAWrite(i) and
    not exists(int cmdIndex | cmdIndex = delegatedCommandIndex(caa.getFirstElement()) |
      i = cmdIndex
      or
      i > cmdIndex and isShellOrLauncher(caa.getAnElement(cmdIndex))
    )
  )
}

/** Gets a string command name that `ex` may evaluate to. */
private string commandName(Expr ex) {
  result = ex.(CompileTimeConstantExpr).getStringValue()
  or
  exists(SsaDefinition ssa, SsaExplicitWrite def |
    ex = ssa.getARead() and
    result = commandName(def.getDefiningExpr())
  |
    ssa.getAnUltimateDefinition() = def
    or
    ssa.(SsaCapturedDefinition).getAnUltimateCapturedDefinition() = def
  )
  or
  result = commandName(ex.(Assignment).getRhs())
  or
  result = commandName(ex.(LocalVariableDeclExpr).getInit())
}

/**
 * Holds if the given expression is the name of a shell command such as bash or python.
 */
private predicate isShell(Expr ex) {
  commandName(ex).regexpMatch(".*(sh|javac?|python[23]?|osascript|cmd)(\\.exe)?$")
}

/**
 * Gets the fixed position of the command executed by a supported delegating launcher.
 *
 * Only simple invocation forms with a command at the expected position are recognized. Launcher
 * options and environment assignments are intentionally not interpreted.
 */
private int delegatedCommandIndex(Expr ex) {
  exists(string launcher |
    launcher = commandName(ex).regexpCapture("(.*[/\\\\])?([^/\\\\.]+)(\\.exe)?$", 2) and
    (
      launcher = ["env", "nice", "nohup", "setsid", "sudo", "xargs"] and result = 1
      or
      launcher = ["chroot", "stdbuf", "timeout"] and result = 2
    )
  )
}

/** Holds if `ex` may evaluate to a shell or a supported delegating launcher. */
private predicate isShellOrLauncher(Expr ex) { isShell(ex) or exists(delegatedCommandIndex(ex)) }

/**
 * A type that could be a list of strings. Includes raw `List` types.
 */
private class ListOfStringType extends CollectionType {
  ListOfStringType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "List") and
    this.getElementType().getADescendant() instanceof TypeString
  }
}

/**
 * A variable that could be used as a list of arguments to a command.
 */
private class CommandArgumentList extends SsaExplicitWrite {
  CommandArgumentList() {
    this.getSourceVariable().getType() instanceof ListOfStringType and
    forex(CollectionMutation ma | ma.getQualifier() = this.getARead() |
      ma.getMethod().getName().startsWith("add")
    )
  }

  /** Gets a use of the variable for which the list could be empty. */
  private VarRead getAUseBeforeFirstAdd() {
    result = ssaGetAFirstUse(this)
    or
    exists(VarRead mid |
      mid = this.getAUseBeforeFirstAdd() and
      adjacentUseUse(mid, result) and
      not exists(MethodCall ma |
        mid = ma.getQualifier() and
        ma.getMethod().hasName("add")
      )
    )
  }

  /**
   * Gets an addition to this list, i.e. a call to an `add` or `addAll` method.
   */
  MethodCall getAnAdd() {
    result.getQualifier() = this.getARead() and
    result.getMethod().getName().startsWith("add")
  }

  /** Gets an addition to this list which could be its first element. */
  MethodCall getAFirstAdd() {
    result = this.getAnAdd() and
    result.getQualifier() = this.getAUseBeforeFirstAdd()
  }

  /** Gets an addition to this list which is not the first element. */
  MethodCall getASubsequentAdd() {
    result = this.getAnAdd() and
    not result = this.getAFirstAdd()
  }

  /**
   * Gets a use of the variable at which the list could have `index` elements,
   * for `index` in `0 .. 2`.
   */
  private VarRead getAUseAtIndex(int index) {
    index = 0 and result = this.getAUseBeforeFirstAdd()
    or
    index in [1 .. 2] and
    exists(VarRead mid |
      adjacentUseUse(mid, result) and
      (
        mid = this.getAUseAtIndex(index - 1) and
        exists(MethodCall ma |
          mid = ma.getQualifier() and
          ma.getMethod().hasName("add") and
          ma.getNumArgument() = 1
        )
        or
        mid = this.getAUseAtIndex(index) and
        not mid = this.getAnAdd().getQualifier()
      )
    )
  }

  /** Gets an addition to this list that could start at `index`, for `index` in `1 .. 2`. */
  MethodCall getAnAddAtIndex(int index) {
    index in [1 .. 2] and
    result = this.getAnAdd() and
    result.getQualifier() = this.getAUseAtIndex(index)
  }

  /** Holds if the first element of this list is a shell command. */
  predicate isShell() {
    exists(MethodCall ma | ma = this.getAFirstAdd() and isShell(ma.getArgument(0)))
  }
}

/**
 * The type `String[]`.
 */
private class ArrayOfStringType extends Array {
  ArrayOfStringType() {
    this.getDimension() = 1 and
    this.getElementType() instanceof TypeString
  }
}

private predicate arrayVarWrite(ArrayAccess acc) { exists(Assignment a | a.getDest() = acc) }

/**
 * A variable that could be an array of arguments to a command.
 */
private class CommandArgumentArray extends SsaExplicitWrite {
  CommandArgumentArray() {
    this.getSourceVariable().getType() instanceof ArrayOfStringType and
    forall(ArrayAccess a | a.getArray() = this.getARead() and arrayVarWrite(a) |
      a.getIndexExpr() instanceof CompileTimeConstantExpr
    )
  }

  /** Gets an expression that is written to the given index of this array at the given use. */
  Expr getAWrite(int index, VarRead use) {
    exists(Assignment a, ArrayAccess acc |
      acc.getArray() = use and
      use = this.getARead() and
      index = acc.getIndexExpr().(CompileTimeConstantExpr).getIntValue() and
      acc = a.getDest() and
      result = a.getRhs()
    )
  }

  /** Gets an expression that is written to the given index of this array. */
  Expr getAWrite(int index) { result = this.getAWrite(index, _) }
}

/**
 * A `CommandArgumentArray` whose element at index 0 is never written to, except possibly once to initialise it.
 */
private class CommandArgArrayImmutableFirst extends CommandArgumentArray {
  CommandArgArrayImmutableFirst() {
    (exists(this.getAWrite(0)) or exists(arrayElementOf(this.getDefiningExpr(), 0))) and
    forall(VarRead use | exists(this.getAWrite(0, use)) | use = ssaGetAFirstUse(this))
  }

  /** Gets an expression that may be stored at `index`, for `index` in `0 .. 2`. */
  Expr getAnElement(int index) {
    index in [0 .. 2] and
    (
      result = this.getAWrite(index)
      or
      (index > 0 or not exists(this.getAWrite(0))) and
      result = arrayElementOf(this.getDefiningExpr(), index)
    )
  }

  /** Gets the first element of this array. */
  Expr getFirstElement() { result = this.getAnElement(0) }

  /** Holds if the first element of this array is a shell command. */
  predicate isShell() { isShell(this.getFirstElement()) }
}

/** Gets an expression for the element at `index` of an array of strings `arr`, for `index` in `0 .. 2`. */
private Expr arrayElementOf(Expr arr, int index) {
  index in [0 .. 2] and
  arr.getType() instanceof ArrayOfStringType and
  (
    result = arrayElementOf(arr.(Assignment).getRhs(), index)
    or
    result = arrayElementOf(arr.(LocalVariableDeclExpr).getInit(), index)
    or
    exists(CommandArgArrayImmutableFirst caa | arr = caa.getARead() |
      result = caa.getAnElement(index)
    )
    or
    exists(MethodCall ma |
      arr = ma and
      ma.getMethod().hasQualifiedName("java.util", "Arrays", "copyOf") and
      result = arrayElementOf(ma.getArgument(0), index)
    )
    or
    exists(Field f |
      f.isStatic() and
      arr.(FieldRead).getField() = f and
      result = arrayElementOf(f.getInitializer(), index)
    )
    or
    result = arr.(ArrayInit).getInit(index)
    or
    result = arr.(ArrayCreationExpr).getInit().getInit(index)
  )
}

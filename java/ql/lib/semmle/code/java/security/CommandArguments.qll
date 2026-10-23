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
 * i.e. it's not in a position that selects a command to execute.
 */
predicate isSafeCommandArgument(Expr ex) {
  exists(ArrayInit init, int index |
    ex = init.getInit(index) and
    index > 0 and
    isNonDelegatingCommand(init.getInit(0))
  )
  or
  exists(CommandArgumentList list |
    not list.isShell() and
    not list.isDelegatingLauncher() and
    ex = list.getASubsequentAdd().getArgument(0)
  )
  or
  exists(CommandArgArrayImmutableFirst array |
    not array.isShell() and
    not array.isDelegatingLauncher() and
    ex = array.getAWrite(any(int index | index > 0))
  )
  or
  forex(CommandArguments arguments, int index | ex = arguments.getArgument(index) |
    index > 0 and arguments.hasSafeDelegatedArgument(index)
  )
}

private string commandName(Expr ex) {
  result = ex.(StringLiteral).getValue()
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
 * Holds if the given expression is the name of a shell command such as bash or python
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
    launcher = commandName(ex).regexpCapture("(.*/)?([^/.]+)(\\.exe)?$", 2) and
    (
      launcher = ["env", "nice", "nohup", "setsid", "sudo", "xargs"] and result = 1
      or
      launcher = ["chroot", "stdbuf", "timeout"] and result = 2
    )
  )
}

private predicate isNonDelegatingCommand(Expr ex) {
  exists(commandName(ex)) and
  not isShell(ex) and
  not exists(delegatedCommandIndex(ex))
}

/** Holds if `init` initializes an array passed directly to a call. */
private predicate isInlineArgumentArray(ArrayInit init) {
  exists(ArrayCreationExpr array, Call call |
    array.getInit() = init and
    array = call.getAnArgument() and
    not exists(MethodCall methodCall |
      call = methodCall and
      methodCall.getMethod().getDeclaringType().hasQualifiedName("java.util", "Arrays") and
      methodCall.getMethod().hasName("copyOf")
    )
  )
}

private newtype TCommandArguments =
  TLiteralArguments(ArrayInit init) { isInlineArgumentArray(init) } or
  TListArguments(CommandArgumentList list) or
  TMutableArguments(CommandArgArrayImmutableFirst array)

/** An ordered sequence of command arguments. */
private class CommandArguments extends TCommandArguments {
  string toString() { result = this.getArgument(0).toString() }

  /** Gets a possible value at the given index. */
  Expr getArgument(int index) {
    exists(ArrayInit init |
      this = TLiteralArguments(init) and
      result = init.getInit(index)
    )
    or
    exists(CommandArgumentList list |
      this = TListArguments(list) and
      (
        result = list.getArgument(index)
        or
        index = 3 and result = list.getAnArgumentAfterKnownPrefix().getArgument(0)
      )
    )
    or
    exists(CommandArgArrayImmutableFirst array |
      this = TMutableArguments(array) and
      result = array.getAnElement(index)
    )
  }

  /** Gets the single string literal stored at the given index, if there is one. */
  private StringLiteral getFixedLiteralArgument(int index) {
    forex(Expr value | value = this.getArgument(index) | value = result)
  }

  predicate hasSafeDelegatedArgument(int index) {
    exists(this.getArgument(index)) and
    forex(Expr launcher | launcher = this.getArgument(0) |
      forex(int commandIndex | commandIndex = delegatedCommandIndex(launcher) |
        (
          index < commandIndex
          or
          index > commandIndex and
          exists(StringLiteral command |
            command = this.getFixedLiteralArgument(commandIndex) and
            not isShell(command) and
            not exists(delegatedCommandIndex(command))
          )
        )
      )
    )
  }
}

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
      ma.getMethod().getName().matches("add%")
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
    result.getMethod().getName().matches("add%")
  }

  /** Gets an addition to this list which could be its first element. */
  MethodCall getAFirstAdd() {
    result = this.getAnAdd() and
    result.getQualifier() = this.getAUseBeforeFirstAdd()
  }

  /** Gets a single-element addition at the given index. */
  private MethodCall getAnAddAtIndex(int index) {
    index = 0 and
    result = this.getAFirstAdd() and
    result.getMethod().hasName("add") and
    result.getNumArgument() = 1
    or
    index > 0 and
    index <= 2 and
    exists(MethodCall previous |
      previous = this.getAnAddAtIndex(index - 1) and
      result = this.getAnAdd() and
      result.getMethod().hasName("add") and
      result.getNumArgument() = 1 and
      adjacentUseUse(previous.getQualifier(), result.getQualifier())
    )
  }

  /** Gets a single-element addition after the first three elements. */
  MethodCall getAnArgumentAfterKnownPrefix() {
    result = this.getAnAdd() and
    result.getMethod().hasName("add") and
    result.getNumArgument() = 1 and
    exists(MethodCall previous |
      previous = this.getAnAddAtIndex(2) or previous = this.getAnArgumentAfterKnownPrefix()
    |
      adjacentUseUse(previous.getQualifier(), result.getQualifier())
    )
  }

  /** Gets the argument added at the given index. */
  Expr getArgument(int index) { result = this.getAnAddAtIndex(index).getArgument(0) }

  /** Gets an addition to this list which is not the first element. */
  MethodCall getASubsequentAdd() {
    result = this.getAnAdd() and
    not result = this.getAFirstAdd()
  }

  /** Holds if the first element of this list is a shell command. */
  predicate isShell() {
    exists(MethodCall add | add = this.getAFirstAdd() and isShell(add.getArgument(0)))
  }

  /** Holds if the first element of this list is a delegating launcher. */
  predicate isDelegatingLauncher() {
    exists(MethodCall add | add = this.getAFirstAdd() |
      exists(delegatedCommandIndex(add.getArgument(0)))
    )
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
 * A `CommandArgArray` whose element at index 0 is never written to, except possibly once to initialise it.
 */
private class CommandArgArrayImmutableFirst extends CommandArgumentArray {
  CommandArgArrayImmutableFirst() {
    (exists(this.getAWrite(0)) or exists(arrayElementOf(this.getDefiningExpr(), 0))) and
    forall(VarRead use | exists(this.getAWrite(0, use)) | use = ssaGetAFirstUse(this))
  }

  /** Gets the first element of this array. */
  Expr getFirstElement() {
    result = this.getAWrite(0)
    or
    not exists(this.getAWrite(0)) and
    result = arrayElementOf(this.getDefiningExpr(), 0)
  }

  /** Holds if the first element of this array is a shell command. */
  predicate isShell() { isShell(this.getFirstElement()) }

  /** Holds if the first element of this array is a delegating launcher. */
  predicate isDelegatingLauncher() { exists(delegatedCommandIndex(this.getFirstElement())) }

  /** Gets a possible value for the element at the given index. */
  Expr getAnElement(int index) {
    index = 0 and result = this.getFirstElement()
    or
    index > 0 and
    (
      result = this.getAWrite(index)
      or
      result = arrayElementOf(this.getDefiningExpr(), index)
    )
  }
}

/** Gets an element of an immutable array of strings. */
private Expr arrayElementOf(Expr arr, int index) {
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
    exists(MethodCall ma, Method m |
      arr = ma and
      ma.getMethod() = m and
      m.getDeclaringType().hasQualifiedName("java.util", "Arrays") and
      m.hasName("copyOf") and
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

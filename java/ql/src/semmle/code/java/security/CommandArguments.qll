/**
 * Definitions for reasoning about lists and arrays that are to be used as arguments to an external process.
 */

import java
import semmle.code.java.dataflow.SSA
import semmle.code.java.Collections

/**
 * Holds if `ex` is used safely as an argument to a command;
 * i.e. it's not in the first position and it's not a shell command.
 */
predicate isSafeCommandArgument(Expr ex) {
  exists(ArrayInit ai, int i |
    ex = ai.getInit(i) and
    i > 0 and
    not isShell(ai.getInit(0))
  )
  or
  exists(CommandArgumentList cal |
    not cal.isShell() and
    ex = cal.getASubsequentAdd().getArgument(0)
  )
  or
  exists(CommandArgArrayImmutableFirst caa |
    not caa.isShell() and
    ex = caa.getAWrite(any(int i | i > 0))
  )
}

/**
 * Holds if the given expression is the name of a shell command such as bash or python
 */
private predicate isShell(Expr ex) {
  exists(string cmd | cmd = ex.(StringLiteral).getValue() |
    cmd.regexpMatch(".*(sh|javac?|python[23]?|osascript|cmd)(\\.exe)?$")
  )
  or
  exists(SsaVariable ssa |
    ex = ssa.getAUse() and
    isShell(ssa.getAnUltimateDefinition().(SsaExplicitUpdate).getDefiningExpr())
  )
  or
  isShell(ex.(Assignment).getRhs())
  or
  isShell(ex.(LocalVariableDeclExpr).getInit())
}

/**
 * A type that could be a list of strings. Includes raw `List` types.
 */
private class ListOfStringType extends CollectionType {
  ListOfStringType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "List") and
    this.getElementType().getASubtype*() instanceof TypeString
  }
}

/**
 * A variable that could be used as a list of arguments to a command.
 */
private class CommandArgumentList extends SsaExplicitUpdate {
  CommandArgumentList() {
    this.getSourceVariable().getType() instanceof ListOfStringType and
    forex(CollectionMutation ma | ma.getQualifier() = this.getAUse() |
      ma.getMethod().getName().matches("add%")
    )
  }

  /** Gets a use of the variable for which the list could be empty. */
  private RValue getAUseBeforeFirstAdd() {
    result = getAFirstUse()
    or
    exists(RValue mid |
      mid = getAUseBeforeFirstAdd() and
      adjacentUseUse(mid, result) and
      not exists(MethodAccess ma |
        mid = ma.getQualifier() and
        ma.getMethod().hasName("add")
      )
    )
  }

  /**
   * Gets an addition to this list, i.e. a call to an `add` or `addAll` method.
   */
  MethodAccess getAnAdd() {
    result.getQualifier() = getAUse() and
    result.getMethod().getName().matches("add%")
  }

  /** Gets an addition to this list which could be its first element. */
  MethodAccess getAFirstAdd() {
    result = getAnAdd() and
    result.getQualifier() = getAUseBeforeFirstAdd()
  }

  /** Gets an addition to this list which is not the first element. */
  MethodAccess getASubsequentAdd() {
    result = getAnAdd() and
    not result = getAFirstAdd()
  }

  /** Holds if the first element of this list is a shell command. */
  predicate isShell() {
    exists(MethodAccess ma | ma = getAFirstAdd() and isShell(ma.getArgument(0)))
  }
}

/**
 * The type `String[]`.
 */
private class ArrayOfStringType extends Array {
  ArrayOfStringType() { this.getElementType() instanceof TypeString }
}

private predicate arrayLValue(ArrayAccess acc) { exists(Assignment a | a.getDest() = acc) }

/**
 * A variable that could be an array of arguments to a command.
 */
private class CommandArgumentArray extends SsaExplicitUpdate {
  CommandArgumentArray() {
    this.getSourceVariable().getType() instanceof ArrayOfStringType and
    forall(ArrayAccess a | a.getArray() = getAUse() and arrayLValue(a) |
      a.getIndexExpr() instanceof CompileTimeConstantExpr
    )
  }

  /** Gets an expression that is written to the given index of this array at the given use. */
  Expr getAWrite(int index, RValue use) {
    exists(Assignment a, ArrayAccess acc |
      acc.getArray() = use and
      use = this.getAUse() and
      index = acc.getIndexExpr().(CompileTimeConstantExpr).getIntValue() and
      acc = a.getDest() and
      result = a.getRhs()
    )
  }

  /** Gets an expression that is written to the given index of this array. */
  Expr getAWrite(int index) { result = getAWrite(index, _) }
}

/**
 * A `CommandArgArray` whose element at index 0 is never written to, except possibly once to initialise it.
 */
private class CommandArgArrayImmutableFirst extends CommandArgumentArray {
  CommandArgArrayImmutableFirst() {
    (exists(getAWrite(0)) or exists(firstElementOf(this.getDefiningExpr()))) and
    forall(RValue use | exists(this.getAWrite(0, use)) | use = this.getAFirstUse())
  }

  /** Gets the first element of this array. */
  Expr getFirstElement() {
    result = getAWrite(0)
    or
    not exists(getAWrite(0)) and
    result = firstElementOf(getDefiningExpr())
  }

  /** Holds if the first element of this array is a shell command. */
  predicate isShell() { isShell(getFirstElement()) }
}

/** Gets the first element of an imutable array of strings */
private Expr firstElementOf(Expr arr) {
  arr.getType() instanceof ArrayOfStringType and
  (
    result = firstElementOf(arr.(Assignment).getRhs())
    or
    result = firstElementOf(arr.(LocalVariableDeclExpr).getInit())
    or
    exists(CommandArgArrayImmutableFirst caa | arr = caa.getAUse() | result = caa.getFirstElement())
    or
    exists(MethodAccess ma, Method m |
      arr = ma and
      ma.getMethod() = m and
      m.getDeclaringType().hasQualifiedName("java.util", "Arrays") and
      m.hasName("copyOf") and
      result = firstElementOf(ma.getArgument(0))
    )
    or
    exists(Field f |
      f.isStatic() and
      arr.(FieldRead).getField() = f and
      result = firstElementOf(f.getInitializer())
    )
    or
    result = arr.(ArrayInit).getInit(0)
    or
    result = arr.(ArrayCreationExpr).getInit().getInit(0)
  )
}

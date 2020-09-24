/**
 * Provides classes for identifying and reasoning about Microsoft source code
 * annotation language (SAL) macros.
 */

import cpp

/**
 * A SAL macro defined in `sal.h` or a similar header file.
 */
class SALMacro extends Macro {
  SALMacro() {
    exists(string filename | filename = this.getFile().getBaseName() |
      filename = "sal.h" or
      filename = "specstrings_strict.h" or
      filename = "specstrings.h" or
      filename = "w32p.h" or
      filename = "minwindef.h"
    ) and
    (
      // Dialect for Windows 8 and above
      this.getName().matches("\\_%\\_")
      or
      // Dialect for Windows 7
      this.getName().matches("\\_\\_%")
    )
  }
}

pragma[noinline]
private predicate isTopLevelMacroAccess(MacroAccess ma) { not exists(ma.getParentInvocation()) }

/**
 * An invocation of a SAL macro (excluding invocations inside other macros).
 */
class SALAnnotation extends MacroInvocation {
  SALAnnotation() {
    this.getMacro() instanceof SALMacro and
    isTopLevelMacroAccess(this)
  }

  /** Gets the `Declaration` annotated by `this`. */
  Declaration getDeclaration() {
    annotatesAt(this, result.getADeclarationEntry(), _, _) and
    not result instanceof Type // exclude typedefs
  }

  /** Gets the `DeclarationEntry` annotated by `this`. */
  DeclarationEntry getDeclarationEntry() {
    annotatesAt(this, result, _, _) and
    not result instanceof TypeDeclarationEntry // exclude typedefs
  }
}

/**
 * A SAL macro indicating that the return value of a function should always be
 * checked.
 */
class SALCheckReturn extends SALAnnotation {
  SALCheckReturn() {
    exists(SALMacro m | m = this.getMacro() |
      m.getName() = "_Check_return_" or
      m.getName() = "_Must_inspect_result_"
    )
  }
}

/**
 * A SAL macro indicating that a pointer variable or return value should not be
 * `NULL`.
 */
class SALNotNull extends SALAnnotation {
  SALNotNull() {
    exists(SALMacro m | m = this.getMacro() |
      not m.getName().matches("%\\_opt\\_%") and
      (
        m.getName().matches("_In%") or
        m.getName().matches("_Out%") or
        m.getName() = "_Ret_notnull_"
      )
    ) and
    exists(Type t |
      t = this.getDeclaration().(Variable).getType() or
      t = this.getDeclaration().(Function).getType()
    |
      t.getUnspecifiedType() instanceof PointerType
    )
  }
}

/**
 * A SAL macro indicating that a value may be `NULL`.
 */
class SALMaybeNull extends SALAnnotation {
  SALMaybeNull() {
    exists(SALMacro m | m = this.getMacro() |
      m.getName().matches("%\\_opt\\_%") or
      m.getName().matches("\\_Ret_maybenull\\_%") or
      m.getName() = "_Result_nullonfailure_"
    )
  }
}

/**
 * A parameter annotated by one or more SAL annotations.
 */
class SALParameter extends Parameter {
  /** One of this parameter's annotations. */
  SALAnnotation a;

  SALParameter() { annotatesAt(a, this.getADeclarationEntry(), _, _) }

  predicate isIn() { a.getMacroName().toLowerCase().matches("%\\_in%") }

  predicate isOut() { a.getMacroName().toLowerCase().matches("%\\_out%") }

  predicate isInOut() { a.getMacroName().toLowerCase().matches("%\\_inout%") }
}

///////////////////////////////////////////////////////////////////////////////
// Implementation details
/**
 * Holds if `a` annotates the declaration entry `d` and
 * its start position is the `idx`th position in `file` that holds a SAL element.
 */
private predicate annotatesAt(SALAnnotation a, DeclarationEntry d, File file, int idx) {
  annotatesAtPosition(a.(SALElement).getStartPosition(), d, file, idx)
}

/**
 * Holds if `pos` is the `idx`th position in `file` that holds a SAL element,
 * which annotates the declaration entry `d` (by occurring before it without
 * any other declaration entries in between).
 */
// For performance reasons, do not mention the annotation itself here,
// but compute with positions instead. This performs better on databases
// with many annotations at the same position.
private predicate annotatesAtPosition(SALPosition pos, DeclarationEntry d, File file, int idx) {
  pos = salRelevantPositionAt(file, idx) and
  salAnnotationPos(pos) and
  (
    // Base case: `pos` right before `d`
    d.(SALElement).getStartPosition() = salRelevantPositionAt(file, idx + 1)
    or
    // Recursive case: `pos` right before some annotation on `d`
    annotatesAtPosition(_, d, file, idx + 1)
  )
}

/**
 * A SAL element, that is, a SAL annotation or a declaration entry
 * that may have SAL annotations.
 */
library class SALElement extends Element {
  SALElement() {
    containsSALAnnotation(this.(DeclarationEntry).getFile()) or
    this instanceof SALAnnotation
  }

  predicate hasStartPosition(File file, int line, int col) {
    exists(Location loc | loc = this.getLocation() |
      file = loc.getFile() and
      line = loc.getStartLine() and
      col = loc.getStartColumn()
    )
  }

  predicate hasEndPosition(File file, int line, int col) {
    exists(Location loc |
      loc = this.(FunctionDeclarationEntry).getBlock().getLocation()
      or
      this =
        any(VariableDeclarationEntry vde |
          vde.isDefinition() and
          loc = vde.getVariable().getInitializer().getLocation()
        )
    |
      file = loc.getFile() and
      line = loc.getEndLine() and
      col = loc.getEndColumn()
    )
  }

  SALPosition getStartPosition() {
    exists(File file, int line, int col |
      this.hasStartPosition(file, line, col) and
      result = MkSALPosition(file, line, col)
    )
  }
}

/** Holds if `file` contains a SAL annotation. */
pragma[noinline]
private predicate containsSALAnnotation(File file) { any(SALAnnotation a).getFile() = file }

/**
 * A source-file position of a `SALElement`. Unlike location, this denotes a
 * point in the file rather than a range.
 */
private newtype SALPosition =
  MkSALPosition(File file, int line, int col) {
    exists(SALElement e |
      e.hasStartPosition(file, line, col)
      or
      e.hasEndPosition(file, line, col)
    )
  }

/** Holds if `pos` is the start position of a SAL annotation. */
pragma[noinline]
private predicate salAnnotationPos(SALPosition pos) {
  any(SALAnnotation a).(SALElement).getStartPosition() = pos
}

/**
 * Gets the `idx`th position in `file` that holds a SAL element,
 * ordering positions lexicographically by their start line and start column.
 */
private SALPosition salRelevantPositionAt(File file, int idx) {
  result =
    rank[idx](SALPosition pos, int line, int col |
      pos = MkSALPosition(file, line, col)
    |
      pos order by line, col
    )
}

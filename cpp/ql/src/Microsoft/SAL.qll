/**
 * Provides classes for identifying and reasoning about Microsoft source code
 * annotation language (SAL) macros.
 */

import cpp

/**
 * A SAL macro defined in `sal.h` or a similar header file.
 */
class SalMacro extends Macro {
  SalMacro() {
    this.getFile().getBaseName() =
      ["sal.h", "specstrings_strict.h", "specstrings.h", "w32p.h", "minwindef.h"] and
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
class SalAnnotation extends MacroInvocation {
  SalAnnotation() {
    this.getMacro() instanceof SalMacro and
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
class SalCheckReturn extends SalAnnotation {
  SalCheckReturn() {
    this.getMacro().(SalMacro).getName() = ["_Check_return_", "_Must_inspect_result_"]
  }
}

/**
 * A SAL macro indicating that a pointer variable or return value should not be
 * `NULL`.
 */
class SalNotNull extends SalAnnotation {
  SalNotNull() {
    exists(SalMacro m | m = this.getMacro() |
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
class SalMaybeNull extends SalAnnotation {
  SalMaybeNull() {
    exists(SalMacro m | m = this.getMacro() |
      m.getName().matches("%\\_opt\\_%") or
      m.getName().matches("\\_Ret_maybenull\\_%") or
      m.getName() = "_Result_nullonfailure_"
    )
  }
}

/**
 * A parameter annotated by one or more SAL annotations.
 */
class SalParameter extends Parameter {
  /** One of this parameter's annotations. */
  SalAnnotation a;

  SalParameter() { annotatesAt(a, this.getADeclarationEntry(), _, _) }

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
private predicate annotatesAt(SalAnnotation a, DeclarationEntry d, File file, int idx) {
  annotatesAtPosition(a.(SalElement).getStartPosition(), d, file, idx)
}

/**
 * Holds if `pos` is the `idx`th position in `file` that holds a SAL element,
 * which annotates the declaration entry `d` (by occurring before it without
 * any other declaration entries in between).
 */
// For performance reasons, do not mention the annotation itself here,
// but compute with positions instead. This performs better on databases
// with many annotations at the same position.
private predicate annotatesAtPosition(SalPosition pos, DeclarationEntry d, File file, int idx) {
  pos = salRelevantPositionAt(file, idx) and
  salAnnotationPos(pos) and
  (
    // Base case: `pos` right before `d`
    d.(SalElement).getStartPosition() = salRelevantPositionAt(file, idx + 1)
    or
    // Recursive case: `pos` right before some annotation on `d`
    annotatesAtPosition(_, d, file, idx + 1)
  )
}

/**
 * A SAL element, that is, a SAL annotation or a declaration entry
 * that may have SAL annotations.
 */
class SalElement extends Element {
  SalElement() {
    containsSalAnnotation(this.(DeclarationEntry).getFile()) or
    this instanceof SalAnnotation
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

  SalPosition getStartPosition() {
    exists(File file, int line, int col |
      this.hasStartPosition(file, line, col) and
      result = MkSalPosition(file, line, col)
    )
  }
}

/** Holds if `file` contains a SAL annotation. */
pragma[noinline]
private predicate containsSalAnnotation(File file) { any(SalAnnotation a).getFile() = file }

/**
 * A source-file position of a `SALElement`. Unlike location, this denotes a
 * point in the file rather than a range.
 */
private newtype SalPosition =
  MkSalPosition(File file, int line, int col) {
    exists(SalElement e |
      e.hasStartPosition(file, line, col)
      or
      e.hasEndPosition(file, line, col)
    )
  }

/** Holds if `pos` is the start position of a SAL annotation. */
pragma[noinline]
private predicate salAnnotationPos(SalPosition pos) {
  any(SalAnnotation a).(SalElement).getStartPosition() = pos
}

/**
 * Gets the `idx`th position in `file` that holds a SAL element,
 * ordering positions lexicographically by their start line and start column.
 */
private SalPosition salRelevantPositionAt(File file, int idx) {
  result =
    rank[idx](SalPosition pos, int line, int col |
      pos = MkSalPosition(file, line, col)
    |
      pos order by line, col
    )
}

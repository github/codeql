/** Provides the `VariableWithFields` class, for working with variables with a chain of field or element accesses chained to it. */

import go

private newtype TVariableWithFields =
  TVariableRoot(Variable v) or
  TVariableFieldStep(VariableWithFields base, Field f) {
    exists(fieldAccessPathAux(base, f)) or exists(fieldWriteAccessPathAux(base, f))
  } or
  TVariableElementStep(VariableWithFields base, string e) {
    exists(elementAccessPathAux(base, e)) or exists(elementWriteAccessPathAux(base, e))
  }

/**
 * Gets a representation of the write target `wt` as a variable with fields value if there is one.
 */
private TVariableWithFields writeAccessPath(IR::WriteTarget wt) {
  exists(Variable v | wt = v.getAWrite().getLhs() | result = TVariableRoot(v))
  or
  exists(VariableWithFields base, Field f | wt = fieldWriteAccessPathAux(base, f) |
    result = TVariableFieldStep(base, f)
  )
  or
  exists(VariableWithFields base, string e | wt = elementWriteAccessPathAux(base, e) |
    result = TVariableElementStep(base, e)
  )
}

/**
 * Gets a representation of `insn` as a variable with fields value if there is one.
 */
private TVariableWithFields accessPath(IR::Instruction insn) {
  exists(Variable v | insn = v.getARead().asInstruction() | result = TVariableRoot(v))
  or
  exists(VariableWithFields base, Field f | insn = fieldAccessPathAux(base, f) |
    result = TVariableFieldStep(base, f)
  )
  or
  exists(VariableWithFields base, string e | insn = elementAccessPathAux(base, e) |
    result = TVariableElementStep(base, e)
  )
}

/**
 * Gets an IR instruction that reads a field `f` from a node that is represented
 * by variable with fields value `base`.
 */
private IR::Instruction fieldAccessPathAux(TVariableWithFields base, Field f) {
  exists(IR::FieldReadInstruction fr, IR::Instruction frb |
    fr.getBase() = frb or
    fr.getBase() = IR::implicitDerefInstruction(frb.(IR::EvalInstruction).getExpr())
  |
    base = accessPath(frb) and
    f = fr.getField() and
    result = fr
  )
}

/**
 * Gets an IR write target that represents a field `f` from a node that is represented
 * by variable with fields value `base`.
 */
private IR::WriteTarget fieldWriteAccessPathAux(TVariableWithFields base, Field f) {
  exists(IR::FieldTarget ft, IR::Instruction ftb |
    ft.getBase() = ftb or
    ft.getBase() = IR::implicitDerefInstruction(ftb.(IR::EvalInstruction).getExpr())
  |
    base = accessPath(ftb) and
    ft.getField() = f and
    result = ft
  )
}

/**
 * Gets an IR instruction that reads an element `e` from a node that is represented
 * by variable with fields value `base`.
 */
private IR::Instruction elementAccessPathAux(TVariableWithFields base, string e) {
  exists(IR::ElementReadInstruction er, IR::EvalInstruction erb |
    er.getBase() = erb or
    er.getBase() = IR::implicitDerefInstruction(erb.getExpr())
  |
    base = accessPath(erb) and
    e = er.getIndex().getExactValue() and
    result = er
  )
}

/**
 * Gets an IR write target that represents an element `e` from a node that is represented
 * by variable with fields value `base`.
 */
private IR::WriteTarget elementWriteAccessPathAux(TVariableWithFields base, string e) {
  exists(IR::ElementTarget et, IR::EvalInstruction etb |
    et.getBase() = etb or
    et.getBase() = IR::implicitDerefInstruction(etb.getExpr())
  |
    base = accessPath(etb) and
    e = et.getIndex().getExactValue() and
    result = et
  )
}

/** A variable with zero or more fields or elements read from it. */
class VariableWithFields extends TVariableWithFields {
  /**
   * Gets the variable corresponding to the base of this variable with fields.
   *
   * For example, the variable corresponding to `a` for the variable with fields
   * corresponding to `a.b[c]`.
   */
  Variable getBaseVariable() { this.getParent*() = TVariableRoot(result) }

  /**
   * Gets the variable with fields corresponding to the parent of this variable with fields.
   *
   * For example, the variable with fields corresponding to `a.b` for the variable with fields
   * corresponding to `a.b[c]`.
   */
  VariableWithFields getParent() {
    exists(VariableWithFields base |
      this = TVariableFieldStep(base, _) or this = TVariableElementStep(base, _)
    |
      result = base
    )
  }

  /** Gets a use that refers to this variable with fields. */
  DataFlow::Node getAUse() { this = accessPath(result.asInstruction()) }

  /** Gets the type of this variable with fields. */
  Type getType() {
    exists(IR::Instruction acc | this = accessPath(acc) | result = acc.getResultType())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(Variable var | this = TVariableRoot(var) | result = "(" + var + ")")
    or
    exists(VariableWithFields base, Field f | this = TVariableFieldStep(base, f) |
      result = base + "." + f.getName()
    )
    or
    exists(VariableWithFields base, string e | this = TVariableElementStep(base, e) |
      result = base + "[" + e + "]"
    )
  }

  /**
   * Gets the qualified name of the source variable or variable and fields that this represents.
   *
   * For example, for the variable with fields that represents the field `a.b[c]`, this would get the string
   * `"a.b.c"`.
   */
  string getQualifiedName() {
    exists(Variable v | this = TVariableRoot(v) | result = v.getName())
    or
    exists(VariableWithFields base, Field f | this = TVariableFieldStep(base, f) |
      result = base.getQualifiedName() + "." + f.getName()
    )
    or
    exists(VariableWithFields base, string e | this = TVariableElementStep(base, e) |
      result = base.getQualifiedName() + "." + e.replaceAll(".", "\\.")
    )
  }

  /**
   * Gets a write of this variable with fields.
   */
  Write getAWrite() { this = writeAccessPath(result.getLhs()) }

  /**
   * Gets the field that is the last step of this variable with fields, if any.
   *
   * For example, the field `c` for the variable with fields `a.b.c`.
   */
  Field getField() { this = TVariableFieldStep(_, result) }

  /**
   * Gets the element that this variable with fields reads, if any.
   *
   * For example, the string value of `c` for the variable with fields `a.b[c]`.
   */
  string getElement() { this = TVariableElementStep(_, result) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getBaseVariable().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

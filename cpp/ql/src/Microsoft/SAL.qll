import cpp

class SALMacro extends Macro {
  SALMacro() {
    this.getFile().getBaseName() = "sal.h" or
    this.getFile().getBaseName() = "specstrings_strict.h" or
    this.getFile().getBaseName() = "specstrings.h"
  }
}

class SALAnnotation extends MacroInvocation {
  SALAnnotation() {
    this.getMacro() instanceof SALMacro and
    not exists(this.getParentInvocation())
  }

  /** Returns the `Declaration` annotated by `this`. */
  Declaration getDeclaration() {
    annotatesAt(this, result.getADeclarationEntry(), _, _)
  }

  /** Returns the `DeclarationEntry` annotated by `this`. */
  DeclarationEntry getDeclarationEntry() {
    annotatesAt(this, result, _, _)
  }
}

/*
 * Particular SAL annotations of interest
 */

class SALCheckReturn extends SALAnnotation {
  SALCheckReturn() {
    exists(SALMacro m | m = this.getMacro() |
      m.getName() = "_Check_return_" or
      m.getName() = "_Must_inspect_result_"
    )
  }
}

class SALNotNull extends SALAnnotation {
  SALNotNull() {
    exists(SALMacro m | m = this.getMacro() |
      not m.getName().matches("%\\_opt\\_%") and
      (
        m.getName().matches("\\_In%") or
        m.getName().matches("\\_Out%") or
        m.getName() = "_Ret_notnull_"
      )
    )
    and
    exists(Type t
    | t = this.getDeclaration().(Variable).getType() or
      t = this.getDeclaration().(Function).getType()
    | t.getUnspecifiedType() instanceof PointerType
    )
  }
}

class SALMaybeNull extends SALAnnotation {
  SALMaybeNull() {
    exists(SALMacro m | m = this.getMacro() |
    m.getName().matches("%\\_opt\\_%") or
    m.getName().matches("\\_Ret_maybenull\\_%") or
    m.getName() = "_Result_nullonfailure_"
    )
  }
}

/*
 * Implementation details
 */

private predicate annotatesAt(SALAnnotation a, DeclarationEntry e,
                              File file, int idx) {
  a = salElementAt(file, idx) and
  (
    // Base case: `a` right before `e`
    e = salElementAt(file, idx + 1)
    or
    // Recursive case: `a` right before some annotation on `e`
    annotatesAt(_, e, file, idx + 1)
  )
}

library class SALElement extends Element {
  SALElement() {
    this instanceof DeclarationEntry or
    this instanceof SALAnnotation
  }
}

/** Gets the `idx`th `SALElement` in `file`. */
private SALElement salElementAt(File file, int idx) {
  interestingLoc(file, result, interestingStartPos(file, idx))
}

/** Holds if an SALElement element at character `result` comes at
 * position `idx` in `file`. */
private int interestingStartPos(File file, int idx) {
  result = rank[idx](int otherStart | interestingLoc(file, _, otherStart))
}

/** Holds if `element` in `file` is at character `startPos`. */
private predicate interestingLoc(File file, SALElement element, int startPos) {
  element.getLocation().charLoc(file, startPos, _)
}

/**
 * Common predicates used to exclude results from a query based on heuristics.
 */

import cpp

/**
 * Holds if the preprocessor branch `pbd` is on line `pbdStartLine` in file `file`.
 */
private predicate pbdLocation(PreprocessorBranchDirective pbd, string file, int pbdStartLine) {
  pbd.getLocation().hasLocationInfo(file, pbdStartLine, _, _, _)
}

/**
 * Holds if the body of the function `f` is on lines `fBlockStartLine` to `fBlockEndLine` in file `file`.
 */
private predicate functionLocation(Function f, string file, int fBlockStartLine, int fBlockEndLine) {
  f.getBlock().getLocation().hasLocationInfo(file, fBlockStartLine, _, fBlockEndLine, _)
}

/**
 * Holds if the function `f` is inside a preprocessor branch that may have code in another arm.
 */
predicate functionDefinedInIfDef(Function f) {
  exists(
    PreprocessorBranchDirective pbd, string file, int pbdStartLine, int pbdEndLine,
    int fBlockStartLine, int fBlockEndLine
  |
    functionLocation(f, file, fBlockStartLine, fBlockEndLine) and
    pbdLocation(pbd, file, pbdStartLine) and
    pbdLocation(pbd.getNext(), file, pbdEndLine) and
    pbdStartLine <= fBlockStartLine and
    pbdEndLine >= fBlockEndLine and
    // pbd is a preprocessor branch where multiple branches exist
    (
      pbd.getNext() instanceof PreprocessorElse or
      pbd instanceof PreprocessorElse or
      pbd.getNext() instanceof PreprocessorElif or
      pbd instanceof PreprocessorElif
    )
  )
}

/**
 * Holds if the function `f` contains code excluded by the preprocessor.
 */
predicate functionContainsDisabledCode(Function f) {
  // `f` contains a preprocessor branch that was not taken
  exists(
    PreprocessorBranchDirective pbd, string file, int pbdStartLine, int fBlockStartLine,
    int fBlockEndLine
  |
    functionLocation(f, file, fBlockStartLine, fBlockEndLine) and
    pbdLocation(pbd, file, pbdStartLine) and
    pbdStartLine <= fBlockEndLine and
    pbdStartLine >= fBlockStartLine and
    (
      pbd.(PreprocessorBranch).wasNotTaken()
      or
      // an else either was not taken, or it's corresponding branch
      // was not taken.
      pbd instanceof PreprocessorElse
    )
  )
}

/**
 * Holds if the function `f` contains code that could be excluded by the preprocessor.
 */
predicate functionContainsPreprocCode(Function f) {
  // `f` contains a preprocessor branch
  exists(
    PreprocessorBranchDirective pbd, string file, int pbdStartLine, int fBlockStartLine,
    int fBlockEndLine
  |
    functionLocation(f, file, fBlockStartLine, fBlockEndLine) and
    pbdLocation(pbd, file, pbdStartLine) and
    pbdStartLine <= fBlockEndLine and
    pbdStartLine >= fBlockStartLine
  )
}

/**
 * Holds if `e` is completely or partially from a macro definition, as opposed
 * to being passed in as an argument.
 *
 * In the following example, the call to `f` is from a macro definition,
 * while `y`, `+`, `1`, and `;` are not. This assumes that no identifier apart
 * from `M` refers to a macro.
 * ```
 * #define M(x) f(x)
 * ...
 *   M(y + 1);
 * ```
 */
predicate isFromMacroDefinition(Element e) {
  exists(MacroInvocation mi, Location eLocation, Location miLocation |
    // e is in mi
    mi.getAnExpandedElement() = e and
    // and e was apparently not passed in as a macro parameter
    eLocation = e.getLocation() and
    miLocation = mi.getLocation() and
    nonBindingIntEquality(eLocation.getStartLine(), miLocation.getStartLine()) and
    nonBindingIntEquality(eLocation.getStartColumn(), miLocation.getStartColumn())
  )
}

/**
 * Holds if `x = y` but gets compiled to a filter instead of a join. This can
 * be used to avoid bad join orders where integers are joined too early.
 */
bindingset[x, y]
private predicate nonBindingIntEquality(int x, int y) {
  x >= y and y >= x
}

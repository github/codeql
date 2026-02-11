/**
 * This library offers a view of preprocessor branches (`#if`, `#ifdef`,
 * `#ifndef`, `#elif`, `#elifdef`, `#elifndef`, and `#else`) as blocks of
 * code between the opening and closing directives, with navigable
 * parent-child relationships to other blocks. The main class is
 * `PreprocessorBlock`.
 */

import cpp

/**
 * Gets the line of the `ix`th `PreprocessorBranchDirective` in file `f`.
 */
private int getPreprocLineFromIndex(File f, int ix) {
  result =
    rank[ix](PreprocessorBranchDirective g | g.getFile() = f | g.getLocation().getStartLine())
}

/**
 * Gets the `ix`th `PreprocessorBranchDirective` in file `f`.
 */
private PreprocessorBranchDirective getPreprocFromIndex(File f, int ix) {
  result.getFile() = f and
  result.getLocation().getStartLine() = getPreprocLineFromIndex(f, ix)
}

/**
 * Get the index of a `PreprocessorBranchDirective` in its `file`.
 */
private int getPreprocIndex(PreprocessorBranchDirective directive) {
  directive = getPreprocFromIndex(directive.getFile(), result)
}

/**
 * A chunk of code from one preprocessor branch (`#if`, `#ifdef`,
 * `#ifndef`, `#elif`, `#elifdef`, `#elifndef`, or `#else`) to the
 * directive that closes it (`#elif`, `#elifdef`, `#elifndef`, `#else`,
 * or `#endif`).  The `getParent()` method allows these blocks to be
 * navigated as a tree, with the root being the entire file.
 */
class PreprocessorBlock extends @element {
  PreprocessorBlock() {
    mkElement(this) instanceof File or
    mkElement(this) instanceof PreprocessorBranch or
    mkElement(this) instanceof PreprocessorElse
  }

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
    filepath = this.getFile().toString() and
    startline = this.getStartLine() and
    startcolumn = 0 and
    endline = this.getEndLine() and
    endcolumn = 0
  }

  /**
   * Gets a textual representation of this element.
   */
  string toString() { result = mkElement(this).toString() }

  /**
   * Gets the file this `PreprocessorBlock` is located in.
   */
  File getFile() { result = mkElement(this).getFile() }

  /**
   * Gets the start line number of this `PreprocessorBlock`.
   */
  int getStartLine() { result = mkElement(this).getLocation().getStartLine() }

  /**
   * Gets the end line number of this `PreprocessorBlock`.
   */
  int getEndLine() {
    result = mkElement(this).(File).getMetrics().getNumberOfLines() or
    result =
      mkElement(this).(PreprocessorBranchDirective).getNext().getLocation().getStartLine() - 1
  }

  private PreprocessorBlock getParentInternal() {
    // find the `#ifdef` corresponding to this block and the
    // PreprocessorBranchDirective `prev` that came directly
    // before it in the source.
    exists(int ix, PreprocessorBranchDirective prev |
      ix = getPreprocIndex(mkElement(this).(PreprocessorBranchDirective).getIf()) and
      prev = getPreprocFromIndex(this.getFile(), ix - 1)
    |
      if prev instanceof PreprocessorEndif
      then
        // if we follow an #endif, we have the same parent
        // as its corresponding `#if` has.
        result = unresolveElement(prev.getIf()).(PreprocessorBlock).getParentInternal()
      else
        // otherwise we directly follow an #if / #ifdef / #ifndef /
        // #elif / #else that must be a level above and our parent
        // block.
        mkElement(result) = prev
    )
  }

  /**
   * Gets the `PreprocessorBlock` that's directly surrounding this one.
   * Has no result if this is a file.
   */
  PreprocessorBlock getParent() {
    not mkElement(this) instanceof File and
    (
      if exists(this.getParentInternal())
      then
        // found parent directive
        result = this.getParentInternal()
      else
        // top level directive
        mkElement(result) = this.getFile()
    )
  }

  /**
   * Gets a `PreprocessorBlock` that's directly inside this one.
   */
  PreprocessorBlock getAChild() { result.getParent() = this }

  private Include getAnEnclosedInclude() {
    result.getFile() = this.getFile() and
    result.getLocation().getStartLine() > this.getStartLine() and
    result.getLocation().getStartLine() <= this.getEndLine()
  }

  /**
   * Gets an include directive that is directly in this
   * `PreprocessorBlock`.
   */
  Include getAnInclude() {
    result = this.getAnEnclosedInclude() and
    not result = this.getAChild().getAnEnclosedInclude()
  }

  private Macro getAnEnclosedMacro() {
    result.getFile() = this.getFile() and
    result.getLocation().getStartLine() > this.getStartLine() and
    result.getLocation().getStartLine() <= this.getEndLine()
  }

  /**
   * Gets a macro definition that is directly in this
   * `PreprocessorBlock`.
   */
  Macro getAMacro() {
    result = this.getAnEnclosedMacro() and
    not result = this.getAChild().getAnEnclosedMacro()
  }
}

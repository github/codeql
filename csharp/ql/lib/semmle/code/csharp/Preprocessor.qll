/**
 * Provides all preprocessor directive classes.
 */

import Element
private import semmle.code.csharp.commons.Compilation

/**
 * A preprocessor directive, such as `PragmaWarningDirective`, `PragmaChecksumDirective`,
 * `DefineDirective`, `UndefineDirective`, `WarningDirective`, `ErrorDirective`,
 * `NullableDirective`, `LineDirective`, `RegionDirective`, `EndRegionDirective`,
 * `BranchDirective`, or `EndifDirective`.
 */
class PreprocessorDirective extends Element, @preprocessor_directive {
  /**
   * Holds if this directive is processed by the preprocessor, such as any directive
   * that is not inside a not taken `BranchDirective`.
   */
  predicate isActive() { preprocessor_directive_active(this, 1) }

  override Location getALocation() { preprocessor_directive_location(this, result) }

  /** Gets the compilation this directive belongs to, if any. */
  Compilation getCompilation() { preprocessor_directive_compilation(this, result) }
}

/**
 * A `#pragma warning` directive.
 */
class PragmaWarningDirective extends PreprocessorDirective, @pragma_warning {
  /** Holds if this is a `#pragma warning restore` directive. */
  predicate isRestore() { pragma_warnings(this, 1) }

  /** Holds if this is a `#pragma warning disable` directive. */
  predicate isDisable() { pragma_warnings(this, 0) }

  /** Holds if this directive specifies error codes. */
  predicate hasErrorCodes() { pragma_warning_error_codes(this, _, _) }

  /** Gets a specified error code from this directive. */
  string getAnErrorCode() { pragma_warning_error_codes(this, result, _) }

  override string toString() { result = "#pragma warning ..." }

  override string getAPrimaryQlClass() { result = "PragmaWarningDirective" }
}

/**
 * A `#pragma checksum` directive.
 */
class PragmaChecksumDirective extends PreprocessorDirective, @pragma_checksum {
  /** Gets the file name of this directive. */
  File getReferencedFile() { pragma_checksums(this, result, _, _) }

  /** Gets the GUID of this directive. */
  string getGuid() { pragma_checksums(this, _, result, _) }

  /** Gets the checksum bytes of this directive. */
  string getBytes() { pragma_checksums(this, _, _, result) }

  override string toString() { result = "#pragma checksum ..." }

  override string getAPrimaryQlClass() { result = "PragmaChecksumDirective" }
}

/**
 * A `#define` directive.
 */
class DefineDirective extends PreprocessorDirective, @directive_define {
  /** Gets the name of the preprocessor symbol that is being set by this directive. */
  string getName() { directive_defines(this, result) }

  override string toString() { result = "#define ..." }

  override string getAPrimaryQlClass() { result = "DefineDirective" }
}

/**
 * An `#undef` directive.
 */
class UndefineDirective extends PreprocessorDirective, @directive_undefine {
  /** Gets the name of the preprocessor symbol that is being unset by this directive. */
  string getName() { directive_undefines(this, result) }

  override string toString() { result = "#undef ..." }

  override string getAPrimaryQlClass() { result = "UndefineDirective" }
}

/**
 * A `#warning` directive.
 */
class WarningDirective extends PreprocessorDirective, @directive_warning {
  /** Gets the text of the warning. */
  string getMessage() { directive_warnings(this, result) }

  override string toString() { result = "#warning ..." }

  override string getAPrimaryQlClass() { result = "WarningDirective" }
}

/**
 * An `#error` directive.
 */
class ErrorDirective extends PreprocessorDirective, @directive_error {
  /** Gets the text of the error. */
  string getMessage() { directive_errors(this, result) }

  override string toString() { result = "#error ..." }

  override string getAPrimaryQlClass() { result = "ErrorDirective" }
}

/**
 * A `#nullable` directive.
 */
class NullableDirective extends PreprocessorDirective, @directive_nullable {
  /** Holds if this is a `#nullable disable` directive. */
  predicate isDisable() { directive_nullables(this, 0, _) }

  /** Holds if this is a `#nullable enable` directive. */
  predicate isEnable() { directive_nullables(this, 1, _) }

  /** Holds if this is a `#nullable restore` directive. */
  predicate isRestore() { directive_nullables(this, 2, _) }

  /** Holds if this directive targets all nullable contexts. */
  predicate targetsAll() { directive_nullables(this, _, 0) }

  /** Holds if this directive targets nullable annotation context. */
  predicate targetsAnnotations() { directive_nullables(this, _, 1) }

  /** Holds if this directive targets nullable warning context. */
  predicate targetsWarnings() { directive_nullables(this, _, 2) }

  /** Gets the succeeding `#nullable` directive in the file, if any. */
  NullableDirective getSuccNullableDirective() {
    result =
      min(NullableDirective next |
        next.getFile() = this.getFile() and
        next.getLocation().getStartLine() > this.getLocation().getStartLine()
      |
        next order by next.getLocation().getStartLine()
      )
  }

  /** Holds if there is a succeeding `#nullable` directive in the file. */
  predicate hasSuccNullableDirective() {
    exists(NullableDirective other |
      other.getFile() = this.getFile() and
      other.getLocation().getStartLine() > this.getLocation().getStartLine()
    )
  }

  override string toString() { result = "#nullable ..." }

  override string getAPrimaryQlClass() { result = "NullableDirective" }
}

/**
 * A `#line` directive, such as `#line default`, `#line hidden`, or `#line`
 * directive with line number.
 */
class LineDirective extends PreprocessorDirective, @directive_line {
  /** Gets the succeeding `#line` directive in the file, if any. */
  LineDirective getSuccLineDirective() {
    result =
      min(LineDirective next |
        next.getFile() = this.getFile() and
        next.getLocation().getStartLine() > this.getLocation().getStartLine()
      |
        next order by next.getLocation().getStartLine()
      )
  }

  /** Holds if there is a succeeding `#line` directive in the file. */
  predicate hasSuccLineDirective() {
    exists(LineDirective other |
      other.getFile() = this.getFile() and
      other.getLocation().getStartLine() > this.getLocation().getStartLine()
    )
  }

  override string toString() { result = "#line ..." }

  override string getAPrimaryQlClass() { result = "LineDirective" }
}

/**
 * A `#line default` directive.
 */
class DefaultLineDirective extends LineDirective {
  DefaultLineDirective() { directive_lines(this, 0) }

  override string toString() { result = "#line default" }

  override string getAPrimaryQlClass() { result = "DefaultLineDirective" }
}

/**
 * A `#line hidden` directive.
 */
class HiddenLineDirective extends LineDirective {
  HiddenLineDirective() { directive_lines(this, 1) }

  override string toString() { result = "#line hidden" }

  override string getAPrimaryQlClass() { result = "HiddenLineDirective" }
}

private class NumericOrSpanLineDirective extends LineDirective {
  NumericOrSpanLineDirective() { directive_lines(this, [2, 3]) }

  /** Gets the referenced file of this directive. */
  File getReferencedFile() { directive_line_file(this, result) }
}

/**
 * A numeric `#line` directive, such as `#line 200 file`.
 */
class NumericLineDirective extends NumericOrSpanLineDirective {
  NumericLineDirective() { directive_lines(this, 2) }

  /** Gets the line number of this directive. */
  int getLine() { directive_line_value(this, result) }

  override string getAPrimaryQlClass() { result = "NumericLineDirective" }
}

/**
 * A line span `#line` directive, such as `#line (1, 1) - (3, 10) 5 file`.
 */
class SpanLineDirective extends NumericOrSpanLineDirective {
  SpanLineDirective() { directive_lines(this, 3) }

  /** Gets the offset of this directive. */
  int getOffset() { directive_line_offset(this, result) }

  /** Holds if the specified start and end positions match this SpanLineDirective. */
  predicate span(int startLine, int startColumn, int endLine, int endColumn) {
    directive_line_span(this, startLine, startColumn, endLine, endColumn)
  }

  override string getAPrimaryQlClass() { result = "SpanLineDirective" }
}

/**
 * A `#region` directive.
 */
class RegionDirective extends PreprocessorDirective, @directive_region {
  /** Gets the name of this region. */
  string getName() { directive_regions(this, result) }

  /** Gets the closing `#endregion` directive. */
  EndRegionDirective getEnd() { directive_endregions(result, this) }

  override string toString() { result = "#region ..." }

  override string getAPrimaryQlClass() { result = "RegionDirective" }
}

/**
 * An `#endregion` directive.
 */
class EndRegionDirective extends PreprocessorDirective, @directive_endregion {
  /** Gets the opening `#region` directive. */
  RegionDirective getStart() { result.getEnd() = this }

  override string toString() { result = "#endregion" }

  override string getAPrimaryQlClass() { result = "EndRegionDirective" }
}

/**
 * A branching preprocessor directive, such as `IfDirective`, `ElifDirective`, or
 * `ElseDirective`.
 */
class BranchDirective extends PreprocessorDirective, @branch_directive {
  /** Holds if the branch is taken by the preprocessor. */
  predicate branchTaken() { none() }
}

/**
 * A preprocessor directive with a branching condition, such as `IfDirective` or
 * `ElifDirective`.
 */
class ConditionalDirective extends BranchDirective, @conditional_directive {
  /** Gets the condition. */
  Expr getCondition() { result = this.getChild(0) }

  /** Holds if the condition is matched. */
  predicate conditionMatched() { none() }
}

/**
 * An `#if` preprocessor directive.
 */
class IfDirective extends ConditionalDirective, @directive_if {
  override predicate branchTaken() { directive_ifs(this, 1, _) }

  override predicate conditionMatched() { directive_ifs(this, _, 1) }

  /** Gets the closing `#endif` preprocessor directive. */
  EndifDirective getEndifDirective() { directive_endifs(result, this) }

  /** Gets the sibling `#elif` or `#else` preprocessor directive at index `sibling`. */
  BranchDirective getSiblingDirective(int sibling) {
    directive_elifs(result, _, _, this, sibling) or
    directive_elses(result, _, this, sibling)
  }

  /** Gets a sibling `#elif` or `#else` preprocessor directive. */
  BranchDirective getASiblingDirective() { result = this.getSiblingDirective(_) }

  override string toString() { result = "#if ..." }

  override string getAPrimaryQlClass() { result = "IfDirective" }
}

/**
 * An `#elif` preprocessor directive.
 */
class ElifDirective extends ConditionalDirective, @directive_elif {
  override predicate branchTaken() { directive_elifs(this, 1, _, _, _) }

  override predicate conditionMatched() { directive_elifs(this, _, 1, _, _) }

  /** Gets the opening `#if` preprocessor directive. */
  IfDirective getIfDirective() { directive_elifs(this, _, _, result, _) }

  /** Gets the successive branching preprocessor directive (`#elif` or `#else`), if any. */
  BranchDirective getSuccSiblingDirective() {
    exists(IfDirective i, int index |
      this = i.getSiblingDirective(index) and
      result = i.getSiblingDirective(index + 1)
    )
  }

  override string toString() { result = "#elif ..." }

  override string getAPrimaryQlClass() { result = "ElifDirective" }
}

/**
 * An `#else` preprocessor directive.
 */
class ElseDirective extends BranchDirective, @directive_else {
  /** Gets the opening `#if` preprocessor directive. */
  IfDirective getIfDirective() { directive_elses(this, _, result, _) }

  override predicate branchTaken() { directive_elses(this, 1, _, _) }

  override string toString() { result = "#else" }

  override string getAPrimaryQlClass() { result = "ElseDirective" }
}

/**
 * An `#endif` preprocessor directive.
 */
class EndifDirective extends PreprocessorDirective, @directive_endif {
  /** Gets the opening `#if` preprocessor directive. */
  IfDirective getIfDirective() { directive_endifs(this, result) }

  override string toString() { result = "#endif" }

  override string getAPrimaryQlClass() { result = "EndifDirective" }
}

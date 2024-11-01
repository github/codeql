import cpp
import Diagnostics

/**
 * A metric is a string with a value.
 */
abstract class Metric extends string {
  bindingset[this]
  Metric() { any() }

  /** Gets the value of this metric. */
  abstract float getValue();
}

/**
 * A metric that we want to report in cpp/telemetry/extraction-metrics
 */
abstract class ExtractionMetric extends Metric {
  bindingset[this]
  ExtractionMetric() { any() }
}

/**
 * A metric that provides a baseline for a SuccessMetric.
 */
abstract class BaseMetric extends ExtractionMetric {
  bindingset[this]
  BaseMetric() { any() }
}

/**
 * A metric that is relative to another metric,
 * so can be used to calculate percentages.
 *
 * For clarity, metrics should express success,
 * so higher values means better.
 */
abstract class SuccessMetric extends ExtractionMetric {
  bindingset[this]
  SuccessMetric() { any() }

  /** Gets the metric this is relative to. */
  abstract BaseMetric getBaseline();
}

/**
 * A metric used to report database quality.
 */
class QualityMetric extends Metric {
  BaseMetric base_metric;
  SuccessMetric relative_metric;

  QualityMetric() {
    base_metric = relative_metric.getBaseline() and this = "Percentage of " + relative_metric
  }

  override float getValue() { result = 100 * relative_metric.getValue() / base_metric.getValue() }
}

/** Various metrics we want to report. */
module CppMetrics {
  class CompilationUnits extends BaseMetric {
    CompilationUnits() { this = "compilation units" }

    override float getValue() { result = count(Compilation c) }
  }

  class SourceFiles extends BaseMetric {
    SourceFiles() { this = "source files" }

    override float getValue() { result = count(File f | f.fromSource()) }
  }

  class SourceFilesWithoutErrors extends SuccessMetric {
    SourceFilesWithoutErrors() { this = "source files without errors" }

    override float getValue() {
      result = count(File f | f.fromSource() and not exists(CompilerError e | f = e.getFile()))
    }

    override SourceFiles getBaseline() { any() }
  }

  class CompilationUnitsWithoutErrors extends SuccessMetric {
    CompilationUnitsWithoutErrors() { this = "compilation units without errors" }

    override float getValue() {
      result = count(Compilation c | not exists(Diagnostic d | d.getFile() = c.getAFileCompiled()))
    }

    override CompilationUnits getBaseline() { any() }
  }

  class Expressions extends BaseMetric {
    Expressions() { this = "expressions" }

    override float getValue() { result = count(Expr e) }
  }

  class SucceededExpressions extends SuccessMetric {
    SucceededExpressions() { this = "non-error expressions" }

    override float getValue() { result = count(Expr e) - count(ErrorExpr e) }

    override Expressions getBaseline() { any() }
  }

  class TypedExpressions extends SuccessMetric {
    TypedExpressions() { this = "expressions with a known type" }

    override float getValue() { result = count(Expr e | not e.getType() instanceof ErroneousType) }

    override Expressions getBaseline() { any() }
  }

  class Calls extends BaseMetric {
    Calls() { this = "calls" }

    override float getValue() { result = count(Call c) }
  }

  class SucceededCalls extends SuccessMetric {
    SucceededCalls() { this = "calls with a target" }

    override float getValue() {
      result = count(Call c | not c.getTarget().getADeclarationEntry().isImplicit())
    }

    override Calls getBaseline() { any() }
  }

  class Variables extends BaseMetric {
    Variables() { this = "variables" }

    override float getValue() { result = count(Variable v) }
  }

  class VariablesKnownType extends SuccessMetric {
    VariablesKnownType() { this = "variables with a known type" }

    override float getValue() {
      result = count(Variable v | not v.getType() instanceof ErroneousType)
    }

    override Variables getBaseline() { any() }
  }

  class LinesOfText extends BaseMetric {
    LinesOfText() { this = "lines of text" }

    override float getValue() { result = sum(File f | | f.getMetrics().getNumberOfLines()) }
  }

  class LinesOfCode extends BaseMetric {
    LinesOfCode() { this = "lines of code" }

    override float getValue() { result = sum(File f | | f.getMetrics().getNumberOfLinesOfCode()) }
  }

  private predicate errorLine(File file, int line) {
    exists(Locatable l, Location loc |
      loc = l.getLocation() and
      loc.getFile() = file and
      line in [loc.getStartLine() .. loc.getEndLine()]
    |
      l instanceof Diagnostic
      or
      l instanceof ErrorExpr
    )
  }

  class SucceededLines extends SuccessMetric {
    SucceededLines() { this = "lines of code without errors" }

    override float getValue() {
      result =
        sum(File f | | f.getMetrics().getNumberOfLinesOfCode()) -
          count(File file, int line | errorLine(file, line))
    }

    override LinesOfCode getBaseline() { any() }
  }

  class Functions extends BaseMetric {
    Functions() { this = "functions" }

    override float getValue() { result = count(Function f) }
  }

  class SucceededFunctions extends SuccessMetric {
    SucceededFunctions() { this = "functions without errors" }

    override float getValue() { result = count(Function f | not f.hasErrors()) }

    override Functions getBaseline() { any() }
  }

  class Includes extends BaseMetric {
    Includes() { this = "#include directives" }

    override float getValue() { result = count(Include i) + count(CannotOpenFile e) }
  }

  class SucceededIncludes extends SuccessMetric {
    SucceededIncludes() { this = "successfully resolved #include directives" }

    override float getValue() { result = count(Include i) }

    override Includes getBaseline() { any() }
  }

  class SucceededIncludeCount extends Metric {
    string include_text;

    SucceededIncludeCount() {
      exists(Include i |
        i.getIncludeText() = include_text and
        exists(i.getFile().getRelativePath()) // Only report includes from the repo
      ) and
      this = "Successfully included " + include_text
    }

    override float getValue() { result = count(Include i | i.getIncludeText() = include_text) }

    string getIncludeText() { result = include_text }
  }

  class MissingIncludeCount extends Metric {
    string include_text;

    MissingIncludeCount() {
      exists(CannotOpenFile e | e.getIncludedFile() = include_text) and
      this = "Failed to include '" + include_text + "'"
    }

    override float getValue() {
      result = count(CannotOpenFile e | e.getIncludedFile() = include_text)
    }

    string getIncludeText() { result = include_text }
  }

  class CompilerErrors extends ExtractionMetric {
    CompilerErrors() { this = "compiler errors" }

    override float getValue() { result = count(CompilerError e) }
  }

  class ErrorCount extends Metric {
    ErrorCount() { exists(CompilerError e | e.getMessage() = this) }

    override float getValue() { result = count(CompilerError e | e.getMessage() = this) }
  }

  class SyntaxErrorCount extends ExtractionMetric {
    SyntaxErrorCount() { this = "syntax errors" }

    override float getValue() { result = count(SyntaxError e) }
  }
}

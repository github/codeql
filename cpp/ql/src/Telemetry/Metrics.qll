import cpp
import Diagnostics

/**
 * A metric is a string with a value.
 */
abstract class Metric extends string {
  bindingset[this]
  Metric() { any() }
}

/**
 * A metric that we want to report in cpp/telemetry/extraction-metrics
 */
abstract class ExtractionMetric extends Metric {
  bindingset[this]
  ExtractionMetric() { any() }

  /** Gets the value of this metric. */
  abstract int getValue();
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
  BaseMetric baseMetric;
  SuccessMetric relativeMetric;

  QualityMetric() {
    baseMetric = relativeMetric.getBaseline() and this = "Percentage of " + relativeMetric
  }

  float getValue() {
    baseMetric.getValue() > 0 and
    result = 100.0 * relativeMetric.getValue() / baseMetric.getValue()
  }
}

signature class RankedMetric extends Metric {
  int getValue();
}

module RankMetric<RankedMetric M> {
  int getRank(M s) { s = rank[result](M m | | m order by m.getValue() desc) }
}

/** Various metrics we want to report. */
module CppMetrics {
  class Compilations extends BaseMetric {
    Compilations() { this = "compilations" }

    override int getValue() { result = count(Compilation c) }
  }

  class SourceAndHeaderFiles extends BaseMetric {
    SourceAndHeaderFiles() { this = "source/header files" }

    override int getValue() { result = count(File f | f.fromSource()) }
  }

  class SourceAndHeaderFilesWithoutErrors extends SuccessMetric {
    SourceAndHeaderFilesWithoutErrors() { this = "source/header files without errors" }

    override int getValue() {
      result = count(File f | f.fromSource() and not exists(CompilerError e | f = e.getFile()))
    }

    override SourceAndHeaderFiles getBaseline() { any() }
  }

  class CompilationsWithoutErrors extends SuccessMetric {
    CompilationsWithoutErrors() { this = "compilations without errors" }

    override int getValue() {
      result = count(Compilation c | not exists(Diagnostic d | d.getFile() = c.getAFileCompiled()))
    }

    override Compilations getBaseline() { any() }
  }

  class Expressions extends BaseMetric {
    Expressions() { this = "expressions" }

    override int getValue() { result = count(Expr e) }
  }

  class SucceededExpressions extends SuccessMetric {
    SucceededExpressions() { this = "non-error expressions" }

    override int getValue() { result = count(Expr e) - count(ErrorExpr e) }

    override Expressions getBaseline() { any() }
  }

  class TypedExpressions extends SuccessMetric {
    TypedExpressions() { this = "expressions with a known type" }

    override int getValue() { result = count(Expr e | not e.getType() instanceof ErroneousType) }

    override Expressions getBaseline() { any() }
  }

  class Calls extends BaseMetric {
    Calls() { this = "calls" }

    override int getValue() { result = count(Call c) }
  }

  class CallsWithExplicitTarget extends SuccessMetric {
    CallsWithExplicitTarget() { this = "calls with an explicit target" }

    override int getValue() {
      result = count(Call c | not c.getTarget().getADeclarationEntry().isImplicit())
    }

    override Calls getBaseline() { any() }
  }

  class Variables extends BaseMetric {
    Variables() { this = "variables" }

    override int getValue() { result = count(Variable v) }
  }

  class VariablesKnownType extends SuccessMetric {
    VariablesKnownType() { this = "variables with a known type" }

    override int getValue() {
      result = count(Variable v | not v.getType() instanceof ErroneousType)
    }

    override Variables getBaseline() { any() }
  }

  class LinesOfText extends BaseMetric {
    LinesOfText() { this = "lines of text" }

    override int getValue() { result = sum(File f | | f.getMetrics().getNumberOfLines()) }
  }

  class LinesOfCode extends BaseMetric {
    LinesOfCode() { this = "lines of code" }

    override int getValue() { result = sum(File f | | f.getMetrics().getNumberOfLinesOfCode()) }
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

    override int getValue() {
      result =
        sum(File f | | f.getMetrics().getNumberOfLinesOfCode()) -
          count(File f, int line | errorLine(f, line))
    }

    override LinesOfCode getBaseline() { any() }
  }

  class Functions extends BaseMetric {
    Functions() { this = "functions" }

    override int getValue() { result = count(Function f) }
  }

  class SucceededFunctions extends SuccessMetric {
    SucceededFunctions() { this = "functions without errors" }

    override int getValue() { result = count(Function f | not f.hasErrors()) }

    override Functions getBaseline() { any() }
  }

  class Includes extends BaseMetric {
    Includes() { this = "#include directives" }

    override int getValue() { result = count(Include i) + count(CannotOpenFileError e) }
  }

  class SucceededIncludes extends SuccessMetric {
    SucceededIncludes() { this = "successfully resolved #include directives" }

    override int getValue() { result = count(Include i) }

    override Includes getBaseline() { any() }
  }

  class SucceededIncludeCount extends Metric {
    string includeText;

    SucceededIncludeCount() {
      exists(Include i |
        i.getIncludeText() = includeText and
        exists(i.getFile().getRelativePath()) // Only report includes from the repo
      ) and
      this = "Successfully included " + includeText
    }

    int getValue() { result = count(Include i | i.getIncludeText() = includeText) }

    string getIncludeText() { result = includeText }
  }

  class MissingIncludeCount extends Metric {
    string includeText;

    MissingIncludeCount() {
      exists(CannotOpenFileError e | e.getIncludedFile() = includeText) and
      this = "Failed to include '" + includeText + "'"
    }

    int getValue() { result = count(CannotOpenFileError e | e.getIncludedFile() = includeText) }

    string getIncludeText() { result = includeText }
  }

  class CompilerErrors extends ExtractionMetric {
    CompilerErrors() { this = "compiler errors" }

    override int getValue() { result = count(CompilerError e) }
  }

  class ErrorCount extends Metric {
    ErrorCount() { exists(CompilerError e | e.getMessage() = this) }

    int getValue() { result = count(CompilerError e | e.getMessage() = this) }
  }

  class SyntaxErrorCount extends ExtractionMetric {
    SyntaxErrorCount() { this = "syntax errors" }

    override int getValue() { result = count(SyntaxError e) }
  }
}

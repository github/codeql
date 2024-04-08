import go
private import semmle.go.internal.Locations

bindingset[path]
string baseName(string path) { result = path.regexpCapture(".*(/|\\\\)([^/\\\\]+)(/|\\\\)?$", 2) }

class Compilation extends @compilation {
  string getArg(int i) { compilation_args(this, i, result) }

  string getCwd() { compilations(this, result) }

  int getNumArgs() { result = count(int i | exists(this.getArg(i))) }

  predicate compilesFile(int i, File f) { compilation_compiling_files(this, i, f) }

  private string getArgsTo(int i) {
    // use baseName for location-independent tests
    i = 0 and result = baseName(this.getArg(0))
    or
    result = this.getArgsTo(i - 1) + " " + this.getArg(i)
  }

  string toString() {
    result =
      "compilation in '" + baseName(this.getCwd()) + "': " + this.getArgsTo(this.getNumArgs() - 1)
  }
}

class Diagnostic extends @diagnostic {
  predicate diagnosticFor(Compilation c, int fileNum, int idx) {
    diagnostic_for(this, c, fileNum, idx)
  }

  DbLocation getLocation() {
    exists(@location loc |
      diagnostics(this, _, _, _, _, loc) and
      result = TDbLocation(loc)
    )
  }

  // string getTag() {
  //   diagnostics(this, _, result, _, _, _)
  // }
  string getMessage() { diagnostics(this, _, _, result, _, _) }

  // string getFullMessage() {
  //   diagnostics(this, _, _, _, result, _)
  // }
  string toString() { result = "error: " + this.getMessage() }
}

/**
 * A wrapper around a `Compilation`, removing the `.exe` suffixes from compilation descriptions
 * such that this test produces the same results on Windows and non-Windows platforms.
 */
class PlatformNeutralCompilation extends Compilation {
  override string toString() { result = super.toString().regexpReplaceAll("\\.exe", "") }
}

query predicate qcompilations(PlatformNeutralCompilation c, File f) { c.compilesFile(_, f) }

query predicate qdiagnostics(Diagnostic d, PlatformNeutralCompilation c, File f) {
  exists(int fileno | d.diagnosticFor(c, fileno, _) | c.compilesFile(fileno, f))
}

query predicate duplicateerrs(
  Diagnostic d, Diagnostic d1, PlatformNeutralCompilation c, int fileno, int idx
) {
  d != d1 and
  d.diagnosticFor(c, fileno, idx) and
  d1.diagnosticFor(c, fileno, idx)
}

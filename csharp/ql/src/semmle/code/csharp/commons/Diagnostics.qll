/** Provides classes relating to compilation and extraction diagnostics. */

import csharp

/** An invocation of the C# compiler. */
class Compilation extends @compilation {
  /** Gets a textual representation of this compilation. */
  string toString() { result = "compilation" }

  /** Gets the directory in which this compilation was run, as a string. */
  string getDirectoryString() { compilations(this, result) }

  /** Gets the folder in which this compilation was run. */
  Folder getFolder() { result.getAbsolutePath() = getDirectoryString() }

  /** Gets the `i`th command line argument. */
  string getArgument(int i) { compilation_args(this, i, result) }

  /** Gets the 'i'th source file in this compilation. */
  File getFile(int i) { compilation_compiling_files(this, i, result) }

  /** Gets a diagnostic associated with this compilation. */
  Diagnostic getADiagnostic() { result.getCompilation() = this }

  /** Gets a performance metric for this compilation. */
  float getMetric(int metric) { compilation_time(this, -1, metric, result) }

  /** Gets the CPU time of the compilation. */
  float getCompilationCpuTime() { result = getMetric(0) }

  /** Gets the elapsed time of the compilation. */
  float getCompilationElapsedTime() { result = getMetric(1) }

  /** Gets the CPU time of the extraction. */
  float getExtractionCpuTime() { result = getMetric(2) }

  /** Gets the elapsed time of the extraction. */
  float getExtractionElapsedTime() { result = getMetric(3) }

  /** Gets the user CPU time of the compilation. */
  float getCompilationUserCpuTime() { result = getMetric(4) }

  /** Gets the user CPU time of the extraction. */
  float getExtractionUserCpuTime() { result = getMetric(5) }

  /** Gets the peak working set of the extractor process in MB. */
  float getPeakWorkingSetMB() { result = getMetric(6) }
}

/** A diagnostic emitted by a compilation, such as a compilation warning or an error. */
class Diagnostic extends @diagnostic {
  /** Gets the compilation that generated this diagnostic. */
  Compilation getCompilation() { diagnostic_for(this, result, _, _) }

  /**
   * Gets the severity of this diagnostic.
   * 0 = Hidden
   * 1 = Info
   * 2 = Warning
   * 3 = Error
   */
  int getSeverity() { diagnostics(this, result, _, _, _, _) }

  /** Gets the identifier of this diagnostic, for example "CS8019". */
  string getId() { diagnostics(this, _, result, _, _, _) }

  /** Gets the short error message of this diagnostic. */
  string getMessage() { diagnostics(this, _, _, result, _, _) }

  /** Gets the full error message of this diagnostic. */
  string getFullMessage() { diagnostics(this, _, _, _, result, _) }

  /** Gets the location of this diagnostic. */
  Location getLocation() { diagnostics(this, _, _, _, _, result) }

  /** Gets a textual representation of this diagnostic. */
  string toString() { result = getMessage() }
}

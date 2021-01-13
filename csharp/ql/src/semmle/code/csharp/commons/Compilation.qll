import csharp
import Diagnostics

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

  /** Gets the arguments as a concatenated string. */
  string getArguments() { result = concat(int i | exists(getArgument(i)) | getArgument(i), " ") }

  /** Gets the 'i'th source file in this compilation. */
  File getFileCompiled(int i) { compilation_compiling_files(this, i, result) }

  /** Gets a source file compiled in this compilation. */
  File getAFileCompiled() { result = getFileCompiled(_) }

  /** Gets the `i`th reference in this compilation. */
  File getReference(int i) { compilation_referencing_files(this, i, result) }

  /** Gets a reference in this compilation. */
  File getAReference() { result = getReference(_) }

  /** Gets a diagnostic associated with this compilation. */
  Diagnostic getADiagnostic() { result.getCompilation() = this }

  /** Gets a performance metric for this compilation. */
  float getMetric(int metric) { compilation_time(this, -1, metric, result) }

  /** Gets the CPU time of the compilation. */
  float getFrontendCpuSeconds() { result = getMetric(0) }

  /** Gets the elapsed time of the compilation. */
  float getFrontendElapsedSeconds() { result = getMetric(1) }

  /** Gets the CPU time of the extraction. */
  float getExtractorCpuSeconds() { result = getMetric(2) }

  /** Gets the elapsed time of the extraction. */
  float getExtractorElapsedSeconds() { result = getMetric(3) }

  /** Gets the user CPU time of the compilation. */
  float getFrontendUserCpuSeconds() { result = getMetric(4) }

  /** Gets the user CPU time of the extraction. */
  float getExtractorUserCpuSeconds() { result = getMetric(5) }

  /** Gets the peak working set of the extractor process in MB. */
  float getPeakWorkingSetMB() { result = getMetric(6) }

  /** Gets the CPU seconds for the entire extractor process. */
  float getCpuSeconds() { compilation_finished(this, result, _) }

  /** Gets the elapsed seconds for the entire extractor process. */
  float getElapsedSeconds() { compilation_finished(this, _, result) }
}

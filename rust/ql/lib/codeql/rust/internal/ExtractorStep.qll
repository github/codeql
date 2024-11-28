import codeql.files.FileSystem

/**
 * An extractor step, usable for debugging and diagnostics reasons.
 *
 * INTERNAL: Do not use.
 */
class ExtractorStep extends @extractor_step {
  /**
   * Gets the string representation of this extractor step.
   */
  string toString() {
    exists(File file, string action |
      extractor_steps(this, action, file, _) and
      result = action + "(" + file.getAbsolutePath() + ")"
    )
  }

  /**
   * Gets the action this extractor step carried out.
   */
  string getAction() { extractor_steps(this, result, _, _) }

  /**
   * Gets the file the extractor step was carried out on.
   */
  File getFile() { extractor_steps(this, _, result, _) }

  /**
   * Gets the duration of the extractor step in milliseconds.
   */
  int getDurationMs() { extractor_steps(this, _, _, result) }

  /**
   * Provides location information for this step.
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getFile().getAbsolutePath() = filepath and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }
}

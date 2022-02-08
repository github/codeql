import javascript

/**
 * INTERNAL: Do not use in ordinary queries.
 *
 * Extraction metrics for profiling extraction behaviors.
 */
module ExtractionMetrics {
  /**
   * A file with extraction metrics.
   */
  class FileWithExtractionMetrics extends File {
    FileWithExtractionMetrics() {
      extraction_data(this, _, _, _) and extraction_time(this, _, _, _)
    }

    /**
     * Gets the CPU time in nanoseconds it took to extract this file.
     */
    float getCpuTime() { result = strictsum(getTime(_, 0)) }

    /**
     * Gets the wall-clock time in nanoseconds it took to extract this file.
     */
    float getWallclockTime() { result = strictsum(getTime(_, 1)) }

    /**
     * Gets the CPU time in nanoseconds it took to process phase `phaseName` during the extraction of this file.
     */
    float getCpuTime(PhaseName phaseName) { result = getTime(phaseName, 0) }

    /**
     * Gets the wall-clock time in nanoseconds it took to process phase `phaseName` during the extraction of this file.
     */
    float getWallclockTime(PhaseName phaseName) { result = getTime(phaseName, 1) }

    /**
     * Holds if this file was extracted from the trap cache.
     */
    predicate isFromCache() { extraction_data(this, _, true, _) }

    /**
     * Gets the path to the cache file used for extraction of this file.
     */
    string getCacheFile() { extraction_data(this, result, _, _) }

    /**
     * Gets the number of UTF16 code units in this file.
     */
    int getLength() { extraction_data(this, _, _, result) }

    private float getTime(PhaseName phaseName, int timerKind) {
      exists(float time |
        // note that we use strictsum to make it clear if data is missing because it comes from an upgraded database.
        strictsum(int phaseId, float r |
          phaseName = getExtractionPhaseName(phaseId) and
          extraction_time(this, phaseId, timerKind, r)
        |
          r
        ) = time
      |
        // assume the cache-lookup was for free
        if isFromCache() then result = 0 else result = time
      )
    }
  }

  /**
   * Converts database ids to human-readable names.
   */
  private string getExtractionPhaseName(int phaseId) {
    // these names ought to match the names used in
    // `com.semmle.js.extractor.ExtractionTimer.ExtractionPhase`
    "ASTExtractor_extract" = result and 0 = phaseId
    or
    "CFGExtractor_extract" = result and 1 = phaseId
    or
    "FileExtractor_extractContents" = result and 2 = phaseId
    or
    "JSExtractor_extract" = result and 3 = phaseId
    or
    "JSParser_parse" = result and 4 = phaseId
    or
    "LexicalExtractor_extractLines" = result and 5 = phaseId
    or
    "LexicalExtractor_extractTokens" = result and 6 = phaseId
    or
    "TypeScriptASTConverter_convertAST" = result and 7 = phaseId
    or
    "TypeScriptParser_talkToParserWrapper" = result and 8 = phaseId
  }

  /**
   * The name of a phase of the extraction.
   */
  class PhaseName extends string {
    PhaseName() { this = getExtractionPhaseName(_) }
  }

  /**
   * Utilities for aggregating metrics for multiple files.
   */
  module Aggregated {
    /**
     * Gets the total CPU time spent on extraction.
     */
    float getCpuTime() { result = strictsum(any(FileWithExtractionMetrics f).getCpuTime()) }

    /**
     * Gets the total wallclock time spent on extraction.
     */
    float getWallclockTime() {
      result = strictsum(any(FileWithExtractionMetrics f).getWallclockTime())
    }

    /**
     * Gets the total CPU time spent in phase `phaseName` of the extraction.
     */
    float getCpuTime(PhaseName phaseName) {
      result = strictsum(any(FileWithExtractionMetrics f).getCpuTime(phaseName))
    }

    /**
     * Gets the total wallclock time spent in phase `phaseName` of the extraction.
     */
    float getWallclockTime(PhaseName phaseName) {
      result = strictsum(any(FileWithExtractionMetrics f).getWallclockTime(phaseName))
    }
  }
}

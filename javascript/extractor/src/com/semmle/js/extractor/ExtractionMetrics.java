package com.semmle.js.extractor;

import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import java.io.File;
import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;
import java.util.Stack;

/** Metrics for the (single-threaded) extraction of a single file. */
public class ExtractionMetrics {
  /**
   * The phase of the extraction that should be measured time for.
   *
   * <p>Convention: the enum names have the format <code>{ClassName}_{MethodName}</code>, and should
   * identify the methods they correspond to.
   */
  public enum ExtractionPhase {
    ASTExtractor_extract(0),
    CFGExtractor_extract(1),
    FileExtractor_extractContents(2),
    JSExtractor_extract(3),
    JSParser_parse(4),
    LexicalExtractor_extractLines(5),
    LexicalExtractor_extractTokens(6),
    TypeScriptASTConverter_convertAST(7),
    TypeScriptParser_talkToParserWrapper(8);

    /** The id used in the database for the time spent performing this phase of the extraction. */
    final int dbschemeId;

    ExtractionPhase(int dbschemeId) {
      this.dbschemeId = dbschemeId;
    }
  }

  /** The cache file, if any. */
  private File cacheFile;

  /** True iff the extraction of this file reuses an existing trap cache file. */
  private boolean canReuseCacheFile;

  /** The cumulative CPU-time spent in each extraction phase so far. */
  private final long[] cpuTimes = new long[ExtractionPhase.values().length];

  /** The label for the file that is being extracted. */
  private Label fileLabel;

  /** The number of UTF16 code units in the file that is being extracted. */
  private int length;

  /** The previous time a CPU-time measure was performed. */
  private long previousCpuTime;

  /** The previous time a wallclock-time measure was performed. */
  private long previousWallclockTime;

  /** The extraction phase stack. */
  private final Stack<ExtractionPhase> stack = new Stack<>();

  /** The current thread, used for measuring CPU-time. */
  private final ThreadMXBean thread = ManagementFactory.getThreadMXBean();

  /** The cumulative wallclock-time spent in each extraction phase so far. */
  private final long[] wallclockTimes = new long[ExtractionPhase.values().length];

  /**
   * True iff extraction metrics could not be obtained for this file (due to an unforeseen error
   * that should not prevent the ordinary extraction from succeeding).
   */
  private boolean timingsFailed;

  /**
   * Writes the data metrics to a trap file. Note that this makes the resulting trap file content
   * non-deterministic.
   */
  public void writeDataToTrap(TrapWriter trapwriter) {
    trapwriter.addTuple(
        "extraction_data",
        fileLabel,
        cacheFile != null ? cacheFile.getAbsolutePath() : "",
        canReuseCacheFile,
        length);
  }

  /**
   * Writes the timing metrics to a trap file. Note that this makes the resulting trap file content
   * non-deterministic.
   */
  public void writeTimingsToTrap(TrapWriter trapwriter) {
    if (!stack.isEmpty()) {
      failTimings(
          String.format(
              "Could not properly record extraction times for %s. (stack = %s)%n",
              fileLabel, stack.toString()));
    }
    if (!timingsFailed) {
      for (int i = 0; i < ExtractionPhase.values().length; i++) {
        trapwriter.addTuple("extraction_time", fileLabel, i, 0, (float) cpuTimes[i]);
        trapwriter.addTuple("extraction_time", fileLabel, i, 1, (float) wallclockTimes[i]);
      }
    }
  }

  private void failTimings(String msg) {
    System.err.println(msg);
    System.err.flush();
    this.timingsFailed = true;
  }

  private void incrementCurrentTimer() {
    long nowWallclock = System.nanoTime();
    long nowCpu = thread.getCurrentThreadCpuTime();

    if (!stack.isEmpty()) {
      // increment by the time elapsed
      wallclockTimes[stack.peek().dbschemeId] += nowWallclock - previousWallclockTime;
      cpuTimes[stack.peek().dbschemeId] += nowCpu - previousCpuTime;
    }

    // update the running clock
    previousWallclockTime = nowWallclock;
    previousCpuTime = nowCpu;
  }

  public void setCacheFile(File cacheFile) {
    this.cacheFile = cacheFile;
  }

  public void setCanReuseCacheFile(boolean canReuseCacheFile) {
    this.canReuseCacheFile = canReuseCacheFile;
  }

  public void setFileLabel(Label fileLabel) {
    this.fileLabel = fileLabel;
  }

  public void setLength(int length) {
    this.length = length;
  }

  public void startPhase(ExtractionPhase event) {
    incrementCurrentTimer();
    stack.push(event);
  }

  public void stopPhase(
      ExtractionPhase
          event /* technically not needed, but useful for documentation and consistency checking */) {
    if (stack.isEmpty()) {
      failTimings(
          String.format(
              "Inconsistent extraction time recording: trying to stop timer %s, but no timer is running",
              event));
      return;
    }
    if (stack.peek() != event) {
      failTimings(
          String.format(
              "Inconsistent extraction time recording: trying to stop timer %s, but current timer is: %s",
              event, stack.peek()));
      return;
    }
    incrementCurrentTimer();
    stack.pop();
  }
}

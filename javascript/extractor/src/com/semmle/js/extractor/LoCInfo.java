package com.semmle.js.extractor;

/**
 * Utility class for representing LoC information; really just a glorified <code>
 * Pair&lt;Integer, Integer&gt;</code>.
 */
public class LoCInfo {
  private int linesOfCode, linesOfComments;

  public LoCInfo(int linesOfCode, int linesOfComments) {
    this.linesOfCode = linesOfCode;
    this.linesOfComments = linesOfComments;
  }

  public void add(LoCInfo that) {
    this.linesOfCode += that.linesOfCode;
    this.linesOfComments += that.linesOfComments;
  }

  public int getLinesOfCode() {
    return linesOfCode;
  }

  public int getLinesOfComments() {
    return linesOfComments;
  }
}

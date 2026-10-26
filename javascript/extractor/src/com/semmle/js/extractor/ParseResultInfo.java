package com.semmle.js.extractor;
import com.semmle.js.parser.ParseError;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for representing LoC information and parse errors from running a parser.
 * Just a glorified 3-tuple for lines of code, lines of comments, and parse errors.
 */
public class ParseResultInfo {
  private int linesOfCode, linesOfComments;
  private List<ParseError> parseErrors;
  private String skipReason;

  public ParseResultInfo(int linesOfCode, int linesOfComments, List<ParseError> parseErrors) {
    this.linesOfCode = linesOfCode;
    this.linesOfComments = linesOfComments;
    this.parseErrors = new ArrayList<>(parseErrors);
  }

  private ParseResultInfo() {
    this.linesOfCode = 0;
    this.linesOfComments = 0;
    this.parseErrors = new ArrayList<>();
    this.skipReason = null;
  }

  public static final ParseResultInfo skipped(String reason) {
    ParseResultInfo info = new ParseResultInfo();
    info.skipReason = reason;
    return info;
  }

  public void add(ParseResultInfo that) {
    this.linesOfCode += that.linesOfCode;
    this.linesOfComments += that.linesOfComments;
  }

  public void addParseError(ParseError err) {
    this.parseErrors.add(err);
  }

  public void addParseErrors(List<ParseError> errs) {
    this.parseErrors.addAll(errs);
  }

  public int getLinesOfCode() {
    return linesOfCode;
  }

  public int getLinesOfComments() {
    return linesOfComments;
  }

  public List<ParseError> getParseErrors() {
    return parseErrors;
  }

  /**
   * If extraction of this file was skipped, gets the reason for skipping it.
   */
  public String getSkipReason() {
    return skipReason;
  }
}

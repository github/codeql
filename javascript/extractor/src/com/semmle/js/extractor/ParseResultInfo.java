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

  public ParseResultInfo(int linesOfCode, int linesOfComments, List<ParseError> parseErrors) {
    this.linesOfCode = linesOfCode;
    this.linesOfComments = linesOfComments;
    this.parseErrors = new ArrayList<>(parseErrors);
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
}

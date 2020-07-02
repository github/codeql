package com.semmle.js.extractor;

import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceElement;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;

/**
 * Extractor for populating purely textual information about a file, namely its lines and their line
 * terminators.
 */
public class TextualExtractor {
  private static final Pattern LINE_TERMINATOR = Pattern.compile("\\n|\\r\\n|\\r|\\u2028|\\u2029");
  private static final Pattern INDENT_CHAR = Pattern.compile("((\\s)\\2*)\\S.*");

  private final String source;
  private final TrapWriter trapwriter;
  private final LocationManager locationManager;
  private final Label fileLabel;
  private final boolean extractLines;
  private final ExtractionMetrics metrics;
  private final File extractedFile;

  public TextualExtractor(
      TrapWriter trapwriter,
      LocationManager locationManager,
      String source,
      boolean extractLines,
      ExtractionMetrics metrics,
      File extractedFile) {
    this.trapwriter = trapwriter;
    this.locationManager = locationManager;
    this.source = source;
    this.fileLabel = locationManager.getFileLabel();
    this.extractLines = extractLines;
    this.metrics = metrics;
    this.extractedFile = extractedFile;
  }

  /**
   * Returns the file whose contents should be extracted, and is contained
   * in {@link #source}.
   *
   * <p>This may differ from the source file of the location manager, which refers
   * to the original file that this was derived from.
   */
  public File getExtractedFile() {
    return extractedFile;
  }

  /**
   * Returns true if the extracted file and the source location files are different.
   */
  public boolean isSnippet() {
    return !extractedFile.equals(locationManager.getSourceFile());
  }

  public TrapWriter getTrapwriter() {
    return trapwriter;
  }

  public LocationManager getLocationManager() {
    return locationManager;
  }

  public String getSource() {
    return source;
  }

  public ExtractionMetrics getMetrics() {
    return metrics;
  }

  public String mkToString(SourceElement nd) {
    return sanitiseToString(nd.getLoc().getSource());
  }

  private static final String esc = "\nn\rr\tt";

  public static String sanitiseToString(String str) {
    if (str.length() > 20) str = str.substring(0, 7) + " ... " + str.substring(str.length() - 7);

    StringBuilder res = new StringBuilder();
    for (int i = 0, n = str.length(); i < n; ++i) {
      int c = str.codePointAt(i);
      if (c < 0x20 || c > 0x7e) {
        int j = esc.indexOf(c);
        if (j >= 0) res.append("\\" + esc.charAt(j + 1));
        else res.append("\\u" + String.format("%04x", Integer.valueOf(c)));
      } else {
        res.append((char) c);
      }
    }
    return res.toString();
  }

  /**
   * Emit a lines/4 tuple, if {@link #extractLines} is {@code true}, and an indentation/4 tuple,
   * where applicable, for a line of source code.
   *
   * @param line the text of the line
   * @param term the line terminator
   * @param i the line number
   */
  public void extractLine(String line, String term, int i, Label toplevelKey) {
    if (extractLines) {
      Label key = trapwriter.freshLabel();
      trapwriter.addTuple("lines", key, toplevelKey, line, term);
      locationManager.emitSnippetLocation(key, i, 1, i, line.length());
    }

    Matcher indentCharMatcher = INDENT_CHAR.matcher(line);
    if (indentCharMatcher.matches()) {
      // translate logical line number `i` into actual line number within file
      int lineno = locationManager.translatePosition(new Position(i, 1, 0)).getLine();
      String indentChar = indentCharMatcher.group(2);
      int indentDepth = indentCharMatcher.group(1).length();
      trapwriter.addTuple("indentation", fileLabel, lineno, indentChar, indentDepth);
    }
  }

  /** Extract lexical information about source lines and line numbers. */
  public Position extractLines(String src, Label toplevelKey) {
    int len = src.length(), i = 1, start = 0, llength = 0;

    Matcher matcher = LINE_TERMINATOR.matcher(src);
    while (matcher.find()) {
      String line = src.substring(start, matcher.start());
      llength = line.length();
      extractLine(line, matcher.group(), i++, toplevelKey);
      start = matcher.end();
    }

    if (start < len) {
      extractLine(src.substring(start), "", i, toplevelKey);
      llength = len - start;
    } else {
      --i;
    }

    return new Position(i, llength, len);
  }

  public int getNumLines() {
    Matcher matcher = LINE_TERMINATOR.matcher(source);
    int n = 0, end = 0;
    while (matcher.find()) {
      ++n;
      end = matcher.end();
    }
    if (end < source.length()) ++n;
    return n;
  }

  public String getLine(int lineNumber) {
    Matcher matcher = LINE_TERMINATOR.matcher(source);
    int n = 1, end = 0;
    while (matcher.find()) {
      if (n == lineNumber) return source.substring(end, matcher.end());
      ++n;
      end = matcher.end();
    }
    return source.substring(end);
  }
}

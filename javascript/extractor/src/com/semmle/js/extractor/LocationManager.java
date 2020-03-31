package com.semmle.js.extractor;

import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceElement;
import com.semmle.util.files.FileUtil;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import java.io.File;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * This class handles location information; in particular, it translates locations reported by the
 * various parsers to absolute source file locations.
 */
public class LocationManager {
  private final File sourceFile;
  private final TrapWriter trapWriter;
  private final Label fileLabel;
  private int startColumn;
  private int startLine;
  private final Set<String> locationDefaultEmitted = new LinkedHashSet<String>();
  private String hasLocation = "hasLocation";

  public LocationManager(File sourceFile, TrapWriter trapWriter, Label fileLabel) {
    this.sourceFile = sourceFile;
    this.trapWriter = trapWriter;
    this.fileLabel = fileLabel;
    this.startLine = 1;
    this.startColumn = 1;
  }

  public File getSourceFile() {
    return sourceFile;
  }

  public String getSourceFileExtension() {
    return FileUtil.extension(sourceFile);
  }

  public TrapWriter getTrapWriter() {
    return trapWriter;
  }

  public Label getFileLabel() {
    return fileLabel;
  }

  public int getStartLine() {
    return startLine;
  }

  public int getStartColumn() {
    return startColumn;
  }

  public void setStart(int line, int column) {
    startLine = line;
    startColumn = column;
  }

  public void setHasLocationTable(String hasLocation) {
    this.hasLocation = hasLocation;
  }

  /**
   * Emit location information for an AST node. The node's location is translated from the parser's
   * 0-based column numbering scheme with exclusive offsets into our 1-based scheme with inclusive
   * end-offsets and then emitted as a snippet location.
   */
  public void emitNodeLocation(SourceElement nd, Label lbl) {
    int sl = nd.getLoc().getStart().getLine(),
        sc = nd.getLoc().getStart().getColumn(),
        el = nd.getLoc().getEnd().getLine(),
        ec = nd.getLoc().getEnd().getColumn();
    // adjust start column since the parser uses 0-based indexing
    // (note: no adjustment needed for end column, since the parser also uses
    // exclusive end columns)
    sc++;

    // standardise empty locations
    if (el < sl || el == sl && ec < sc) {
      el = sl;
      ec = sc - 1;
    }

    emitSnippetLocation(lbl, sl, sc, el, ec);
  }

  /**
   * Emit a relative location in the current snippet.
   *
   * @param lbl label to associate with the location
   * @param sl start line (1-based)
   * @param sc start column (1-based, inclusive)
   * @param el end line (1-based)
   * @param ec end column (1-based, inclusive)
   */
  public void emitSnippetLocation(Label lbl, int sl, int sc, int el, int ec) {
    Position start = translatePosition(new Position(sl, sc, -1));
    Position end = translatePosition(new Position(el, ec, -1));
    emitFileLocation(lbl, start.getLine(), start.getColumn(), end.getLine(), end.getColumn());
  }

  /** Emit an absolute location in the current file. No line or column adjustment is performed. */
  public void emitFileLocation(Label lbl, int sl, int sc, int el, int ec) {
    Label locLabel = emitLocationsDefault(sl, sc, el, ec);
    trapWriter.addTuple(hasLocation, lbl, locLabel);
  }

  /**
   * Emit an entry in the {@code locations_default} table. No line or column adjustment is
   * performed.
   */
  public Label emitLocationsDefault(int sl, int sc, int el, int ec) {
    Label locLabel = trapWriter.location(fileLabel, sl, sc, el, ec);
    if (locationDefaultEmitted.add(locLabel.toString()))
      trapWriter.addTuple("locations_default", locLabel, fileLabel, sl, sc, el, ec);
    return locLabel;
  }

  /**
   * Emit location information for a parse error. These locations are special, since their reported
   * line number can be one past the last line in the file. Our toolchain does not like such
   * positions, so we artificially constrain the line number to be in an acceptable range.
   */
  public void emitErrorLocation(Label lbl, Position pos, int numlines) {
    int line = Math.max(1, Math.min(pos.getLine(), numlines));
    int column = Math.max(1, pos.getColumn() + 1);
    this.emitSnippetLocation(lbl, line, column, line, column);
  }

  /** Translate a relative position into an absolute position. */
  public Position translatePosition(Position p) {
    int line = p.getLine(), column = p.getColumn();
    if (line == 1) column += startColumn - 1;
    line += startLine - 1;
    return new Position(line, column, -1);
  }
}

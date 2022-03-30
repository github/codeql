package com.semmle.js.extractor;

import java.nio.file.Path;

import com.semmle.js.extractor.ExtractorConfig.SourceType;

/**
 * Denotes where a code snippet originated from within a file.
 */
public class FileSnippet {
  private Path originalFile;
  private int line;
  private int column;
  private TopLevelKind topLevelKind;
  private SourceType sourceType;

  public FileSnippet(Path originalFile, int line, int column, TopLevelKind topLevelKind, SourceType sourceType) {
    this.originalFile = originalFile;
    this.line = line;
    this.column = column;
    this.topLevelKind = topLevelKind;
    this.sourceType = sourceType;
  }

  public Path getOriginalFile() {
    return originalFile;
  }

  public int getLine() {
    return line;
  }

  public int getColumn() {
    return column;
  }

  public TopLevelKind getTopLevelKind() {
    return topLevelKind;
  }

  public SourceType getSourceType() {
    return sourceType;
  }
}

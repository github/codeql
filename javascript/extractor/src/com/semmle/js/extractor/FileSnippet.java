package com.semmle.js.extractor;

import java.nio.file.Path;

/**
 * Denotes where a code snippet originated from within a file.
 */
public class FileSnippet {
  private Path originalFile;
  private int line;
  private int column;
  private int topLevelKind;

  public FileSnippet(Path originalFile, int line, int column, int topLevelKind) {
    this.originalFile = originalFile;
    this.line = line;
    this.column = column;
    this.topLevelKind = topLevelKind;
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

  public int getTopLevelKind() {
    return topLevelKind;
  }
}

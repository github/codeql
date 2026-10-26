package com.semmle.js.ast;

/**
 * A source position identifying a single character.
 * <p>
 * Note that this class remains distinct from {@link com.semmle.util.locations.Position},
 * due to the 1-based line number convention and the tendency for users of this class to provide
 * dummy offset values. Although the classes are structurally identical, it is not always safe to
 * convert one into the other.
 */
public class Position implements Comparable<Position> {
  private final int line, column, offset;

  public Position(int line, int column, int offset) {
    this.line = line;
    this.column = column;
    this.offset = offset;
  }

  /** The line number (1-based) of this position. */
  public int getLine() {
    return line;
  }

  /** The column number (0-based) of this position. */
  public int getColumn() {
    return column;
  }

  /**
   * The offset (0-based) of this position from the start of the file, that is, the number of
   * characters that precede it.
   * <p>
   * Note that in some cases, a dummy value is filled in for the offset.
   */
  public int getOffset() {
    return offset;
  }

  @Override
  public int compareTo(Position that) {
    if (this.line < that.line) return -1;
    if (this.line == that.line)
      if (this.column < that.column) return -1;
      else if (this.column == that.column) return 0;
      else return 1;
    return 1;
  }

  @Override
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + column;
    result = prime * result + line;
    return result;
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj) return true;
    if (obj == null) return false;
    if (getClass() != obj.getClass()) return false;
    Position other = (Position) obj;
    if (column != other.column) return false;
    if (line != other.line) return false;
    return true;
  }

  @Override
  public String toString() {
    return line + ":" + column;
  }
}

package com.semmle.js.ast;

/** A source location representing a range of characters. */
public class SourceLocation {
  private String source;
  private Position start, end;

  public SourceLocation(String source, Position start, Position end) {
    this.source = source;
    this.start = start;
    this.end = end;
  }

  public SourceLocation(Position start) {
    this(null, start, null);
  }

  public SourceLocation(String source, Position start) {
    this(source, start, null);
  }

  public SourceLocation(SourceLocation that) {
    this(that.source, that.start, that.end);
  }

  /** The source code contained in this location. */
  public String getSource() {
    return source;
  }

  /** Set the source code contain in this location. */
  public void setSource(String source) {
    this.source = source;
  }

  /** The start position of the location. */
  public Position getStart() {
    return start;
  }

  /** Set the start position of this location. */
  public void setStart(Position start) {
    this.start = start;
  }

  /** The end position of the location. */
  public Position getEnd() {
    return end;
  }

  /** Set the end position of this location. */
  public void setEnd(Position end) {
    this.end = end;
  }

  @Override
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((end == null) ? 0 : end.hashCode());
    result = prime * result + ((start == null) ? 0 : start.hashCode());
    return result;
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj) return true;
    if (obj == null) return false;
    if (getClass() != obj.getClass()) return false;
    SourceLocation other = (SourceLocation) obj;
    if (end == null) {
      if (other.end != null) return false;
    } else if (!end.equals(other.end)) return false;
    if (start == null) {
      if (other.start != null) return false;
    } else if (!start.equals(other.start)) return false;
    return true;
  }
}

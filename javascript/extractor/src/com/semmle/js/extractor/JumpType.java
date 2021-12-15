package com.semmle.js.extractor;

/** Simple enum for representing the four kinds of unstructured control flow in JavaScript. */
public enum JumpType {
  BREAK,
  CONTINUE,
  THROW,
  RETURN;
}

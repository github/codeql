package com.semmle.js.extractor;

/** The amount of information to extract from TypeScript files. */
public enum TypeScriptMode {
  /** TypeScript files will not be extracted. */
  NONE,

  /**
   * Only syntactic information will be extracted from TypeScript files.
   *
   * <p>This requires Node.js and the TypeScript compiler to be installed if the project contains
   * any TypeScript files.
   */
  BASIC,

  /** Extract as much as possible from TypeScript files. */
  FULL;
}

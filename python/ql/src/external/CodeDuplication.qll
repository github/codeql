/** Provides classes for detecting duplicate or similar code. */

import python

/** Gets the relative path of `file`, with backslashes replaced by forward slashes. */
private string relativePath(File file) { result = file.getRelativePath().replaceAll("\\", "/") }

/**
 * Holds if the `index`-th token of block `copy` is in file `file`, spanning
 * column `sc` of line `sl` to column `ec` of line `el`.
 *
 * For more information, see [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
 */
pragma[noinline, nomagic]
private predicate tokenLocation(File file, int sl, int sc, int ec, int el, Copy copy, int index) {
  file = copy.sourceFile() and
  tokens(copy, index, sl, sc, ec, el)
}

/** A token block used for detection of duplicate and similar code. */
class Copy extends @duplication_or_similarity {
  private int lastToken() { result = max(int i | tokens(this, i, _, _, _, _) | i) }

  /** Gets the index of the token in this block starting at the location `loc`, if any. */
  int tokenStartingAt(Location loc) {
    tokenLocation(loc.getFile(), loc.getStartLine(), loc.getStartColumn(), _, _, this, result)
  }

  /** Gets the index of the token in this block ending at the location `loc`, if any. */
  int tokenEndingAt(Location loc) {
    tokenLocation(loc.getFile(), _, _, loc.getEndLine(), loc.getEndColumn(), this, result)
  }

  /** Gets the line on which the first token in this block starts. */
  int sourceStartLine() { tokens(this, 0, result, _, _, _) }

  /** Gets the column on which the first token in this block starts. */
  int sourceStartColumn() { tokens(this, 0, _, result, _, _) }

  /** Gets the line on which the last token in this block ends. */
  int sourceEndLine() { tokens(this, this.lastToken(), _, _, result, _) }

  /** Gets the column on which the last token in this block ends. */
  int sourceEndColumn() { tokens(this, this.lastToken(), _, _, _, result) }

  /** Gets the number of lines containing at least (part of) one token in this block. */
  int sourceLines() { result = this.sourceEndLine() + 1 - this.sourceStartLine() }

  /** Gets an opaque identifier for the equivalence class of this block. */
  int getEquivalenceClass() { duplicateCode(this, _, result) or similarCode(this, _, result) }

  /** Gets the source file in which this block appears. */
  File sourceFile() {
    exists(string name | duplicateCode(this, name, _) or similarCode(this, name, _) |
      name.replaceAll("\\", "/") = relativePath(result)
    )
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    sourceFile().getAbsolutePath() = filepath and
    startline = sourceStartLine() and
    startcolumn = sourceStartColumn() and
    endline = sourceEndLine() and
    endcolumn = sourceEndColumn()
  }

  /** Gets a textual representation of this element. */
  string toString() { result = "Copy" }

  /**
   * Gets a block that extends this one, that is, its first token is also
   * covered by this block, but they are not the same block.
   */
  Copy extendingBlock() {
    exists(File file, int sl, int sc, int ec, int el |
      tokenLocation(file, sl, sc, ec, el, this, _) and
      tokenLocation(file, sl, sc, ec, el, result, 0)
    ) and
    this != result
  }
}

/**
 * Holds if there is a sequence of `SimilarBlock`s `start1, ..., end1` and another sequence
 * `start2, ..., end2` such that each block extends the previous one and corresponding blocks
 * have the same equivalence class, with `start` being the equivalence class of `start1` and
 * `start2`, and `end` the equivalence class of `end1` and `end2`.
 */
predicate similar_extension(
  SimilarBlock start1, SimilarBlock start2, SimilarBlock ext1, SimilarBlock ext2, int start, int ext
) {
  start1.getEquivalenceClass() = start and
  start2.getEquivalenceClass() = start and
  ext1.getEquivalenceClass() = ext and
  ext2.getEquivalenceClass() = ext and
  start1 != start2 and
  (
    ext1 = start1 and ext2 = start2
    or
    similar_extension(start1.extendingBlock(), start2.extendingBlock(), ext1, ext2, _, ext)
  )
}

/**
 * Holds if there is a sequence of `DuplicateBlock`s `start1, ..., end1` and another sequence
 * `start2, ..., end2` such that each block extends the previous one and corresponding blocks
 * have the same equivalence class, with `start` being the equivalence class of `start1` and
 * `start2`, and `end` the equivalence class of `end1` and `end2`.
 */
predicate duplicate_extension(
  DuplicateBlock start1, DuplicateBlock start2, DuplicateBlock ext1, DuplicateBlock ext2, int start,
  int ext
) {
  start1.getEquivalenceClass() = start and
  start2.getEquivalenceClass() = start and
  ext1.getEquivalenceClass() = ext and
  ext2.getEquivalenceClass() = ext and
  start1 != start2 and
  (
    ext1 = start1 and ext2 = start2
    or
    duplicate_extension(start1.extendingBlock(), start2.extendingBlock(), ext1, ext2, _, ext)
  )
}

/** A block of duplicated code. */
class DuplicateBlock extends Copy, @duplication {
  override string toString() { result = "Duplicate code: " + sourceLines() + " duplicated lines." }
}

/** A block of similar code. */
class SimilarBlock extends Copy, @similarity {
  override string toString() {
    result = "Similar code: " + sourceLines() + " almost duplicated lines."
  }
}

/**
 * Holds if `stmt1` and `stmt2` are duplicate statements in function or toplevel `sc1` and `sc2`,
 * respectively, where `scope1` and `scope2` are not the same.
 */
predicate duplicateStatement(Scope scope1, Scope scope2, Stmt stmt1, Stmt stmt2) {
  exists(int equivstart, int equivend, int first, int last |
    scope1.contains(stmt1) and
    scope2.contains(stmt2) and
    duplicateCoversStatement(equivstart, equivend, first, last, stmt1) and
    duplicateCoversStatement(equivstart, equivend, first, last, stmt2) and
    stmt1 != stmt2 and
    scope1 != scope2
  )
}

/**
 * Holds if statement `stmt` is covered by a sequence of `DuplicateBlock`s, where `first`
 * is the index of the token in the first block that starts at the beginning of `stmt`,
 * while `last` is the index of the token in the last block that ends at the end of `stmt`,
 * and `equivstart` and `equivend` are the equivalence classes of the first and the last
 * block, respectively.
 */
private predicate duplicateCoversStatement(
  int equivstart, int equivend, int first, int last, Stmt stmt
) {
  exists(DuplicateBlock b1, DuplicateBlock b2, Location startloc, Location endloc |
    stmt.getLocation() = startloc and
    stmt.getLastStatement().getLocation() = endloc and
    first = b1.tokenStartingAt(startloc) and
    last = b2.tokenEndingAt(endloc) and
    b1.getEquivalenceClass() = equivstart and
    b2.getEquivalenceClass() = equivend and
    duplicate_extension(b1, _, b2, _, equivstart, equivend)
  )
}

/**
 * Holds if `sc1` is a function or toplevel with `total` lines, and `scope2` is a function or
 * toplevel that has `duplicate` lines in common with `scope1`.
 */
predicate duplicateStatements(Scope scope1, Scope scope2, int duplicate, int total) {
  duplicate = strictcount(Stmt stmt | duplicateStatement(scope1, scope2, stmt, _)) and
  total = strictcount(Stmt stmt | scope1.contains(stmt))
}

/**
 * Find pairs of scopes that are identical or almost identical
 */
predicate duplicateScopes(Scope s, Scope other, float percent, string message) {
  exists(int total, int duplicate | duplicateStatements(s, other, duplicate, total) |
    percent = 100.0 * duplicate / total and
    percent >= 80.0 and
    if duplicate = total
    then message = "All " + total + " statements in " + s.getName() + " are identical in $@."
    else
      message =
        duplicate + " out of " + total + " statements in " + s.getName() + " are duplicated in $@."
  )
}

/**
 * Holds if `stmt1` and `stmt2` are similar statements in function or toplevel `scope1` and `scope2`,
 * respectively, where `scope1` and `scope2` are not the same.
 */
private predicate similarStatement(Scope scope1, Scope scope2, Stmt stmt1, Stmt stmt2) {
  exists(int start, int end, int first, int last |
    scope1.contains(stmt1) and
    scope2.contains(stmt2) and
    similarCoversStatement(start, end, first, last, stmt1) and
    similarCoversStatement(start, end, first, last, stmt2) and
    stmt1 != stmt2 and
    scope1 != scope2
  )
}

/**
 * Holds if statement `stmt` is covered by a sequence of `SimilarBlock`s, where `first`
 * is the index of the token in the first block that starts at the beginning of `stmt`,
 * while `last` is the index of the token in the last block that ends at the end of `stmt`,
 * and `equivstart` and `equivend` are the equivalence classes of the first and the last
 * block, respectively.
 */
private predicate similarCoversStatement(
  int equivstart, int equivend, int first, int last, Stmt stmt
) {
  exists(SimilarBlock b1, SimilarBlock b2, Location startloc, Location endloc |
    stmt.getLocation() = startloc and
    stmt.getLastStatement().getLocation() = endloc and
    first = b1.tokenStartingAt(startloc) and
    last = b2.tokenEndingAt(endloc) and
    b1.getEquivalenceClass() = equivstart and
    b2.getEquivalenceClass() = equivend and
    similar_extension(b1, _, b2, _, equivstart, equivend)
  )
}

/**
 * Holds if `sc1` is a function or toplevel with `total` lines, and `scope2` is a function or
 * toplevel that has `similar` similar lines to `scope1`.
 */
private predicate similarStatements(Scope scope1, Scope scope2, int similar, int total) {
  similar = strictcount(Stmt stmt | similarStatement(scope1, scope2, stmt, _)) and
  total = strictcount(Stmt stmt | scope1.contains(stmt))
}

/**
 * Find pairs of scopes that are similar
 */
predicate similarScopes(Scope s, Scope other, float percent, string message) {
  exists(int total, int similar | similarStatements(s, other, similar, total) |
    percent = 100.0 * similar / total and
    percent >= 80.0 and
    if similar = total
    then message = "All statements in " + s.getName() + " are similar in $@."
    else
      message =
        similar + " out of " + total + " statements in " + s.getName() + " are similar in $@."
  )
}

/**
 * Holds if the line is acceptable as a duplicate.
 * This is true for blocks of import statements.
 */
predicate allowlistedLineForDuplication(File f, int line) {
  exists(ImportingStmt i | i.getLocation().getFile() = f and i.getLocation().getStartLine() = line)
}

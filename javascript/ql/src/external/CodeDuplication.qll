/** Provides classes for detecting duplicate or similar code. */

import semmle.javascript.Files

/** Gets the relative path of `file`, with backslashes replaced by forward slashes. */
private string relativePath(File file) { result = file.getRelativePath().replaceAll("\\", "/") }

/**
 * Holds if the `index`-th token of block `copy` is in file `file`, spanning
 * column `sc` of line `sl` to column `ec` of line `el`.
 *
 * For more information, see [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
 */
pragma[noinline]
private predicate tokenLocation(File file, int sl, int sc, int ec, int el, Copy copy, int index) {
  file = copy.sourceFile() and
  tokens(copy, index, sl, sc, ec, el)
}

/** A token block used for detection of duplicate and similar code. */
class Copy extends @duplication_or_similarity {
  /** Gets the index of the last token in this block. */
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
  string toString() { none() }

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
  SimilarBlock start1, SimilarBlock start2, SimilarBlock end1, SimilarBlock end2, int start, int end
) {
  start1.getEquivalenceClass() = start and
  start2.getEquivalenceClass() = start and
  end1.getEquivalenceClass() = end and
  end2.getEquivalenceClass() = end and
  start1 != start2 and
  (
    end1 = start1 and end2 = start2
    or
    similar_extension(start1.extendingBlock(), start2.extendingBlock(), end1, end2, _, end)
  )
}

/**
 * Holds if there is a sequence of `DuplicateBlock`s `start1, ..., end1` and another sequence
 * `start2, ..., end2` such that each block extends the previous one and corresponding blocks
 * have the same equivalence class, with `start` being the equivalence class of `start1` and
 * `start2`, and `end` the equivalence class of `end1` and `end2`.
 */
predicate duplicate_extension(
  DuplicateBlock start1, DuplicateBlock start2, DuplicateBlock end1, DuplicateBlock end2, int start,
  int end
) {
  start1.getEquivalenceClass() = start and
  start2.getEquivalenceClass() = start and
  end1.getEquivalenceClass() = end and
  end2.getEquivalenceClass() = end and
  start1 != start2 and
  (
    end1 = start1 and end2 = start2
    or
    duplicate_extension(start1.extendingBlock(), start2.extendingBlock(), end1, end2, _, end)
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

/** Holds if statement `s` is in function or toplevel `sc`. */
private predicate stmtInContainer(Stmt s, StmtContainer sc) {
  s.getContainer() = sc and
  not s instanceof BlockStmt
}

/**
 * Holds if `stmt1` and `stmt2` are duplicate statements in function or toplevel `sc1` and `sc2`,
 * respectively, where `sc1` and `sc2` are not the same.
 */
predicate duplicateStatement(StmtContainer sc1, StmtContainer sc2, Stmt stmt1, Stmt stmt2) {
  exists(int equivstart, int equivend, int first, int last |
    stmtInContainer(stmt1, sc1) and
    stmtInContainer(stmt2, sc2) and
    duplicateCoversStatement(equivstart, equivend, first, last, stmt1) and
    duplicateCoversStatement(equivstart, equivend, first, last, stmt2) and
    stmt1 != stmt2 and
    sc1 != sc2
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
  exists(DuplicateBlock b1, DuplicateBlock b2, Location loc |
    stmt.getLocation() = loc and
    first = b1.tokenStartingAt(loc) and
    last = b2.tokenEndingAt(loc) and
    b1.getEquivalenceClass() = equivstart and
    b2.getEquivalenceClass() = equivend and
    duplicate_extension(b1, _, b2, _, equivstart, equivend)
  )
}

/**
 * Holds if `sc1` is a function or toplevel with `total` lines, and `sc2` is a function or
 * toplevel that has `duplicate` lines in common with `sc1`.
 */
private predicate duplicateStatements(StmtContainer sc1, StmtContainer sc2, int duplicate, int total) {
  duplicate = strictcount(Stmt stmt | duplicateStatement(sc1, sc2, stmt, _)) and
  total = strictcount(Stmt stmt | stmtInContainer(stmt, sc1))
}

/**
 * Holds if `sc` and `other` are functions or toplevels where `percent` is the percentage
 * of lines they have in common, which is greater than 90%.
 */
predicate duplicateContainers(StmtContainer sc, StmtContainer other, float percent) {
  exists(int total, int duplicate | duplicateStatements(sc, other, duplicate, total) |
    percent = 100.0 * duplicate / total and
    percent > 90.0
  )
}

/**
 * Holds if `stmt1` and `stmt2` are similar statements in function or toplevel `sc1` and `sc2`,
 * respectively, where `sc1` and `sc2` are not the same.
 */
private predicate similarStatement(StmtContainer sc1, StmtContainer sc2, Stmt stmt1, Stmt stmt2) {
  exists(int start, int end, int first, int last |
    stmtInContainer(stmt1, sc1) and
    stmtInContainer(stmt2, sc2) and
    similarCoversStatement(start, end, first, last, stmt1) and
    similarCoversStatement(start, end, first, last, stmt2) and
    stmt1 != stmt2 and
    sc1 != sc2
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
  exists(SimilarBlock b1, SimilarBlock b2, Location loc |
    stmt.getLocation() = loc and
    first = b1.tokenStartingAt(loc) and
    last = b2.tokenEndingAt(loc) and
    b1.getEquivalenceClass() = equivstart and
    b2.getEquivalenceClass() = equivend and
    similar_extension(b1, _, b2, _, equivstart, equivend)
  )
}

/**
 * Holds if `sc1` is a function or toplevel with `total` lines, and `sc2` is a function or
 * toplevel that has `similar` similar lines to `sc1`.
 */
private predicate similarStatements(StmtContainer sc1, StmtContainer sc2, int similar, int total) {
  similar = strictcount(Stmt stmt | similarStatement(sc1, sc2, stmt, _)) and
  total = strictcount(Stmt stmt | stmtInContainer(stmt, sc1))
}

/**
 * Holds if `sc` and `other` are functions or toplevels where `percent` is the percentage
 * of similar lines between the two, which is greater than 90%.
 */
predicate similarContainers(StmtContainer sc, StmtContainer other, float percent) {
  exists(int total, int similar | similarStatements(sc, other, similar, total) |
    percent = 100.0 * similar / total and
    percent > 90.0
  )
}

/**
 * INTERNAL: do not use.
 *
 * Holds if `line` in `f` is similar to a line somewhere else.
 */
predicate similarLines(File f, int line) {
  exists(SimilarBlock b | b.sourceFile() = f and line in [b.sourceStartLine() .. b.sourceEndLine()])
}

private predicate similarLinesPerEquivalenceClass(int equivClass, int lines, File f) {
  lines =
    strictsum(SimilarBlock b, int toSum |
      (b.sourceFile() = f and b.getEquivalenceClass() = equivClass) and
      toSum = b.sourceLines()
    |
      toSum
    )
}

/** Holds if `coveredLines` lines of `f` are similar to lines in `otherFile`. */
pragma[noopt]
private predicate similarLinesCovered(File f, int coveredLines, File otherFile) {
  exists(int numLines | numLines = f.getNumberOfLines() |
    exists(int coveredApprox |
      coveredApprox =
        strictsum(int num |
          exists(int equivClass |
            similarLinesPerEquivalenceClass(equivClass, num, f) and
            similarLinesPerEquivalenceClass(equivClass, num, otherFile) and
            f != otherFile
          )
        ) and
      exists(int n, int product | product = coveredApprox * 100 and n = product / numLines | n > 75)
    ) and
    exists(int notCovered |
      notCovered = count(int j | j in [1 .. numLines] and not similarLines(f, j)) and
      coveredLines = numLines - notCovered
    )
  )
}

/**
 * INTERNAL: do not use.
 *
 * Holds if `line` in `f` is duplicated by a line somewhere else.
 */
predicate duplicateLines(File f, int line) {
  exists(DuplicateBlock b |
    b.sourceFile() = f and line in [b.sourceStartLine() .. b.sourceEndLine()]
  )
}

private predicate duplicateLinesPerEquivalenceClass(int equivClass, int lines, File f) {
  lines =
    strictsum(DuplicateBlock b, int toSum |
      (b.sourceFile() = f and b.getEquivalenceClass() = equivClass) and
      toSum = b.sourceLines()
    |
      toSum
    )
}

/** Holds if `coveredLines` lines of `f` are duplicates of lines in `otherFile`. */
pragma[noopt]
private predicate duplicateLinesCovered(File f, int coveredLines, File otherFile) {
  exists(int numLines | numLines = f.getNumberOfLines() |
    exists(int coveredApprox |
      coveredApprox =
        strictsum(int num |
          exists(int equivClass |
            duplicateLinesPerEquivalenceClass(equivClass, num, f) and
            duplicateLinesPerEquivalenceClass(equivClass, num, otherFile) and
            f != otherFile
          )
        ) and
      exists(int n, int product | product = coveredApprox * 100 and n = product / numLines | n > 75)
    ) and
    exists(int notCovered |
      notCovered = count(int j | j in [1 .. numLines] and not duplicateLines(f, j)) and
      coveredLines = numLines - notCovered
    )
  )
}

/** Holds if most of `f` (`percent`%) is similar to `other`. */
predicate similarFiles(File f, File other, int percent) {
  exists(int covered, int total |
    similarLinesCovered(f, covered, other) and
    total = f.getNumberOfLines() and
    covered * 100 / total = percent and
    percent > 80
  ) and
  not duplicateFiles(f, other, _)
}

/** Holds if most of `f` (`percent`%) is duplicated by `other`. */
predicate duplicateFiles(File f, File other, int percent) {
  exists(int covered, int total |
    duplicateLinesCovered(f, covered, other) and
    total = f.getNumberOfLines() and
    covered * 100 / total = percent and
    percent > 70
  )
}

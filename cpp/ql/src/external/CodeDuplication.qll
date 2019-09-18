import cpp

private string relativePath(File file) { result = file.getRelativePath().replaceAll("\\", "/") }

cached
private predicate tokenLocation(string path, int sl, int sc, int ec, int el, Copy copy, int index) {
  path = copy.sourceFile().getAbsolutePath() and
  tokens(copy, index, sl, sc, ec, el)
}

class Copy extends @duplication_or_similarity {
  private int lastToken() { result = max(int i | tokens(this, i, _, _, _, _) | i) }

  int tokenStartingAt(Location loc) {
    exists(string filepath, int startline, int startcol |
      loc.hasLocationInfo(filepath, startline, startcol, _, _) and
      tokenLocation(filepath, startline, startcol, _, _, this, result)
    )
  }

  int tokenEndingAt(Location loc) {
    exists(string filepath, int endline, int endcol |
      loc.hasLocationInfo(filepath, _, _, endline, endcol) and
      tokenLocation(filepath, _, _, endline, endcol, this, result)
    )
  }

  int sourceStartLine() { tokens(this, 0, result, _, _, _) }

  int sourceStartColumn() { tokens(this, 0, _, result, _, _) }

  int sourceEndLine() { tokens(this, lastToken(), _, _, result, _) }

  int sourceEndColumn() { tokens(this, lastToken(), _, _, _, result) }

  int sourceLines() { result = this.sourceEndLine() + 1 - this.sourceStartLine() }

  int getEquivalenceClass() { duplicateCode(this, _, result) or similarCode(this, _, result) }

  File sourceFile() {
    exists(string name | duplicateCode(this, name, _) or similarCode(this, name, _) |
      name.replaceAll("\\", "/") = relativePath(result)
    )
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    sourceFile().getAbsolutePath() = filepath and
    startline = sourceStartLine() and
    startcolumn = sourceStartColumn() and
    endline = sourceEndLine() and
    endcolumn = sourceEndColumn()
  }

  string toString() { none() }
}

class DuplicateBlock extends Copy, @duplication {
  override string toString() { result = "Duplicate code: " + sourceLines() + " duplicated lines." }
}

class SimilarBlock extends Copy, @similarity {
  override string toString() {
    result = "Similar code: " + sourceLines() + " almost duplicated lines."
  }
}

FunctionDeclarationEntry sourceMethod() {
  result.isDefinition() and
  exists(result.getLocation()) and
  numlines(unresolveElement(result.getFunction()), _, _, _)
}

int numberOfSourceMethods(Class c) {
  result = count(FunctionDeclarationEntry m |
      m = sourceMethod() and
      m.getFunction().getDeclaringType() = c
    )
}

private predicate blockCoversStatement(int equivClass, int first, int last, Stmt stmt) {
  exists(DuplicateBlock b, Location loc |
    stmt.getLocation() = loc and
    first = b.tokenStartingAt(loc) and
    last = b.tokenEndingAt(loc) and
    b.getEquivalenceClass() = equivClass
  )
}

private Stmt statementInMethod(FunctionDeclarationEntry m) {
  result.getParent+() = m.getBlock() and
  not result.getLocation() instanceof UnknownStmtLocation and
  not result instanceof Block
}

private predicate duplicateStatement(
  FunctionDeclarationEntry m1, FunctionDeclarationEntry m2, Stmt s1, Stmt s2
) {
  exists(int equivClass, int first, int last |
    s1 = statementInMethod(m1) and
    s2 = statementInMethod(m2) and
    blockCoversStatement(equivClass, first, last, s1) and
    blockCoversStatement(equivClass, first, last, s2) and
    s1 != s2 and
    m1 != m2
  )
}

predicate duplicateStatements(
  FunctionDeclarationEntry m1, FunctionDeclarationEntry m2, int duplicate, int total
) {
  duplicate = strictcount(Stmt s | duplicateStatement(m1, m2, s, _)) and
  total = strictcount(statementInMethod(m1))
}

/**
 * Find pairs of methods are identical
 */
predicate duplicateMethod(FunctionDeclarationEntry m, FunctionDeclarationEntry other) {
  exists(int total | duplicateStatements(m, other, total, total))
}

predicate similarLines(File f, int line) {
  exists(SimilarBlock b | b.sourceFile() = f and line in [b.sourceStartLine() .. b.sourceEndLine()])
}

private predicate similarLinesPerEquivalenceClass(int equivClass, int lines, File f) {
  lines = strictsum(SimilarBlock b, int toSum |
      (b.sourceFile() = f and b.getEquivalenceClass() = equivClass) and
      toSum = b.sourceLines()
    |
      toSum
    )
}

private predicate similarLinesCoveredFiles(File f, File otherFile) {
  exists(int numLines | numLines = f.getMetrics().getNumberOfLines() |
    exists(int coveredApprox |
      coveredApprox = strictsum(int num |
          exists(int equivClass |
            similarLinesPerEquivalenceClass(equivClass, num, f) and
            similarLinesPerEquivalenceClass(equivClass, num, otherFile) and
            f != otherFile
          )
        ) and
      (coveredApprox * 100) / numLines > 75
    )
  )
}

predicate similarLinesCovered(File f, int coveredLines, File otherFile) {
  exists(int numLines | numLines = f.getMetrics().getNumberOfLines() |
    similarLinesCoveredFiles(f, otherFile) and
    exists(int notCovered |
      notCovered = count(int j |
          j in [1 .. numLines] and
          not similarLines(f, j)
        ) and
      coveredLines = numLines - notCovered
    )
  )
}

predicate duplicateLines(File f, int line) {
  exists(DuplicateBlock b |
    b.sourceFile() = f and line in [b.sourceStartLine() .. b.sourceEndLine()]
  )
}

private predicate duplicateLinesPerEquivalenceClass(int equivClass, int lines, File f) {
  lines = strictsum(DuplicateBlock b, int toSum |
      (b.sourceFile() = f and b.getEquivalenceClass() = equivClass) and
      toSum = b.sourceLines()
    |
      toSum
    )
}

predicate duplicateLinesCovered(File f, int coveredLines, File otherFile) {
  exists(int numLines | numLines = f.getMetrics().getNumberOfLines() |
    exists(int coveredApprox |
      coveredApprox = strictsum(int num |
          exists(int equivClass |
            duplicateLinesPerEquivalenceClass(equivClass, num, f) and
            duplicateLinesPerEquivalenceClass(equivClass, num, otherFile) and
            f != otherFile
          )
        ) and
      (coveredApprox * 100) / numLines > 75
    ) and
    exists(int notCovered |
      notCovered = count(int j |
          j in [1 .. numLines] and
          not duplicateLines(f, j)
        ) and
      coveredLines = numLines - notCovered
    )
  )
}

predicate similarFiles(File f, File other, int percent) {
  exists(int covered, int total |
    similarLinesCovered(f, covered, other) and
    total = f.getMetrics().getNumberOfLines() and
    covered * 100 / total = percent and
    percent > 80
  ) and
  not duplicateFiles(f, other, _)
}

predicate duplicateFiles(File f, File other, int percent) {
  exists(int covered, int total |
    duplicateLinesCovered(f, covered, other) and
    total = f.getMetrics().getNumberOfLines() and
    covered * 100 / total = percent and
    percent > 70
  )
}

predicate mostlyDuplicateClassBase(Class c, Class other, int numDup, int total) {
  numDup = strictcount(FunctionDeclarationEntry m1 |
      exists(FunctionDeclarationEntry m2 |
        duplicateMethod(m1, m2) and
        m1 = sourceMethod() and
        exists(Function f | f = m1.getFunction() and f.getDeclaringType() = c) and
        exists(Function f | f = m2.getFunction() and f.getDeclaringType() = other) and
        c != other
      )
    ) and
  total = numberOfSourceMethods(c) and
  (numDup * 100) / total > 80
}

predicate mostlyDuplicateClass(Class c, Class other, string message) {
  exists(int numDup, int total |
    mostlyDuplicateClassBase(c, other, numDup, total) and
    (
      total != numDup and
      exists(string s1, string s2, string s3, string name |
        s1 = " out of " and
        s2 = " methods in " and
        s3 = " are duplicated in $@." and
        name = c.getName()
      |
        message = numDup + s1 + total + s2 + name + s3
      )
      or
      total = numDup and
      exists(string s1, string s2, string name |
        s1 = "All methods in " and s2 = " are identical in $@." and name = c.getName()
      |
        message = s1 + name + s2
      )
    )
  )
}

predicate fileLevelDuplication(File f, File other) {
  similarFiles(f, other, _) or duplicateFiles(f, other, _)
}

predicate classLevelDuplication(Class c, Class other) { mostlyDuplicateClass(c, other, _) }

predicate whitelistedLineForDuplication(File f, int line) {
  exists(Include i | i.getFile() = f and i.getLocation().getStartLine() = line)
}

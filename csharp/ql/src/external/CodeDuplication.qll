import csharp

private string relativePath(File file) { result = file.getRelativePath().replaceAll("\\", "/") }

/**
 * Holds if the `index`-th token of block `copy` is in file `file`, spanning
 * column `sc` of line `sl` to column `ec` of line `el`.
 *
 * For more information, see [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
 */
pragma[nomagic]
predicate tokenLocation(File file, int sl, int sc, int ec, int el, Copy copy, int index) {
  file = copy.sourceFile() and
  tokens(copy, index, sl, sc, ec, el)
}

class Copy extends @duplication_or_similarity {
  private int lastToken() { result = max(int i | tokens(this, i, _, _, _, _) | i) }

  int tokenStartingAt(Location loc) {
    tokenLocation(loc.getFile(), loc.getStartLine(), loc.getStartColumn(), _, _, this, result)
  }

  int tokenEndingAt(Location loc) {
    tokenLocation(loc.getFile(), _, _, loc.getEndLine(), loc.getEndColumn(), this, result)
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

private Method sourceMethod() { method_location(result, _) and numlines(result, _, _, _) }

private int numberOfSourceMethods(Class c) {
  result = count(Method m | m = sourceMethod() and m.getDeclaringType() = c)
}

private predicate blockCoversStatement(int equivClass, int first, int last, Stmt stmt) {
  exists(DuplicateBlock b, Location loc |
    stmt.getLocation() = loc and
    first = b.tokenStartingAt(loc) and
    last = b.tokenEndingAt(loc) and
    b.getEquivalenceClass() = equivClass
  )
}

private Stmt statementInMethod(Method m) {
  result.getEnclosingCallable() = m and
  not result instanceof BlockStmt
}

private predicate duplicateStatement(Method m1, Method m2, Stmt s1, Stmt s2) {
  exists(int equivClass, int first, int last |
    s1 = statementInMethod(m1) and
    s2 = statementInMethod(m2) and
    blockCoversStatement(equivClass, first, last, s1) and
    blockCoversStatement(equivClass, first, last, s2) and
    s1 != s2 and
    m1 != m2
  )
}

/** Holds if `duplicate` number of statements are duplicated in the methods. */
predicate duplicateStatements(Method m1, Method m2, int duplicate, int total) {
  duplicate = strictcount(Stmt s | duplicateStatement(m1, m2, s, _)) and
  total = strictcount(statementInMethod(m1))
}

/**
 * Find pairs of methods are identical
 */
predicate duplicateMethod(Method m, Method other) {
  exists(int total | duplicateStatements(m, other, total, total))
}

private predicate similarLines(File f, int line) {
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
      notCovered =
        count(int j |
          j in [1 .. numLines] and
          not similarLines(f, j)
        ) and
      coveredLines = numLines - notCovered
    )
  )
}

private predicate duplicateLines(File f, int line) {
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
      notCovered =
        count(int j |
          j in [1 .. numLines] and
          not duplicateLines(f, j)
        ) and
      coveredLines = numLines - notCovered
    )
  )
}

/** Holds if the two files are not duplicated but have more than 80% similar lines. */
predicate similarFiles(File f, File other, int percent) {
  exists(int covered, int total |
    similarLinesCovered(f, covered, other) and
    total = f.getNumberOfLines() and
    covered * 100 / total = percent and
    percent > 80
  ) and
  not duplicateFiles(f, other, _)
}

/** Holds if the two files have more than 70% duplicated lines. */
predicate duplicateFiles(File f, File other, int percent) {
  exists(int covered, int total |
    duplicateLinesCovered(f, covered, other) and
    total = f.getNumberOfLines() and
    covered * 100 / total = percent and
    percent > 70
  )
}

pragma[noopt]
private predicate duplicateAnonymousClass(AnonymousClass c, AnonymousClass other) {
  exists(int numDup |
    numDup =
      strictcount(Method m1 |
        exists(Method m2 |
          duplicateMethod(m1, m2) and
          m1 = sourceMethod() and
          m1.getDeclaringType() = c and
          c instanceof AnonymousClass and
          m2.getDeclaringType() = other and
          other instanceof AnonymousClass and
          c != other
        )
      ) and
    numDup = numberOfSourceMethods(c) and
    numDup = numberOfSourceMethods(other) and
    forall(Type t | c.getABaseType() = t | t = other.getABaseType())
  )
}

pragma[noopt]
private predicate mostlyDuplicateClassBase(Class c, Class other, int numDup, int total) {
  numDup =
    strictcount(Method m1 |
      exists(Method m2 |
        duplicateMethod(m1, m2) and
        m1 = sourceMethod() and
        m1.getDeclaringType() = c and
        m2.getDeclaringType() = other and
        other instanceof Class and
        c != other
      )
    ) and
  total = numberOfSourceMethods(c) and
  exists(int n, int product | product = 100 * numDup and n = product / total | n > 80) and
  not c instanceof AnonymousClass and
  not other instanceof AnonymousClass
}

/** Holds if the methods in the two classes are more than 80% duplicated. */
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

/** Holds if the two files are similar or duplicated. */
predicate fileLevelDuplication(File f, File other) {
  similarFiles(f, other, _) or duplicateFiles(f, other, _)
}

/**
 * Holds if the two classes are duplicated anonymous classes or more than 80% of
 * their methods are duplicated.
 */
predicate classLevelDuplication(Class c, Class other) {
  duplicateAnonymousClass(c, other) or mostlyDuplicateClass(c, other, _)
}

private Element whitelistedDuplicateElement() {
  result instanceof UsingNamespaceDirective or
  result instanceof UsingStaticDirective
}

/**
 * Holds if the `line` in the `file` contains an element, such as a `using`
 * directive, that is not considered for code duplication.
 */
predicate whitelistedLineForDuplication(File file, int line) {
  exists(Location loc | loc = whitelistedDuplicateElement().getLocation() |
    line = loc.getStartLine() and file = loc.getFile()
  )
}

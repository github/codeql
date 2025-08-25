import java

/*
 * Counting nontrivial literal occurrences
 */

private predicate trivialPositiveIntValue(string s) {
  s =
    [
      "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16",
      "17", "18", "19", "20", "32", "64", "128", "256", "512", "1024", "2048", "4096", "16384",
      "32768", "65536", "1048576", "2147483648", "4294967296", "31", "63", "127", "255", "511",
      "1023", "2047", "4095", "16383", "32767", "65535", "1048577", "2147483647", "4294967295",
      "0x00000001", "0x00000002", "0x00000004", "0x00000008", "0x00000010", "0x00000020",
      "0x00000040", "0x00000080", "0x00000100", "0x00000200", "0x00000400", "0x00000800",
      "0x00001000", "0x00002000", "0x00004000", "0x00008000", "0x00010000", "0x00020000",
      "0x00040000", "0x00080000", "0x00100000", "0x00200000", "0x00400000", "0x00800000",
      "0x01000000", "0x02000000", "0x04000000", "0x08000000", "0x10000000", "0x20000000",
      "0x40000000", "0x80000000", "0x00000003", "0x00000007", "0x0000000f", "0x0000001f",
      "0x0000003f", "0x0000007f", "0x000000ff", "0x000001ff", "0x000003ff", "0x000007ff",
      "0x00000fff", "0x00001fff", "0x00003fff", "0x00007fff", "0x0000ffff", "0x0001ffff",
      "0x0003ffff", "0x0007ffff", "0x000fffff", "0x001fffff", "0x003fffff", "0x007fffff",
      "0x00ffffff", "0x01ffffff", "0x03ffffff", "0x07ffffff", "0x0fffffff", "0x1fffffff",
      "0x3fffffff", "0x7fffffff", "0xffffffff", "0x0001", "0x0002", "0x0004", "0x0008", "0x0010",
      "0x0020", "0x0040", "0x0080", "0x0100", "0x0200", "0x0400", "0x0800", "0x1000", "0x2000",
      "0x4000", "0x8000", "0x0003", "0x0007", "0x000f", "0x001f", "0x003f", "0x007f", "0x00ff",
      "0x01ff", "0x03ff", "0x07ff", "0x0fff", "0x1fff", "0x3fff", "0x7fff", "0xffff", "0x01",
      "0x02", "0x04", "0x08", "0x10", "0x20", "0x40", "0x80", "0x03", "0x07", "0x0f", "0x1f",
      "0x3f", "0x7f", "0xff", "0x00", "100", "1000", "10000", "100000", "1000000", "10000000",
      "100000000", "1000000000"
    ]
}

private predicate trivialIntValue(string s) {
  trivialPositiveIntValue(s)
  or
  exists(string pos | trivialPositiveIntValue(pos) and s = "-" + pos)
}

private predicate intTrivial(IntegerLiteral lit) {
  // Remove all `_` from literal, if any (e.g. `1_000_000`)
  exists(string v | trivialIntValue(v) and v = lit.getLiteral().replaceAll("_", ""))
}

private predicate longTrivial(LongLiteral lit) {
  exists(string v |
    trivialIntValue(v) and
    // Remove all `_` from literal, if any (e.g. `1_000_000L`)
    v + ["l", "L"] = lit.getLiteral().replaceAll("_", "")
  )
}

private predicate powerOfTen(float f) {
  f = [10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000]
}

private predicate floatTrivial(Literal lit) {
  (lit instanceof FloatLiteral or lit instanceof DoubleLiteral) and
  exists(float f |
    f = lit.getValue().toFloat() and
    (f.abs() <= 20.0 or powerOfTen(f))
  )
}

private predicate stringTrivial(StringLiteral lit) { lit.getLiteral().length() < 8 }

private predicate small(Literal lit) { lit.getLiteral().length() <= 1 }

private predicate trivial(Literal lit) {
  lit instanceof CharacterLiteral or
  lit instanceof BooleanLiteral or
  lit instanceof NullLiteral or
  intTrivial(lit) or
  floatTrivial(lit) or
  stringTrivial(lit) or
  longTrivial(lit) or
  small(lit) or
  excludedLiteral(lit)
}

private predicate literalIsConstantInitializer(Literal literal, Field f) {
  exists(AssignExpr e, VarAccess access |
    access = e.getAChildExpr() and
    f = access.getVariable() and
    access.getIndex() = 0 and
    f.isFinal() and
    f.isStatic() and
    literal = e.getAChildExpr() and
    literal.getIndex() = 1
  ) and
  not trivial(literal)
}

private predicate nonTrivialValue(string value, Literal literal, string context) {
  value = literal.getValue() and
  not trivial(literal) and
  not literalIsConstantInitializer(literal, _) and
  not literal.getParent*() instanceof ArrayInit and
  not literal.getParent+() instanceof Annotation and
  exists(MethodCall ma | literal = ma.getAnArgument() and ma.getMethod().getName() = context)
}

private predicate valueOccurrenceCount(string value, int n, string context) {
  n = strictcount(Literal lit | nonTrivialValue(value, lit, context)) and
  n > 20
}

private predicate occurenceCount(Literal lit, string value, int n, string context) {
  valueOccurrenceCount(value, n, context) and
  value = lit.getValue() and
  nonTrivialValue(_, lit, context)
}

/*
 * Literals repeated frequently
 */

private predicate check(Literal lit, string value, int n, string context, CompilationUnit f) {
  // Check that the literal is nontrivial
  not trivial(lit) and
  // Check that it is repeated a number of times
  occurenceCount(lit, value, n, context) and
  n > 20 and
  f = lit.getCompilationUnit()
}

private predicate checkWithFileCount(
  string value, int overallCount, int fileCount, string context, CompilationUnit f
) {
  fileCount = strictcount(Literal lit | check(lit, value, overallCount, context, f))
}

private predicate firstOccurrence(Literal lit, string value, string context, int n) {
  exists(CompilationUnit f, int fileCount |
    checkWithFileCount(value, n, fileCount, context, f) and
    fileCount < 100 and
    check(lit, value, n, context, f) and
    not exists(Literal lit2, int start1, int start2 |
      check(lit2, value, n, context, f) and
      lit.getLocation().getStartLine() = start1 and
      lit2.getLocation().getStartLine() = start2 and
      start2 < start1
    )
  )
}

predicate isNumber(Literal lit) { lit.getType() instanceof NumericOrCharType }

predicate magicConstant(Literal e, string msg) {
  exists(string value, int n, string context |
    firstOccurrence(e, value, context, n) and
    msg =
      "Magic constant: literal '" + value + "' is used " + n.toString() + " times in calls to " +
        context
  )
}

/*
 * Literals where there is a defined constant with the same value
 */

private predicate relevantField(Field f, string value) {
  exists(Literal lit |
    not trivial(lit) and value = lit.getValue() and literalIsConstantInitializer(lit, f)
  )
}

private predicate relevantType(RefType t, string value, Package p) {
  exists(Literal lit | nonTrivialValue(value, lit, _) |
    lit.getEnclosingCallable().getDeclaringType() = t and p = t.getPackage()
  )
}

private predicate fieldUsedInContext(Field constField, string context) {
  literalIsConstantInitializer(_, constField) and
  exists(MethodCall ma |
    constField.getAnAccess() = ma.getAnArgument() and
    ma.getMethod().getName() = context
  )
}

private predicate candidateConstantForLiteral(
  Field constField, RefType literalType, Literal magicLiteral, string context
) {
  exists(Literal initLiteral |
    literalIsConstantInitializer(initLiteral, constField) and
    exists(string value |
      value = initLiteral.getValue() and
      nonTrivialValue(value, magicLiteral, context) and
      fieldUsedInContext(constField, context)
    ) and
    literalType = magicLiteral.getEnclosingCallable().getDeclaringType()
  )
}

private RefType inheritsProtected(Field f) {
  f.isProtected() and result.getASupertype() = f.getDeclaringType()
  or
  exists(RefType mid | mid = inheritsProtected(f) and result.getASupertype() = mid)
}

private predicate constantForLiteral(
  Field field, string value, RefType fromType, Literal magicLiteral, string context
) {
  //public fields in public classes
  candidateConstantForLiteral(field, fromType, magicLiteral, context) and
  relevantField(field, value) and
  field.getDeclaringType().isPublic() and
  field.isPublic() and
  relevantType(fromType, value, _)
  or
  //in same class
  candidateConstantForLiteral(field, fromType, magicLiteral, context) and
  relevantField(field, value) and
  fromType = field.getDeclaringType() and
  relevantType(fromType, value, _)
  or
  //in subclass and not private
  candidateConstantForLiteral(field, fromType, magicLiteral, context) and
  relevantField(field, value) and
  field.isProtected() and
  fromType = inheritsProtected(field) and
  relevantType(fromType, value, _)
  or
  //not private and in same package
  candidateConstantForLiteral(field, fromType, magicLiteral, context) and
  relevantField(field, value) and
  field.isPackageProtected() and
  exists(Package p |
    exists(CompilationUnit cu | cu = field.getCompilationUnit() and cu.getPackage() = p) and
    relevantType(fromType, value, p)
  )
}

private predicate canUseFieldInsteadOfLiteral(Field constField, Literal magicLiteral, string context) {
  constantForLiteral(constField, _, _, magicLiteral, context)
}

predicate literalInsteadOfConstant(
  Literal magicLiteral, string message, Field constField, string linkText
) {
  exists(string context |
    canUseFieldInsteadOfLiteral(constField, magicLiteral, context) and
    message =
      "Literal value '" + magicLiteral.getLiteral() + "' used " + " in a call to " + context +
        "; consider using the defined constant $@." and
    linkText = constField.getName() and
    (
      constField.getCompilationUnit() = magicLiteral.getCompilationUnit() or
      not almostPrivate(constField)
    ) and
    (
      constField.getCompilationUnit().getPackage() = magicLiteral.getCompilationUnit().getPackage() or
      not almostPackageProtected(constField)
    )
  )
}

private predicate almostPrivate(Field f) {
  not exists(VarAccess va |
    va.getVariable() = f and va.getCompilationUnit() != f.getCompilationUnit()
  )
  or
  exists(Interface i | i = f.getDeclaringType() |
    forall(VarAccess va | va.getVariable() = f |
      va.getEnclosingCallable().getDeclaringType().getAnAncestor() = i
    )
  )
}

private predicate almostPackageProtected(Field f) {
  not exists(VarAccess va | va.getVariable() = f |
    va.getCompilationUnit().getPackage() != f.getCompilationUnit().getPackage()
  )
}

/*
 * Removing literals from uninteresting contexts
 */

private predicate excludedLiteral(Literal lit) {
  // Remove test cases
  lit.getEnclosingCallable().getDeclaringType() instanceof TestClass
  or
  exists(MethodCall ma | lit = ma.getAnArgument() | ma.getMethod() instanceof TestMethod)
}

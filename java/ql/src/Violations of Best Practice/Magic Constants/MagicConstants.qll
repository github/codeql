import java

/*
 * Counting nontrivial literal occurrences
 */

private predicate trivialPositiveIntValue(string s) {
  s = "0" or
  s = "1" or
  s = "2" or
  s = "3" or
  s = "4" or
  s = "5" or
  s = "6" or
  s = "7" or
  s = "8" or
  s = "9" or
  s = "10" or
  s = "11" or
  s = "12" or
  s = "13" or
  s = "14" or
  s = "15" or
  s = "16" or
  s = "17" or
  s = "18" or
  s = "19" or
  s = "20" or
  s = "16" or
  s = "32" or
  s = "64" or
  s = "128" or
  s = "256" or
  s = "512" or
  s = "1024" or
  s = "2048" or
  s = "4096" or
  s = "16384" or
  s = "32768" or
  s = "65536" or
  s = "1048576" or
  s = "2147483648" or
  s = "4294967296" or
  s = "15" or
  s = "31" or
  s = "63" or
  s = "127" or
  s = "255" or
  s = "511" or
  s = "1023" or
  s = "2047" or
  s = "4095" or
  s = "16383" or
  s = "32767" or
  s = "65535" or
  s = "1048577" or
  s = "2147483647" or
  s = "4294967295" or
  s = "0x00000001" or
  s = "0x00000002" or
  s = "0x00000004" or
  s = "0x00000008" or
  s = "0x00000010" or
  s = "0x00000020" or
  s = "0x00000040" or
  s = "0x00000080" or
  s = "0x00000100" or
  s = "0x00000200" or
  s = "0x00000400" or
  s = "0x00000800" or
  s = "0x00001000" or
  s = "0x00002000" or
  s = "0x00004000" or
  s = "0x00008000" or
  s = "0x00010000" or
  s = "0x00020000" or
  s = "0x00040000" or
  s = "0x00080000" or
  s = "0x00100000" or
  s = "0x00200000" or
  s = "0x00400000" or
  s = "0x00800000" or
  s = "0x01000000" or
  s = "0x02000000" or
  s = "0x04000000" or
  s = "0x08000000" or
  s = "0x10000000" or
  s = "0x20000000" or
  s = "0x40000000" or
  s = "0x80000000" or
  s = "0x00000001" or
  s = "0x00000003" or
  s = "0x00000007" or
  s = "0x0000000f" or
  s = "0x0000001f" or
  s = "0x0000003f" or
  s = "0x0000007f" or
  s = "0x000000ff" or
  s = "0x000001ff" or
  s = "0x000003ff" or
  s = "0x000007ff" or
  s = "0x00000fff" or
  s = "0x00001fff" or
  s = "0x00003fff" or
  s = "0x00007fff" or
  s = "0x0000ffff" or
  s = "0x0001ffff" or
  s = "0x0003ffff" or
  s = "0x0007ffff" or
  s = "0x000fffff" or
  s = "0x001fffff" or
  s = "0x003fffff" or
  s = "0x007fffff" or
  s = "0x00ffffff" or
  s = "0x01ffffff" or
  s = "0x03ffffff" or
  s = "0x07ffffff" or
  s = "0x0fffffff" or
  s = "0x1fffffff" or
  s = "0x3fffffff" or
  s = "0x7fffffff" or
  s = "0xffffffff" or
  s = "0x0001" or
  s = "0x0002" or
  s = "0x0004" or
  s = "0x0008" or
  s = "0x0010" or
  s = "0x0020" or
  s = "0x0040" or
  s = "0x0080" or
  s = "0x0100" or
  s = "0x0200" or
  s = "0x0400" or
  s = "0x0800" or
  s = "0x1000" or
  s = "0x2000" or
  s = "0x4000" or
  s = "0x8000" or
  s = "0x0001" or
  s = "0x0003" or
  s = "0x0007" or
  s = "0x000f" or
  s = "0x001f" or
  s = "0x003f" or
  s = "0x007f" or
  s = "0x00ff" or
  s = "0x01ff" or
  s = "0x03ff" or
  s = "0x07ff" or
  s = "0x0fff" or
  s = "0x1fff" or
  s = "0x3fff" or
  s = "0x7fff" or
  s = "0xffff" or
  s = "0x01" or
  s = "0x02" or
  s = "0x04" or
  s = "0x08" or
  s = "0x10" or
  s = "0x20" or
  s = "0x40" or
  s = "0x80" or
  s = "0x01" or
  s = "0x03" or
  s = "0x07" or
  s = "0x0f" or
  s = "0x1f" or
  s = "0x3f" or
  s = "0x7f" or
  s = "0xff" or
  s = "0x00" or
  s = "10" or
  s = "100" or
  s = "1000" or
  s = "10000" or
  s = "100000" or
  s = "1000000" or
  s = "10000000" or
  s = "100000000" or
  s = "1000000000"
}

private predicate trivialIntValue(string s) {
  trivialPositiveIntValue(s)
  or
  exists(string pos | trivialPositiveIntValue(pos) and s = "-" + pos)
}

private predicate intTrivial(Literal lit) {
  exists(string v | trivialIntValue(v) and v = lit.getLiteral())
}

private predicate longTrivial(Literal lit) {
  exists(string v | trivialIntValue(v) and v + "L" = lit.getLiteral())
}

private predicate powerOfTen(float f) {
  f = 10 or
  f = 100 or
  f = 1000 or
  f = 10000 or
  f = 100000 or
  f = 1000000 or
  f = 10000000 or
  f = 100000000 or
  f = 1000000000
}

private predicate floatTrivial(Literal lit) {
  (lit instanceof FloatingPointLiteral or lit instanceof DoubleLiteral) and
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
  value = literal.getLiteral() and
  not trivial(literal) and
  not literalIsConstantInitializer(literal, _) and
  not literal.getParent*() instanceof ArrayInit and
  not literal.getParent+() instanceof Annotation and
  exists(MethodAccess ma | literal = ma.getAnArgument() and ma.getMethod().getName() = context)
}

private predicate valueOccurrenceCount(string value, int n, string context) {
  n = strictcount(Literal lit | nonTrivialValue(value, lit, context)) and
  n > 20
}

private predicate occurenceCount(Literal lit, string value, int n, string context) {
  valueOccurrenceCount(value, n, context) and
  value = lit.getLiteral() and
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

predicate isNumber(Literal lit) {
  lit.getType().getName() = "char" or
  lit.getType().getName() = "short" or
  lit.getType().getName() = "int" or
  lit.getType().getName() = "long" or
  lit.getType().getName() = "float" or
  lit.getType().getName() = "double"
}

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
    not trivial(lit) and value = lit.getLiteral() and literalIsConstantInitializer(lit, f)
  )
}

private predicate relevantType(RefType t, string value, Package p) {
  exists(Literal lit | nonTrivialValue(value, lit, _) |
    lit.getEnclosingCallable().getDeclaringType() = t and p = t.getPackage()
  )
}

private predicate fieldUsedInContext(Field constField, string context) {
  literalIsConstantInitializer(_, constField) and
  exists(MethodAccess ma |
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
      value = initLiteral.getLiteral() and
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
      va.getEnclosingCallable().getDeclaringType().getASupertype*() = i
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
  exists(MethodAccess ma | lit = ma.getAnArgument() | ma.getMethod() instanceof TestMethod)
}

import csharp
import semmle.code.csharp.commons.GeneratedCode
import semmle.code.csharp.frameworks.System

/*
 * Counting nontrivial literal occurrences
 */

private predicate trivialPositiveIntValue(string s) {
  s =
    [
      "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16",
      "17", "18", "19", "20", "16", "32", "64", "128", "256", "512", "1024", "2048", "4096",
      "16384", "32768", "65536", "1048576", "2147483648", "4294967296", "15", "31", "63", "127",
      "255", "511", "1023", "2047", "4095", "16383", "32767", "65535", "1048577", "2147483647",
      "4294967295", "0x00000001", "0x00000002", "0x00000004", "0x00000008", "0x00000010",
      "0x00000020", "0x00000040", "0x00000080", "0x00000100", "0x00000200", "0x00000400",
      "0x00000800", "0x00001000", "0x00002000", "0x00004000", "0x00008000", "0x00010000",
      "0x00020000", "0x00040000", "0x00080000", "0x00100000", "0x00200000", "0x00400000",
      "0x00800000", "0x01000000", "0x02000000", "0x04000000", "0x08000000", "0x10000000",
      "0x20000000", "0x40000000", "0x80000000", "0x00000001", "0x00000003", "0x00000007",
      "0x0000000f", "0x0000001f", "0x0000003f", "0x0000007f", "0x000000ff", "0x000001ff",
      "0x000003ff", "0x000007ff", "0x00000fff", "0x00001fff", "0x00003fff", "0x00007fff",
      "0x0000ffff", "0x0001ffff", "0x0003ffff", "0x0007ffff", "0x000fffff", "0x001fffff",
      "0x003fffff", "0x007fffff", "0x00ffffff", "0x01ffffff", "0x03ffffff", "0x07ffffff",
      "0x0fffffff", "0x1fffffff", "0x3fffffff", "0x7fffffff", "0xffffffff", "0x0001", "0x0002",
      "0x0004", "0x0008", "0x0010", "0x0020", "0x0040", "0x0080", "0x0100", "0x0200", "0x0400",
      "0x0800", "0x1000", "0x2000", "0x4000", "0x8000", "0x0001", "0x0003", "0x0007", "0x000f",
      "0x001f", "0x003f", "0x007f", "0x00ff", "0x01ff", "0x03ff", "0x07ff", "0x0fff", "0x1fff",
      "0x3fff", "0x7fff", "0xffff", "0x01", "0x02", "0x04", "0x08", "0x10", "0x20", "0x40", "0x80",
      "0x01", "0x03", "0x07", "0x0f", "0x1f", "0x3f", "0x7f", "0xff", "0x00", "10", "100", "1000",
      "10000", "100000", "1000000", "10000000", "100000000", "1000000000"
    ]
}

private predicate trivialIntValue(string s) {
  trivialPositiveIntValue(s)
  or
  exists(string pos | trivialPositiveIntValue(pos) and s = "-" + pos)
}

private predicate intTrivial(Literal lit) {
  exists(string v | trivialIntValue(v) and v = lit.getValue())
}

private predicate powerOfTen(float f) {
  f = [10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000]
}

private predicate floatTrivial(Literal lit) {
  isFloat(lit) and
  exists(string value, float f |
    lit.getValue() = value and
    f = value.toFloat() and
    (f.abs() <= 20.0 or powerOfTen(f))
  )
}

private predicate stringTrivial(StringLiteral lit) { lit.getValue().length() < 8 }

private predicate small(Literal lit) { lit.getValue().length() <= 1 }

private predicate trivial(Literal lit) {
  intTrivial(lit) or
  floatTrivial(lit) or
  stringTrivial(lit) or
  small(lit) or
  lit instanceof NullLiteral or
  lit instanceof BoolLiteral or
  lit instanceof CharLiteral
}

private predicate literalIsConstantInitializer(Literal literal, string value, Field f) {
  literal.getValue() = value and
  literal = f.getInitializer().stripCasts() and
  (
    f.isReadOnly() and f.isStatic()
    or
    f instanceof MemberConstant
  )
}

private predicate literalInArrayInitializer(Literal literal) {
  exists(ArrayInitializer arrayInit | arrayInit.getAnElement().stripCasts() = literal)
}

private predicate literalInAttribute(Literal literal) { literal.getParent+() instanceof Attribute }

private predicate literalInGetHashCode(Literal literal) {
  exists(Method m, Method getHashCode |
    m = literal.getEnclosingCallable() and
    getHashCode = any(SystemObjectClass c).getGetHashCodeMethod()
  |
    m = getHashCode.getAnOverrider*()
  )
}

private predicate relevantLiteral(Literal literal, string value) {
  exists(SourceFile f | f = literal.getLocation().getFile() and not isGeneratedCode(f)) and
  value = literal.getValue() and
  not trivial(literal) and
  not literalIsConstantInitializer(literal, value, _) and
  not literalInArrayInitializer(literal) and
  not literalInAttribute(literal) and
  not literalInGetHashCode(literal)
}

private predicate valueOccurrenceCount(string value, int n) {
  n =
    strictcount(Location loc |
      exists(Literal lit | relevantLiteral(lit, value) | lit.getLocation() = loc)
    ) and
  n > 20
}

private predicate occurenceCount(Literal lit, string value, int n) {
  valueOccurrenceCount(value, n) and
  value = lit.getValue() and
  relevantLiteral(lit, value)
}

/*
 * Literals repeated frequently
 */

private predicate check(Literal lit, string value, int n, File f) {
  // Check that the literal is nontrivial
  not trivial(lit) and
  // Check that it is repeated a number of times
  occurenceCount(lit, value, n) and
  n > 20 and
  f = lit.getFile()
}

private predicate checkWithFileCount(string value, int overallCount, int fileCount, File f) {
  fileCount =
    strictcount(Location loc |
      exists(Literal lit | check(lit, value, overallCount, f) | lit.getLocation() = loc)
    )
}

private predicate start(Literal lit, int startLine) {
  exists(Location l | l = lit.getLocation() and l.hasLocationInfo(_, startLine, _, _, _))
}

private predicate firstOccurrence(Literal lit, string value, int n) {
  exists(File f, int fileCount |
    checkWithFileCount(value, n, fileCount, f) and
    fileCount < 100 and
    check(lit, value, n, f) and
    not exists(Literal lit2, int start1, int start2 |
      check(lit2, value, n, f) and
      start(lit, start1) and
      start(lit2, start2) and
      start2 < start1
    )
  )
}

private predicate isFloat(Literal lit) { lit.getType() instanceof FloatingPointType }

predicate isNumber(Literal lit) {
  lit.getType() instanceof IntegralType or
  isFloat(lit)
}

predicate magicConstant(Literal e, string msg) {
  exists(string value, int n |
    firstOccurrence(e, value, n) and
    msg =
      "Magic constant: literal '" + value + "' is repeated " + n.toString() +
        " times and should be encapsulated in a constant."
  )
}

/*
 * Literals where there is a defined constant with the same value
 */

private predicate relevantField(Field f, string value) {
  exists(Literal lit |
    not trivial(lit) and value = lit.getValue() and literalIsConstantInitializer(lit, value, f)
  )
}

private predicate relevantDeclaration(Declaration d, Literal lit, string value) {
  not trivial(lit) and
  value = lit.getValue() and
  (lit.getEnclosingCallable() = d or d.(Field).getInitializer().getAChildExpr*() = lit)
}

private predicate hasAccessModifier(Field field) {
  field.isPublic() or
  field.isProtected() or
  field.isPrivate() or
  field.isInternal()
}

//Default accessibility rules http://msdn.microsoft.com/en-us/library/ba0a1yw2%28v=vs.71%29.aspx
private predicate isPublic(Field field) {
  field.isPublic()
  or
  not hasAccessModifier(field) and
  (field.getDeclaringType() instanceof Interface or field.getDeclaringType() instanceof Enum)
}

private predicate isPrivate(Field field) {
  field.isPrivate()
  or
  not hasAccessModifier(field) and
  (field.getDeclaringType() instanceof Class or field.getDeclaringType() instanceof Struct)
}

private predicate isVisible(Field field, string value, Declaration fromDeclaration) {
  //public
  relevantField(field, value) and
  field.getDeclaringType().isPublic() and
  isPublic(field) and
  relevantDeclaration(fromDeclaration, _, value)
  or
  //in same class
  relevantField(field, value) and
  exists(RefType t |
    t = field.getDeclaringType() and
    t = fromDeclaration.getDeclaringType()
  ) and
  relevantDeclaration(fromDeclaration, _, value)
  or
  //in subclass and not private
  relevantField(field, value) and
  not isPrivate(field) and
  exists(RefType sup, RefType sub |
    sup = field.getDeclaringType() and
    sub.getABaseType+() = sup and
    sub = fromDeclaration.getDeclaringType()
  ) and
  relevantDeclaration(fromDeclaration, _, value)
  //internal and in same assembly
  //TODO: internal (I don't think we can do this yet, as we don't associate elements in source to assemblies)
}

/**
 * Literal.getValue() restricted to literals which aren't used as constant initialisers.
 */
private string magicLiteralValue(Literal l) { relevantLiteral(l, result) }

private predicate canUseFieldInsteadOfLiteral(Field constField, Literal magicLiteral, string value) {
  exists(Literal initLiteral |
    literalIsConstantInitializer(initLiteral, value, constField) and
    value = initLiteral.getValue() and
    value = magicLiteralValue(magicLiteral) and
    exists(Declaration d |
      relevantDeclaration(d, magicLiteral, value) and
      isVisible(constField, value, d)
    )
  )
}

predicate literalInsteadOfConstant(
  Literal magicLiteral, string value, string message, Field constField
) {
  canUseFieldInsteadOfLiteral(constField, magicLiteral, value) and
  message = "Literal value '" + value + "' used instead of constant $@."
}

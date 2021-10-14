import csharp
import semmle.code.csharp.commons.GeneratedCode
import semmle.code.csharp.frameworks.System

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
  exists(string v | trivialIntValue(v) and v = lit.getValue())
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

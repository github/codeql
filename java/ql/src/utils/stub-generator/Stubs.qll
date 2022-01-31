/**
 * Generates java stubs for use in test code.
 *
 * Extend the abstract class `GeneratedDeclaration` with the declarations that should be generated.
 * This will generate stubs for all the required dependencies as well.
 */

import java

/** A type that should be in the generated code. */
abstract private class GeneratedType extends ClassOrInterface {
  GeneratedType() {
    not this instanceof AnonymousClass and
    not this.isLocal() and
    not this.getPackage() instanceof ExcludedPackage
  }

  private string stubKeyword() {
    this instanceof Interface and result = "interface"
    or
    this instanceof Class and
    (if this instanceof EnumType then result = "enum" else result = "class")
  }

  private string stubAbstractModifier() {
    if this.(Class).isAbstract() then result = "abstract " else result = ""
  }

  private string stubStaticModifier() {
    if this.isStatic() then result = "static " else result = ""
  }

  private string stubAccessibilityModifier() {
    if this.isPublic() then result = "public " else result = ""
  }

  /** Gets the entire Java stub code for this type. */
  final string getStub() {
    result =
      this.stubAbstractModifier() + this.stubStaticModifier() + this.stubAccessibilityModifier() +
        this.stubKeyword() + " " + this.getName() + stubGenericArguments(this, true) +
        this.stubBaseTypesString() + "\n{\n" + this.stubMembers() + "}"
  }

  private RefType getAnInterestingBaseType() {
    result = this.getASupertype() and
    not result instanceof TypeObject and
    not this instanceof EnumType and
    // generic types have their source declaration (the corresponding raw type) as a supertype of themselves
    result.getSourceDeclaration() != this
  }

  private string stubBaseTypesString() {
    if exists(this.getAnInterestingBaseType())
    then
      exists(string cls, string interface, string int_kw | result = cls + int_kw + interface |
        (
          if exists(this.getAnInterestingBaseType().(Class))
          then cls = " extends " + stubTypeName(this.getAnInterestingBaseType().(Class))
          else cls = ""
        ) and
        (
          if exists(this.getAnInterestingBaseType().(Interface))
          then (
            (if this instanceof Class then int_kw = " implements " else int_kw = " extends ") and
            interface = concat(stubTypeName(this.getAnInterestingBaseType().(Interface)), ", ")
          ) else (
            int_kw = "" and interface = ""
          )
        )
      )
    else result = ""
  }

  language[monotonicAggregates]
  private string stubMembers() {
    result =
      stubEnumConstants(this) + stubFakeConstructor(this) +
        concat(Member m | m = this.getAGeneratedMember() | stubMember(m))
  }

  private Member getAGeneratedMember() {
    (
      not result instanceof NestedType and
      result.getDeclaringType() = this
      or
      exists(NestedType nt | result = nt |
        nt = nt.getSourceDeclaration() and
        nt.getEnclosingType().getSourceDeclaration() = this
      )
    ) and
    not result.isPrivate() and
    not result.isPackageProtected() and
    not result instanceof StaticInitializer and
    not result instanceof InstanceInitializer
  }

  final Type getAGeneratedType() {
    result = this.getAnInterestingBaseType()
    or
    result = this.getAGeneratedMember().(Callable).getReturnType()
    or
    result = this.getAGeneratedMember().(Callable).getAParameter().getType()
    or
    result = this.getAGeneratedMember().(Field).getType()
    or
    result = this.getAGeneratedMember().(NestedType)
  }
}

/**
 * A declaration that should be generated.
 * This is extended in client code to identify the actual
 * declarations that should be generated.
 */
abstract class GeneratedDeclaration extends Element { }

private class IndirectType extends GeneratedType {
  IndirectType() {
    this.getASubtype() instanceof GeneratedType
    or
    this.(GenericType).getAParameterizedType() instanceof GeneratedType
    or
    exists(GeneratedType t |
      this = getAContainedType(t.getAGeneratedType()).(RefType).getSourceDeclaration()
    )
    or
    this.getSourceDeclaration() instanceof GeneratedType
    or
    this = any(GeneratedType t).getSourceDeclaration()
    or
    exists(GeneratedDeclaration decl |
      decl.(Member).getDeclaringType().getSourceDeclaration() = this
    )
    or
    this.(NestedType).getEnclosingType() instanceof GeneratedType
    or
    exists(NestedType nt | nt instanceof GeneratedType and this = nt.getEnclosingType())
  }
}

private class RootGeneratedType extends GeneratedType {
  RootGeneratedType() { this = any(GeneratedDeclaration decl).(RefType).getSourceDeclaration() }
}

private Type getAContainedType(Type t) {
  result = t
  or
  result = getAContainedType(t.(ParameterizedType).getATypeArgument())
  or
  result = getAContainedType(t.(Array).getElementType())
  or
  result = getAContainedType(t.(BoundedType).getATypeBound().getType())
}

/**
 * Specify packages to exclude.
 * Do not generate any types from these packages.
 */
abstract class ExcludedPackage extends Package { }

/** Exclude types from the standard library. */
private class DefaultLibs extends ExcludedPackage {
  DefaultLibs() { this.getName().matches(["java.%", "jdk.%", "sun.%"]) }
}

private string stubAccessibility(Member m) {
  if m.getDeclaringType() instanceof Interface
  then result = ""
  else
    if m.isPublic()
    then result = "public "
    else
      if m.isProtected()
      then result = "protected "
      else
        if m.isPrivate()
        then result = "private "
        else
          if m.isPackageProtected()
          then result = ""
          else result = "unknown-accessibility"
}

private string stubModifiers(Member m) {
  result = stubAccessibility(m) + stubStaticOrFinal(m) + stubAbstractOrDefault(m)
}

private string stubStaticOrFinal(Member m) {
  if m.(Modifiable).isStatic()
  then result = "static "
  else
    if m.(Modifiable).isFinal()
    then result = "final "
    else result = ""
}

private string stubAbstractOrDefault(Member m) {
  if m.getDeclaringType() instanceof Interface
  then if m.isDefault() then result = "default " else result = ""
  else
    if m.isAbstract()
    then result = "abstract "
    else result = ""
}

private string stubTypeName(Type t) {
  if t instanceof PrimitiveType
  then result = t.getName()
  else
    if t instanceof VoidType
    then result = "void"
    else
      if t instanceof TypeVariable
      then result = t.getName()
      else
        if t instanceof Wildcard
        then result = "?" + stubTypeBound(t)
        else
          if t instanceof Array
          then result = stubTypeName(t.(Array).getComponentType()) + "[]"
          else
            if t instanceof ClassOrInterface
            then
              result =
                stubQualifier(t) + t.(RefType).getSourceDeclaration().getName() +
                  stubGenericArguments(t, false)
            else result = "<error>"
}

language[monotonicAggregates]
private string stubTypeBound(BoundedType t) {
  if not exists(t.getATypeBound())
  then result = ""
  else
    exists(string kw, string bounds | result = kw + bounds |
      (if t.(Wildcard).hasLowerBound() then kw = " super " else kw = " extends ") and
      bounds =
        concat(TypeBound b |
          b = t.getATypeBound()
        |
          stubTypeName(b.getType()), " & " order by b.getPosition()
        )
    )
}

private string maybeStubTypeBound(BoundedType t, boolean typeVarBounds) {
  typeVarBounds = true and
  result = stubTypeBound(t)
  or
  typeVarBounds = false and
  result = ""
}

private string stubQualifier(RefType t) {
  if t instanceof NestedType
  then
    exists(RefType et | et = t.(NestedType).getEnclosingType().getSourceDeclaration() |
      result = stubQualifier(et) + et.getName() + "."
    )
  else result = ""
}

language[monotonicAggregates]
private string stubGenericArguments(RefType t, boolean typeVarBounds) {
  typeVarBounds = [true, false] and
  if t instanceof GenericType
  then
    result =
      "<" +
        concat(int n, TypeVariable tv |
          tv = t.(GenericType).getTypeParameter(n)
        |
          tv.getName() + maybeStubTypeBound(tv, typeVarBounds), ", " order by n
        ) + ">"
  else
    if t instanceof ParameterizedType
    then
      result =
        "<" +
          concat(int n, Type tpar |
            tpar = t.(ParameterizedType).getTypeArgument(n)
          |
            stubTypeName(tpar), ", " order by n
          ) + ">"
    else result = ""
}

private string stubGenericCallableParams(Callable m) {
  if m instanceof GenericCallable
  then
    result =
      "<" +
        concat(int n, TypeVariable param |
          param = m.(GenericCallable).getTypeParameter(n)
        |
          param.getName() + stubTypeBound(param), ", " order by n
        ) + "> "
  else result = ""
}

private string stubImplementation(Callable c) {
  if c.isAbstract()
  then result = ";"
  else
    if c instanceof Constructor or c.getReturnType() instanceof VoidType
    then result = "{}"
    else result = "{ return " + stubDefaultValue(c.getReturnType()) + "; }"
}

private string stubDefaultValue(Type t) {
  if t instanceof RefType
  then result = "null"
  else
    if t instanceof CharacterType
    then result = "'0'"
    else
      if t instanceof BooleanType
      then result = "false"
      else
        if t instanceof NumericType
        then result = "0"
        else result = "<error>"
}

private string stubParameters(Callable c) {
  result =
    concat(int i, Parameter param |
      param = c.getParameter(i)
    |
      stubParameter(param), ", " order by i
    )
}

private string stubParameter(Parameter p) {
  exists(Type t, string suff | result = stubTypeName(t) + suff + " " + p.getName() |
    if p.isVarargs()
    then (
      t = p.getType().(Array).getComponentType() and
      suff = "..."
    ) else (
      t = p.getType() and suff = ""
    )
  )
}

private string stubEnumConstants(RefType t) {
  if t instanceof EnumType
  then
    exists(EnumType et | et = t |
      result =
        "    " + concat(EnumConstant c | c = et.getAnEnumConstant() | c.getName(), ", ") + ";\n"
    )
  else result = ""
}

// Holds if the member is to be excluded from stubMember
private predicate excludedMember(Member m) {
  m instanceof EnumConstant
  or
  m.(Method).getDeclaringType() instanceof EnumType and
  m.hasName(["values", "valueOf"]) and
  m.isStatic()
  or
  exists(Parameter p |
    p = m.(Method).getAParameter() and
    p.getType().fromSource() and
    not p.getType().(RefType).isPublic()
  )
}

private string stubMember(Member m) {
  if excludedMember(m)
  then result = ""
  else (
    result =
      "    " + stubModifiers(m) + stubGenericCallableParams(m) +
        stubTypeName(m.(Method).getReturnType()) + " " + m.getName() + "(" + stubParameters(m) + ")"
        + stubImplementation(m) + "\n"
    or
    m instanceof Constructor and
    result =
      "    " + stubModifiers(m) + stubGenericCallableParams(m) + m.getName() + "(" +
        stubParameters(m) + ")" + stubImplementation(m) + "\n"
    or
    result =
      "    " + stubModifiers(m) + stubTypeName(m.(Field).getType()) + " " + m.getName() + " = " +
        stubDefaultValue(m.(Field).getType()) + ";\n"
    or
    result = indent(m.(NestedType).(GeneratedType).getStub())
  )
}

bindingset[s]
private string indent(string s) { result = "    " + s.replaceAll("\n", "\n    ") + "\n" }

// If a class's superclass doesn't have a no-arg constructor, then it won't compile when its constructor's bodies are stubbed
// So we synthesise no-arg constructors for each generated type that doesn't have one.
private string stubFakeConstructor(RefType t) {
  if not t instanceof Class
  then result = ""
  else
    exists(string mod |
      // this won't conflict with any existing private constructors, since we don't generate stubs for any private members.
      if t instanceof EnumType then mod = "    private " else mod = "    protected "
    |
      if hasNoArgConstructor(t) then result = "" else result = mod + t.getName() + "() {}\n"
    )
}

private predicate hasNoArgConstructor(Class t) {
  exists(Constructor c | c.getDeclaringType() = t |
    c.getNumberOfParameters() = 0 and
    not c.isPrivate()
  )
}

private RefType getAReferencedType(RefType t) {
  result = t.(GeneratedType).getAGeneratedType()
  or
  result =
    getAReferencedType(any(NestedType nt |
        nt.getEnclosingType().getSourceDeclaration() = t.getSourceDeclaration()
      ))
  or
  exists(RefType t1 | t1 = getAReferencedType(t) |
    result = t1.(NestedType).getEnclosingType()
    or
    result = t1.getSourceDeclaration()
    or
    result = t1.(ParameterizedType).getATypeArgument()
    or
    result = t1.(Array).getComponentType()
    or
    result = t1.(BoundedType).getATypeBound().getType()
  )
}

/** A top level type whose file should be stubbed */
class GeneratedTopLevel extends TopLevelType {
  GeneratedTopLevel() {
    this = this.getSourceDeclaration() and
    this instanceof GeneratedType
  }

  private TopLevelType getAnImportedType() {
    result = getAReferencedType(this).getSourceDeclaration()
  }

  private string stubAnImport() {
    exists(RefType t, string pkg, string name |
      t = this.getAnImportedType() and
      (t instanceof Class or t instanceof Interface) and
      t.hasQualifiedName(pkg, name) and
      t != this and
      pkg != "java.lang"
    |
      result = "import " + pkg + "." + name + ";\n"
    )
  }

  private string stubImports() { result = concat(this.stubAnImport()) + "\n" }

  private string stubPackage() {
    if this.getPackage().getName() != ""
    then result = "package " + this.getPackage().getName() + ";\n\n"
    else result = ""
  }

  private string stubComment() {
    result =
      "// Generated automatically from " + this.getQualifiedName() + " for testing purposes\n\n"
  }

  /** Creates a full stub for the file containing this type. */
  string stubFile() {
    result =
      this.stubComment() + this.stubPackage() + this.stubImports() + this.(GeneratedType).getStub() +
        "\n"
  }
}

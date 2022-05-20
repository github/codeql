/**
 * Generates C# stubs for use in test code.
 *
 * Extend the abstract class `GeneratedDeclaration` with the declarations that should be generated.
 * This will generate stubs for all the required dependencies as well.
 *
 * Use
 * ```ql
 * select generatedCode()
 * ```
 * to retrieve the generated C# code.
 */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.dotnet.DotNet as DotNet // added to handle VoidType as a ValueOrRefType

/** An element that should be in the generated code. */
abstract class GeneratedElement extends Element { }

/** A member that should be in the generated code. */
abstract class GeneratedMember extends Member, GeneratedElement { }

/** Class representing all `struct`s, such as user defined ones and built-in ones, like `int`. */
private class StructExt extends Type {
  StructExt() {
    this instanceof Struct or
    this instanceof SimpleType or
    this instanceof VoidType or
    this instanceof SystemIntPtrType
  }
}

/** A type that should be in the generated code. */
abstract private class GeneratedType extends Type, GeneratedElement {
  GeneratedType() {
    (
      this instanceof Interface
      or
      this instanceof Class
      or
      this instanceof StructExt
      or
      this instanceof Enum
      or
      this instanceof DelegateType
    ) and
    not this instanceof ConstructedType and
    not this.getALocation() instanceof ExcludedAssembly
  }

  /**
   * Holds if this type is defined in multiple assemblies, and at least one of
   * them is in the `Microsoft.NETCore.App.Ref` folder. In this case, we only stub
   * the type in the assembly in `Microsoft.NETCore.App.Ref`. In case there are
   * multiple assemblies in this folder, then we prefer `System.Runtime`.
   */
  private predicate isDuplicate(Assembly assembly) {
    // type exists in multiple assemblies
    count(this.getALocation().(Assembly)) > 1 and
    // at least one of them is in the `Microsoft.NETCore.App.Ref` folder
    this.getALocation()
        .(Assembly)
        .getFile()
        .getAbsolutePath()
        .matches("%Microsoft.NETCore.App.Ref%") and
    exists(int i |
      i =
        count(Assembly a |
          this.getALocation() = a and
          a.getFile().getAbsolutePath().matches("%Microsoft.NETCore.App.Ref%")
        )
    |
      i = 1 and
      // assemblies not in `Microsoft.NETCore.App.Ref` folder are considered duplicates
      not assembly.getFile().getAbsolutePath().matches("%Microsoft.NETCore.App.Ref%")
      or
      i > 1 and
      // one of the assemblies is named `System.Runtime`
      this.getALocation().(Assembly).getName() = "System.Runtime" and
      // all others are considered duplicates
      assembly.getName() != "System.Runtime"
    )
  }

  predicate isInAssembly(Assembly assembly) { this.getALocation() = assembly }

  private string stubKeyword() {
    this instanceof Interface and result = "interface"
    or
    this instanceof StructExt and result = "struct"
    or
    this instanceof Class and result = "class"
    or
    this instanceof Enum and result = "enum"
    or
    this instanceof DelegateType and result = "delegate"
  }

  private string stubAbstractModifier() {
    if this.(Class).isAbstract() then result = "abstract " else result = ""
  }

  private string stubStaticModifier() {
    if this.isStatic() then result = "static " else result = ""
  }

  private string stubPartialModifier() {
    if
      count(Assembly a | this.getALocation() = a) <= 1 or
      this instanceof Enum
    then result = ""
    else result = "partial "
  }

  private string stubAttributes() {
    if this.(ValueOrRefType).getAnAttribute().getType().getQualifiedName() = "System.FlagsAttribute"
    then result = "[System.Flags]\n"
    else result = ""
  }

  private string stubComment() {
    result =
      "// Generated from `" + this.getQualifiedName() + "` in `" +
        concat(this.getALocation().toString(), "; ") + "`\n"
  }

  /** Gets the entire C# stub code for this type. */
  pragma[nomagic]
  final string getStub(Assembly assembly) {
    this.isInAssembly(assembly) and
    if this.isDuplicate(assembly)
    then
      result =
        "/* Duplicate type '" + this.getName() + "' is not stubbed in this assembly '" +
          assembly.toString() + "'. */\n\n"
    else (
      not this instanceof DelegateType and
      result =
        this.stubComment() + this.stubAttributes() + stubAccessibility(this) +
          this.stubAbstractModifier() + this.stubStaticModifier() + this.stubPartialModifier() +
          this.stubKeyword() + " " + this.getUndecoratedName() + stubGenericArguments(this) +
          this.stubBaseTypesString() + stubTypeParametersConstraints(this) + "\n{\n" +
          this.stubPrivateConstructor() + this.stubMembers(assembly) + "}\n\n"
      or
      result =
        this.stubComment() + this.stubAttributes() + stubUnsafe(this) + stubAccessibility(this) +
          this.stubKeyword() + " " + stubClassName(this.(DelegateType).getReturnType()) + " " +
          this.getUndecoratedName() + stubGenericArguments(this) + "(" + stubParameters(this) +
          ");\n\n"
    )
  }

  private ValueOrRefType getAnInterestingBaseType() {
    result = this.(ValueOrRefType).getABaseType() and
    not result instanceof ObjectType and
    not result.getQualifiedName() = "System.ValueType" and
    (not result instanceof Interface or result.(Interface).isEffectivelyPublic())
  }

  private string stubBaseTypesString() {
    if this instanceof Enum
    then result = ""
    else
      if exists(this.getAnInterestingBaseType())
      then
        result =
          " : " +
            concat(int i, ValueOrRefType t |
              t = this.getAnInterestingBaseType() and
              (if t instanceof Class then i = 0 else i = 1)
            |
              stubClassName(t), ", " order by i, t.getQualifiedName()
            )
      else result = ""
  }

  language[monotonicAggregates]
  private string stubMembers(Assembly assembly) {
    result =
      concat(GeneratedMember m |
        m = this.getAGeneratedMember(assembly)
      |
        stubMember(m, assembly)
        order by
          m.getQualifiedNameWithTypes(), stubExplicitImplementation(m)
      )
  }

  string stubPrivateConstructor() {
    if
      this instanceof Interface
      or
      this.isStatic()
      or
      this.isAbstract()
      or
      exists(this.(ValueOrRefType).getAConstructor())
      or
      not exists(this.getAnInterestingBaseType())
      or
      not exists(this.getAnInterestingBaseType().getAConstructor())
      or
      exists(Constructor bc |
        bc = this.getAnInterestingBaseType().getAConstructor() and
        bc.getNumberOfParameters() = 0 and
        not bc.isStatic()
      )
    then result = ""
    else
      result =
        "    private " + this.getUndecoratedName() + "() : base(" +
          stubDefaultArguments(getBaseConstructor(this), this) + ")" + " => throw null;\n"
  }

  private GeneratedMember getAGeneratedMember() { result.getDeclaringType() = this }

  pragma[noinline]
  private GeneratedMember getAGeneratedMember(Assembly assembly) {
    result = this.getAGeneratedMember() and assembly = result.getALocation()
  }

  final Type getAGeneratedType() {
    result = this.getAnInterestingBaseType()
    or
    result = this.getAGeneratedMember().(Callable).getReturnType()
    or
    result = this.getAGeneratedMember().(Callable).getAParameter().getType()
    or
    result = this.getAGeneratedMember().(Property).getType()
    or
    result = this.getAGeneratedMember().(Field).getType()
  }
}

/**
 * A declaration that should be generated.
 * This is extended in client code to identify the actual
 * declarations that should be generated.
 */
abstract class GeneratedDeclaration extends Modifiable {
  GeneratedDeclaration() { this.isEffectivelyPublic() }
}

private class IndirectType extends GeneratedType {
  IndirectType() {
    this.(ValueOrRefType).getASubType() instanceof GeneratedType
    or
    this.(ValueOrRefType).getAChildType() instanceof GeneratedType
    or
    this.(UnboundGenericType).getAConstructedGeneric().getASubType() instanceof GeneratedType
    or
    exists(GeneratedType t |
      this = getAContainedType(t.getAGeneratedType()).getUnboundDeclaration()
    )
    or
    exists(GeneratedDeclaration decl |
      decl.(Member).getDeclaringType().getUnboundDeclaration() = this
    )
  }
}

private class RootGeneratedType extends GeneratedType {
  RootGeneratedType() { this = any(GeneratedDeclaration decl).getUnboundDeclaration() }
}

private Type getAContainedType(Type t) {
  result = t
  or
  result = getAContainedType(t.(ConstructedType).getATypeArgument())
}

private class RootGeneratedMember extends GeneratedMember {
  RootGeneratedMember() { this = any(GeneratedDeclaration d).getUnboundDeclaration() }
}

private predicate declarationExists(Virtualizable m) {
  m instanceof GeneratedMember
  or
  m.getLocation() instanceof ExcludedAssembly
}

private class InheritedMember extends GeneratedMember, Virtualizable {
  InheritedMember() {
    declarationExists(this.getImplementee+())
    or
    declarationExists(this.getAnImplementor+())
    or
    declarationExists(this.getOverridee+())
    or
    declarationExists(this.getAnOverrider+())
  }
}

private class ExtraGeneratedConstructor extends GeneratedMember, Constructor {
  ExtraGeneratedConstructor() {
    not this.isStatic() and
    not this.isEffectivelyPublic() and
    this.getDeclaringType() instanceof GeneratedType and
    (
      // if the base class has no 0 parameter constructor
      not exists(Constructor c |
        c = this.getDeclaringType().getBaseClass().getAMember() and
        c.getNumberOfParameters() = 0 and
        not c.isStatic()
      )
      or
      // if this constructor might be called from a (generic) derived class
      exists(Class c |
        this.getDeclaringType() = c.getBaseClass().getUnboundDeclaration() and
        this = getBaseConstructor(c).getUnboundDeclaration()
      )
    )
  }
}

/** A namespace that contains at least one generated type. */
private class GeneratedNamespace extends Namespace, GeneratedElement {
  GeneratedNamespace() {
    this.getATypeDeclaration() instanceof GeneratedType
    or
    this.getAChildNamespace() instanceof GeneratedNamespace
  }

  private string getPreamble() {
    if this.isGlobalNamespace()
    then result = ""
    else result = "namespace " + this.getName() + "\n{\n"
  }

  private string getPostAmble() { if this.isGlobalNamespace() then result = "" else result = "}\n" }

  final string getStubs(Assembly assembly) {
    result =
      this.getPreamble() + this.getTypeStubs(assembly) + this.getSubNamespaceStubs(assembly) +
        this.getPostAmble()
  }

  /** Gets the `n`th generated child namespace, indexed from 0. */
  pragma[nomagic]
  final GeneratedNamespace getChildNamespace(int n) {
    result.getParentNamespace() = this and
    result.getName() =
      rank[n + 1](GeneratedNamespace g | g.getParentNamespace() = this | g.getName())
  }

  final int getChildNamespaceCount() {
    result = count(GeneratedNamespace g | g.getParentNamespace() = this)
  }

  private predicate isInAssembly(Assembly assembly) {
    any(GeneratedType gt | gt.(DotNet::ValueOrRefType).getDeclaringNamespace() = this)
        .isInAssembly(assembly)
    or
    this.getChildNamespace(_).isInAssembly(assembly)
  }

  language[monotonicAggregates]
  string getSubNamespaceStubs(Assembly assembly) {
    this.isInAssembly(assembly) and
    result =
      concat(GeneratedNamespace child, int i |
        child = this.getChildNamespace(i) and child.isInAssembly(assembly)
      |
        child.getStubs(assembly) order by i
      )
  }

  string getTypeStubs(Assembly assembly) {
    this.isInAssembly(assembly) and
    result =
      concat(GeneratedType gt |
        gt.(DotNet::ValueOrRefType).getDeclaringNamespace() = this and gt.isInAssembly(assembly)
      |
        gt.getStub(assembly) order by gt.getName()
      )
  }
}

/**
 * Specify assemblies to exclude.
 * Do not generate any types from these assemblies.
 */
abstract class ExcludedAssembly extends Assembly { }

private Virtualizable getAccessibilityDeclaringVirtualizable(Virtualizable v) {
  if not v.isOverride()
  then result = v
  else
    if not v.getOverridee().getLocation() instanceof ExcludedAssembly
    then result = getAccessibilityDeclaringVirtualizable(v.getOverridee())
    else result = v
}

private string stubAccessibility(Member m) {
  if
    m.getDeclaringType() instanceof Interface
    or
    exists(m.(Virtualizable).getExplicitlyImplementedInterface())
    or
    m instanceof Constructor and m.isStatic()
  then result = ""
  else
    if m.isPublic()
    then result = "public "
    else
      if m.isProtected()
      then
        if m.isPrivate() or getAccessibilityDeclaringVirtualizable(m).isPrivate()
        then result = "protected private "
        else
          if m.isInternal() or getAccessibilityDeclaringVirtualizable(m).isInternal()
          then result = "protected internal "
          else result = "protected "
      else
        if m.isPrivate()
        then result = "private "
        else
          if m.isInternal()
          then result = "internal "
          else result = "unknown-accessibility"
}

private string stubModifiers(Member m) {
  result = stubUnsafe(m) + stubAccessibility(m) + stubStaticOrConst(m) + stubOverride(m)
}

private string stubUnsafe(Member m) {
  if m.(Modifiable).isUnsafe() then result = "unsafe " else result = ""
}

private string stubStaticOrConst(Member m) {
  if m.(Modifiable).isStatic()
  then result = "static "
  else
    if m.(Modifiable).isConst()
    then result = "const "
    else result = ""
}

private string stubOverride(Member m) {
  if m.getDeclaringType() instanceof Interface
  then result = ""
  else
    if m.(Virtualizable).isVirtual()
    then result = "virtual "
    else
      if m.(Virtualizable).isAbstract()
      then
        if m.(Virtualizable).isOverride()
        then result = "abstract override "
        else result = "abstract "
      else
        if m.(Virtualizable).isOverride()
        then result = "override "
        else result = ""
}

private string stubQualifiedNamePrefix(ValueOrRefType t) {
  if t.getParent() instanceof GlobalNamespace
  then result = ""
  else
    if t.getParent() instanceof Namespace
    then result = t.getDeclaringNamespace().getQualifiedName() + "."
    else result = stubClassName(t.getDeclaringType()) + "."
}

language[monotonicAggregates]
private string stubClassName(Type t) {
  if t instanceof ObjectType
  then result = "object"
  else
    if t instanceof StringType
    then result = "string"
    else
      if t instanceof IntType
      then result = "int"
      else
        if t instanceof BoolType
        then result = "bool"
        else
          if t instanceof VoidType
          then result = "void"
          else
            if t instanceof FloatType
            then result = "float"
            else
              if t instanceof DoubleType
              then result = "double"
              else
                if t instanceof NullableType
                then result = stubClassName(t.(NullableType).getUnderlyingType()) + "?"
                else
                  if t instanceof TypeParameter
                  then result = t.getName()
                  else
                    if t instanceof ArrayType
                    then result = stubClassName(t.(ArrayType).getElementType()) + "[]"
                    else
                      if t instanceof PointerType
                      then result = stubClassName(t.(PointerType).getReferentType()) + "*"
                      else
                        if t instanceof TupleType
                        then
                          if t.(TupleType).getArity() < 2
                          then result = stubClassName(t.(TupleType).getUnderlyingType())
                          else
                            result =
                              "(" +
                                concat(int i, Type element |
                                  element = t.(TupleType).getElementType(i)
                                |
                                  stubClassName(element), "," order by i
                                ) + ")"
                        else
                          if t instanceof ValueOrRefType
                          then
                            result =
                              stubQualifiedNamePrefix(t) + t.getUndecoratedName() +
                                stubGenericArguments(t)
                          else result = "<error>"
}

language[monotonicAggregates]
private string stubGenericArguments(Type t) {
  if t instanceof UnboundGenericType
  then
    result =
      "<" +
        concat(int n |
          exists(t.(UnboundGenericType).getTypeParameter(n))
        |
          t.(UnboundGenericType).getTypeParameter(n).getName(), "," order by n
        ) + ">"
  else
    if t instanceof ConstructedType
    then
      result =
        "<" +
          concat(int n |
            exists(t.(ConstructedType).getTypeArgument(n))
          |
            stubClassName(t.(ConstructedType).getTypeArgument(n)), "," order by n
          ) + ">"
    else result = ""
}

private string stubGenericMethodParams(Method m) {
  if m instanceof UnboundGenericMethod
  then
    result =
      "<" +
        concat(int n, TypeParameter param |
          param = m.(UnboundGenericMethod).getTypeParameter(n)
        |
          param.getName(), "," order by n
        ) + ">"
  else result = ""
}

private string stubConstraints(TypeParameterConstraints tpc, int i) {
  tpc.hasConstructorConstraint() and result = "new()" and i = 4
  or
  tpc.hasUnmanagedTypeConstraint() and result = "unmanaged" and i = 0
  or
  tpc.hasValueTypeConstraint() and
  result = "struct" and
  i = 0 and
  not tpc.hasUnmanagedTypeConstraint() and
  not stubClassName(tpc.getATypeConstraint().(Class)) = "System.Enum"
  or
  tpc.hasRefTypeConstraint() and result = "class" and i = 0
  or
  result = tpc.getATypeConstraint().(TypeParameter).getName() and i = 3
  or
  result = stubClassName(tpc.getATypeConstraint().(Interface)) and i = 2
  or
  result = stubClassName(tpc.getATypeConstraint().(Class)) and i = 1
}

private string stubTypeParameterConstraints(TypeParameter tp) {
  if
    tp.getDeclaringGeneric().(Virtualizable).isOverride() or
    tp.getDeclaringGeneric().(Virtualizable).implementsExplicitInterface()
  then
    if tp.getConstraints().hasValueTypeConstraint()
    then result = " where " + tp.getName() + ": struct"
    else
      if tp.getConstraints().hasRefTypeConstraint()
      then result = " where " + tp.getName() + ": class"
      else result = ""
  else
    exists(TypeParameterConstraints tpc | tpc = tp.getConstraints() |
      result =
        " where " + tp.getName() + ": " +
          strictconcat(string s, int i | s = stubConstraints(tpc, i) | s, ", " order by i)
    )
}

private string stubTypeParametersConstraints(Declaration d) {
  if d instanceof UnboundGeneric
  then
    result =
      concat(TypeParameter tp |
        tp = d.(UnboundGeneric).getATypeParameter()
      |
        stubTypeParameterConstraints(tp), " "
      )
  else result = ""
}

private string stubImplementation(Virtualizable c) {
  if c.isAbstract() then result = "" else result = " => throw null"
}

private predicate isKeyword(string s) {
  s =
    [
      "abstract", "as", "base", "bool", "break", "byte", "case", "catch", "char", "checked",
      "class", "const", "continue", "decimal", "default", "delegate", "do", "double", "else",
      "enum", "event", "explicit", "extern", "false", "finally", "fixed", "float", "for", "foreach",
      "goto", "if", "implicit", "in", "int", "interface", "internal", "is", "lock", "long",
      "namespace", "new", "null", "object", "operator", "out", "override", "params", "private",
      "protected", "public", "readonly", "ref", "return", "sbyte", "sealed", "short", "sizeof",
      "stackalloc", "static", "string", "struct", "switch", "this", "throw", "true", "try",
      "typeof", "uint", "ulong", "unchecked", "unsafe", "ushort", "using", "virtual", "void",
      "volatile", "while"
    ]
}

bindingset[s]
private string escapeIfKeyword(string s) { if isKeyword(s) then result = "@" + s else result = s }

private string stubParameters(Parameterizable p) {
  result =
    concat(int i, Parameter param |
      param = p.getParameter(i) and not param.getType() instanceof ArglistType
    |
      stubParameterModifiers(param) + stubClassName(param.getType()) + " " +
          escapeIfKeyword(param.getName()) + stubDefaultValue(param), ", "
      order by
        i
    )
}

private string stubDefaultArguments(Constructor baseCtor, ValueOrRefType callingType) {
  baseCtor = getBaseConstructor(callingType) and
  baseCtor.getNumberOfParameters() > 0 and
  result =
    concat(int i, Parameter param |
      param = baseCtor.getParameter(i) and not param.getType() instanceof ArglistType
    |
      "default(" + stubClassName(param.getType()) + ")", ", " order by i
    )
}

private string stubParameterModifiers(Parameter p) {
  if p.isOut()
  then result = "out "
  else
    if p.isRef()
    then result = "ref "
    else
      if p.isParams()
      then result = "params "
      else
        if p.isIn()
        then result = "" // Only C# 7.1 so ignore
        else
          if p.hasExtensionMethodModifier()
          then result = "this "
          else result = ""
}

private string stubDefaultValue(Parameter p) {
  if p.hasDefaultValue()
  then result = " = default(" + stubClassName(p.getType()) + ")"
  else result = ""
}

private string stubEventAccessors(Event e) {
  if exists(e.(Virtualizable).getExplicitlyImplementedInterface())
  then result = " { add => throw null; remove => throw null; }"
  else result = ";"
}

private string stubExplicitImplementation(Member c) {
  if exists(c.(Virtualizable).getExplicitlyImplementedInterface())
  then result = stubClassName(c.(Virtualizable).getExplicitlyImplementedInterface()) + "."
  else result = ""
}

pragma[noinline]
private string stubMethod(Method m, Assembly assembly) {
  m instanceof GeneratedMember and
  m.getALocation() = assembly and
  if not m.getDeclaringType() instanceof Enum
  then
    result =
      "    " + stubModifiers(m) + stubClassName(m.getReturnType()) + " " +
        stubExplicitImplementation(m) + escapeIfKeyword(m.getUndecoratedName()) +
        stubGenericMethodParams(m) + "(" + stubParameters(m) + ")" +
        stubTypeParametersConstraints(m) + stubImplementation(m) + ";\n"
  else result = "    // Stub generator skipped method: " + m.getName() + "\n"
}

pragma[noinline]
private string stubOperator(Operator o, Assembly assembly) {
  o instanceof GeneratedMember and
  o.getALocation() = assembly and
  if o instanceof ConversionOperator
  then
    result =
      "    " + stubModifiers(o) + stubExplicit(o) + "operator " + stubClassName(o.getReturnType()) +
        "(" + stubParameters(o) + ") => throw null;\n"
  else
    if not o.getDeclaringType() instanceof Enum
    then
      result =
        "    " + stubModifiers(o) + stubClassName(o.getReturnType()) + " operator " + o.getName() +
          "(" + stubParameters(o) + ") => throw null;\n"
    else result = "    // Stub generator skipped operator: " + o.getName() + "\n"
}

pragma[noinline]
private string stubEnumConstant(EnumConstant ec, Assembly assembly) {
  ec instanceof GeneratedMember and
  ec.getALocation() = assembly and
  result = "    " + escapeIfKeyword(ec.getName()) + ",\n"
}

pragma[noinline]
private string stubProperty(Property p, Assembly assembly) {
  p instanceof GeneratedMember and
  p.getALocation() = assembly and
  result =
    "    " + stubModifiers(p) + stubClassName(p.getType()) + " " + stubExplicitImplementation(p) +
      escapeIfKeyword(p.getName()) + " { " + stubGetter(p) + stubSetter(p) + "}\n"
}

pragma[noinline]
private string stubConstructor(Constructor c, Assembly assembly) {
  c instanceof GeneratedMember and
  c.getALocation() = assembly and
  if c.getDeclaringType() instanceof Enum
  then result = ""
  else
    if
      not c.getDeclaringType() instanceof StructExt or
      c.getNumberOfParameters() > 0
    then
      result =
        "    " + stubModifiers(c) + escapeIfKeyword(c.getName()) + "(" + stubParameters(c) + ")" +
          stubConstructorInitializer(c) + " => throw null;\n"
    else result = "    // Stub generator skipped constructor \n"
}

pragma[noinline]
private string stubIndexer(Indexer i, Assembly assembly) {
  i instanceof GeneratedMember and
  i.getALocation() = assembly and
  result =
    "    " + stubIndexerNameAttribute(i) + stubModifiers(i) + stubClassName(i.getType()) + " " +
      stubExplicitImplementation(i) + "this[" + stubParameters(i) + "] { " + stubGetter(i) +
      stubSetter(i) + "}\n"
}

pragma[noinline]
private string stubField(Field f, Assembly assembly) {
  f instanceof GeneratedMember and
  f.getALocation() = assembly and
  not f instanceof EnumConstant and // EnumConstants are already stubbed
  exists(string impl |
    (if f.isConst() then impl = " = default" else impl = "") and
    result =
      "    " + stubModifiers(f) + stubClassName(f.getType()) + " " + escapeIfKeyword(f.getName()) +
        impl + ";\n"
  )
}

pragma[noinline]
private string stubEvent(Event e, Assembly assembly) {
  e instanceof GeneratedMember and
  e.getALocation() = assembly and
  result =
    "    " + stubModifiers(e) + "event " + stubClassName(e.getType()) + " " +
      stubExplicitImplementation(e) + escapeIfKeyword(e.getName()) + stubEventAccessors(e) + "\n"
}

pragma[nomagic]
private string stubMember(GeneratedMember m, Assembly assembly) {
  result = stubMethod(m, assembly)
  or
  result = stubOperator(m, assembly)
  or
  result = stubEnumConstant(m, assembly)
  or
  result = stubProperty(m, assembly)
  or
  result = stubConstructor(m, assembly)
  or
  result = stubIndexer(m, assembly)
  or
  result = stubField(m, assembly)
  or
  result = stubEvent(m, assembly)
  or
  not m instanceof Method and
  not m instanceof Operator and
  not m instanceof EnumConstant and
  not m instanceof Property and
  not m instanceof Constructor and
  not m instanceof Indexer and
  not m instanceof Field and
  not m instanceof Event and
  m.getALocation() = assembly and
  (
    result = m.(GeneratedType).getStub(assembly) + "\n"
    or
    not m instanceof GeneratedType and
    result = "    // ERR: Stub generator didn't handle member: " + m.getName() + "\n"
  )
}

private string stubIndexerNameAttribute(Indexer i) {
  if i.getName() != "Item"
  then result = "[System.Runtime.CompilerServices.IndexerName(\"" + i.getName() + "\")]\n    "
  else result = ""
}

private Constructor getBaseConstructor(ValueOrRefType type) {
  result =
    min(Constructor bc |
      type.getBaseClass().getAMember() = bc and
      // not the `static` constructor
      not bc.isStatic() and
      // not a `private` constructor, unless it's `private protected`, or if the derived class is nested
      (not bc.isPrivate() or bc.isProtected() or bc.getDeclaringType() = type.getDeclaringType+())
    |
      bc order by bc.getNumberOfParameters(), stubParameters(bc)
    )
}

private string stubConstructorInitializer(Constructor c) {
  exists(Constructor baseCtor |
    baseCtor = getBaseConstructor(c.getDeclaringType()) and
    if baseCtor.getNumberOfParameters() = 0 or c.isStatic()
    then result = ""
    else result = " : base(" + stubDefaultArguments(baseCtor, c.getDeclaringType()) + ")"
  )
  or
  // abstract base class might not have a constructor
  not exists(Constructor baseCtor |
    c.getDeclaringType().getBaseClass().getAMember() = baseCtor and not baseCtor.isStatic()
  ) and
  result = ""
}

private string stubExplicit(ConversionOperator op) {
  op instanceof ImplicitConversionOperator and result = "implicit "
  or
  op instanceof ExplicitConversionOperator and result = "explicit "
}

private string stubGetter(DeclarationWithGetSetAccessors p) {
  if exists(p.getGetter())
  then if p.isAbstract() then result = "get; " else result = "get => throw null; "
  else result = ""
}

private string stubSetter(DeclarationWithGetSetAccessors p) {
  if exists(p.getSetter())
  then if p.isAbstract() then result = "set; " else result = "set => throw null; "
  else result = ""
}

private string stubSemmleExtractorOptions() {
  result =
    concat(string s |
      exists(CommentLine comment |
        s =
          "// original-extractor-options:" +
            comment.getText().regexpCapture("\\w*semmle-extractor-options:(.*)", 1) + "\n"
      )
    )
}

/** Gets the generated C# code. */
string generatedCode(Assembly assembly) {
  result =
    "// This file contains auto-generated code.\n" + stubSemmleExtractorOptions() + "\n" +
      any(GeneratedNamespace ns | ns.isGlobalNamespace()).getStubs(assembly)
}

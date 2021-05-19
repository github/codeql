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

/** An element that should be in the generated code. */
abstract class GeneratedElement extends Element { }

/** A member that should be in the generated code. */
abstract class GeneratedMember extends Member, GeneratedElement { }

/** A type that should be in the generated code. */
abstract private class GeneratedType extends ValueOrRefType, GeneratedElement {
  GeneratedType() {
    (
      this instanceof Interface
      or
      this instanceof Class
      or
      this instanceof Struct
      or
      this instanceof Enum
      or
      this instanceof DelegateType
    ) and
    not this instanceof ConstructedType and
    not this.getALocation() instanceof ExcludedAssembly
  }

  /**
   * Holds if this type is duplicated in another assembly.
   * In this case, we use the assembly with the highest string.
   */
  private predicate isDuplicate() {
    exists(GeneratedType dup |
      dup.getQualifiedName() = this.getQualifiedName() and
      this.getLocation().(Assembly).toString() < dup.getLocation().(Assembly).toString()
    )
  }

  predicate isInAssembly(Assembly assembly) { this.getALocation() = assembly }

  private string stubKeyword() {
    this instanceof Interface and result = "interface"
    or
    this instanceof Struct and result = "struct"
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
    if count(Assembly a | this.getALocation() = a) > 1 then result = "partial " else result = ""
  }

  private string stubAttributes() {
    if this.getAnAttribute().getType().getQualifiedName() = "System.FlagsAttribute"
    then result = "[System.Flags]\n"
    else result = ""
  }

  private string stubComment() {
    result =
      "// Generated from `" + this.getQualifiedName() + "` in `" +
        concat(this.getALocation().toString(), "; ") + "`\n"
  }

  /** Gets the entire C# stub code for this type. */
  final string getStub(Assembly assembly) {
    if this.isDuplicate()
    then result = ""
    else (
      not this instanceof DelegateType and
      result =
        this.stubComment() + this.stubAttributes() + stubAccessibility(this) +
          this.stubAbstractModifier() + this.stubStaticModifier() + this.stubPartialModifier() +
          this.stubKeyword() + " " + this.getUndecoratedName() + stubGenericArguments(this) +
          stubBaseTypesString() + stubTypeParametersConstraints(this) + "\n{\n" +
          stubMembers(assembly) + "}\n\n"
      or
      result =
        this.stubComment() + this.stubAttributes() + stubAccessibility(this) + this.stubKeyword() +
          " " + stubClassName(this.(DelegateType).getReturnType()) + " " + this.getUndecoratedName()
          + stubGenericArguments(this) + "(" + stubParameters(this) + ");\n\n"
    )
  }

  private ValueOrRefType getAnInterestingBaseType() {
    result = this.getABaseType() and
    not result instanceof ObjectType and
    not result.getQualifiedName() = "System.ValueType" and
    (not result instanceof Interface or result.(Interface).isEffectivelyPublic())
  }

  private string stubBaseTypesString() {
    if this instanceof Enum
    then result = ""
    else
      if exists(getAnInterestingBaseType())
      then
        result =
          " : " +
            concat(int i, ValueOrRefType t |
              t = this.getAnInterestingBaseType() and
              (if t instanceof Class then i = 0 else i = 1)
            |
              stubClassName(t), ", " order by i
            )
      else result = ""
  }

  language[monotonicAggregates]
  private string stubMembers(Assembly assembly) {
    result =
      concat(Member m |
        m = this.getAGeneratedMember() and m.getALocation() = assembly
      |
        stubMember(m, assembly) order by m.getName()
      )
  }

  private GeneratedMember getAGeneratedMember() { result.getDeclaringType() = this }

  final Type getAGeneratedType() {
    result = getAnInterestingBaseType()
    or
    result = getAGeneratedMember().(Callable).getReturnType()
    or
    result = getAGeneratedMember().(Callable).getAParameter().getType()
    or
    result = getAGeneratedMember().(Property).getType()
    or
    result = getAGeneratedMember().(Field).getType()
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
    this.getASubType() instanceof GeneratedType
    or
    this.getAChildType() instanceof GeneratedType
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
        c = this.getDeclaringType().getBaseClass().getAMember() and c.getNumberOfParameters() = 0
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
      getPreamble() + getTypeStubs(assembly) + getSubNamespaceStubs(assembly) + getPostAmble()
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
    any(GeneratedType gt | gt.getDeclaringNamespace() = this).isInAssembly(assembly)
    or
    this.getChildNamespace(_).isInAssembly(assembly)
  }

  language[monotonicAggregates]
  string getSubNamespaceStubs(Assembly assembly) {
    this.isInAssembly(assembly) and
    result =
      concat(GeneratedNamespace child, int i |
        child = getChildNamespace(i) and child.isInAssembly(assembly)
      |
        child.getStubs(assembly) order by i
      )
  }

  string getTypeStubs(Assembly assembly) {
    this.isInAssembly(assembly) and
    result =
      concat(GeneratedType gt |
        gt.getDeclaringNamespace() = this and gt.isInAssembly(assembly)
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

/** Exclude types from these standard assemblies. */
private class DefaultLibs extends ExcludedAssembly {
  DefaultLibs() {
    this.getName() = "System.Private.CoreLib" or
    this.getName() = "mscorlib" or
    this.getName() = "System.Runtime"
  }
}

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
private string stubGenericArguments(ValueOrRefType t) {
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
  tpc.hasValueTypeConstraint() and result = "struct" and i = 0
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
  s = "abstract" or
  s = "as" or
  s = "base" or
  s = "bool" or
  s = "break" or
  s = "byte" or
  s = "case" or
  s = "catch" or
  s = "char" or
  s = "checked" or
  s = "class" or
  s = "const" or
  s = "continue" or
  s = "decimal" or
  s = "default" or
  s = "delegate" or
  s = "do" or
  s = "double" or
  s = "else" or
  s = "enum" or
  s = "event" or
  s = "explicit" or
  s = "extern" or
  s = "false" or
  s = "finally" or
  s = "fixed" or
  s = "float" or
  s = "for" or
  s = "foreach" or
  s = "goto" or
  s = "if" or
  s = "implicit" or
  s = "in" or
  s = "int" or
  s = "interface" or
  s = "internal" or
  s = "is" or
  s = "lock" or
  s = "long" or
  s = "namespace" or
  s = "new" or
  s = "null" or
  s = "object" or
  s = "operator" or
  s = "out" or
  s = "override" or
  s = "params" or
  s = "private" or
  s = "protected" or
  s = "public" or
  s = "readonly" or
  s = "ref" or
  s = "return" or
  s = "sbyte" or
  s = "sealed" or
  s = "short" or
  s = "sizeof" or
  s = "stackalloc" or
  s = "static" or
  s = "string" or
  s = "struct" or
  s = "switch" or
  s = "this" or
  s = "throw" or
  s = "true" or
  s = "try" or
  s = "typeof" or
  s = "uint" or
  s = "ulong" or
  s = "unchecked" or
  s = "unsafe" or
  s = "ushort" or
  s = "using" or
  s = "virtual" or
  s = "void" or
  s = "volatile" or
  s = "while"
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

private string stubDefaultArguments(Parameterizable p) {
  result =
    concat(int i, Parameter param |
      param = p.getParameter(i) and not param.getType() instanceof ArglistType
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

private string stubExplicitImplementation(Member c) {
  if exists(c.(Virtualizable).getExplicitlyImplementedInterface())
  then result = stubClassName(c.(Virtualizable).getExplicitlyImplementedInterface()) + "."
  else result = ""
}

private string stubMember(Member m, Assembly assembly) {
  if m instanceof Method
  then
    if not m.getDeclaringType() instanceof Enum
    then
      result =
        "    " + stubModifiers(m) + stubClassName(m.(Method).getReturnType()) + " " +
          stubExplicitImplementation(m) + m.getName() + stubGenericMethodParams(m) + "(" +
          stubParameters(m) + ")" + stubTypeParametersConstraints(m) + stubImplementation(m) + ";\n"
    else result = "    // Stub generator skipped method: " + m.getName() + "\n"
  else
    if m instanceof Operator
    then
      if
        not m.getDeclaringType() instanceof Enum and
        not m instanceof ConversionOperator
      then
        result =
          "    " + stubModifiers(m) + stubClassName(m.(Operator).getReturnType()) + " operator " +
            m.getName() + "(" + stubParameters(m) + ") => throw null;\n"
      else result = "    // Stub generator skipped operator: " + m.getName() + "\n"
    else
      if m instanceof ConversionOperator
      then
        result =
          "    " + stubModifiers(m) + stubExplicit(m) + "operator " +
            stubClassName(m.(ConversionOperator).getReturnType()) + "(" + stubParameters(m) +
            ") => throw null;\n"
      else
        if m instanceof EnumConstant
        then result = "    " + m.(EnumConstant).getName() + ",\n"
        else
          if m instanceof Property
          then
            result =
              "    " + stubModifiers(m) + stubClassName(m.(Property).getType()) + " " +
                stubExplicitImplementation(m) + m.getName() + " { " + stubGetter(m) + stubSetter(m) +
                "}\n"
          else
            if m instanceof Constructor
            then
              if
                not m.getDeclaringType() instanceof Enum and
                (
                  not m.getDeclaringType() instanceof Struct or
                  m.(Constructor).getNumberOfParameters() > 0
                )
              then
                result =
                  "    " + stubModifiers(m) + m.getName() + "(" + stubParameters(m) + ")" +
                    stubConstructorInitializer(m) + " => throw null;\n"
              else result = "    // Stub generator skipped constructor \n"
            else
              if m instanceof Indexer
              then
                result =
                  "    " + stubIndexerNameAttribute(m) + stubModifiers(m) +
                    stubClassName(m.(Indexer).getType()) + " " + stubExplicitImplementation(m) +
                    "this[" + stubParameters(m) + "] { " + stubGetter(m) + stubSetter(m) + "}\n"
              else
                if m instanceof Field // EnumConstants are already stubbed
                then
                  exists(string impl |
                    (if m.(Field).isConst() then impl = " = default" else impl = "") and
                    result =
                      "    " + stubModifiers(m) + stubClassName(m.(Field).getType()) + " " +
                        escapeIfKeyword(m.(Field).getName()) + impl + ";\n"
                  )
                else
                  if m instanceof Event
                  then
                    result =
                      "    " + stubModifiers(m) + "event " + stubClassName(m.(Event).getType()) +
                        " " + stubExplicitImplementation(m) + m.getName() + ";\n"
                  else
                    if m instanceof GeneratedType
                    then result = m.(GeneratedType).getStub(assembly) + "\n"
                    else
                      result =
                        "    // ERR: Stub generator didn't handle member: " + m.getName() + "\n"
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
    else result = " : base(" + stubDefaultArguments(baseCtor) + ")"
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

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
    not this.getALocation() instanceof ExcludedAssembly and
    this.fromLibrary()
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

  private string stubAttributes() {
    if this.getAnAttribute().getType().getQualifiedName() = "System.FlagsAttribute"
    then result = "[System.Flags]\n"
    else result = ""
  }

  private string stubComment() {
    result =
      "// Generated from `" + this.getQualifiedName() + "` in `" +
        min(this.getLocation().toString()) + "`\n"
  }

  private string stubAccessibilityModifier() {
    if this.isPublic() then result = "public " else result = ""
  }

  /** Gets the entire C# stub code for this type. */
  final string getStub() {
    if this.isDuplicate()
    then result = ""
    else (
      not this instanceof DelegateType and
      result =
        this.stubComment() + this.stubAttributes() + this.stubAbstractModifier() +
          this.stubStaticModifier() + this.stubAccessibilityModifier() + this.stubKeyword() + " " +
          this.getUndecoratedName() + stubGenericArguments(this) + stubBaseTypesString() +
          stubTypeParametersConstraints(this) + "\n{\n" + stubMembers() + "}\n\n"
      or
      result =
        this.stubComment() + this.stubAttributes() + this.stubAccessibilityModifier() +
          this.stubKeyword() + " " + stubClassName(this.(DelegateType).getReturnType()) + " " +
          this.getUndecoratedName() + stubGenericArguments(this) + "(" + stubParameters(this) +
          ");\n\n"
    )
  }

  private ValueOrRefType getAnInterestingBaseType() {
    result = this.getABaseType() and
    not result instanceof ObjectType and
    not result.getQualifiedName() = "System.ValueType"
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
  private string stubMembers() {
    result = concat(Member m | m = this.getAGeneratedMember() | stubMember(m) order by m.getName())
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
abstract class GeneratedDeclaration extends Declaration { }

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

  final string getStubs() {
    result = getPreamble() + getTypeStubs() + getSubNamespaces() + getPostAmble()
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

  language[monotonicAggregates]
  private string getSubNamespaces() {
    result = concat(int i | exists(getChildNamespace(i)) | getChildNamespace(i).getStubs())
  }

  private string getTypeStubs() {
    result =
      concat(string s | s = any(GeneratedType gt | gt.getDeclaringNamespace() = this).getStub())
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

private string stubAccessibility(Member m) {
  if
    m.getDeclaringType() instanceof Interface or
    exists(m.(Virtualizable).getExplicitlyImplementedInterface())
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
          if m.isInternal()
          then result = "internal "
          else result = "unknown-accessibility"
}

private string stubModifiers(Member m) {
  result = stubAccessibility(m) + stubStaticOrConst(m) + stubOverride(m)
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
      then result = "abstract "
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
    else result = t.getDeclaringType().getQualifiedName() + "."
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

private string stubConstraints(TypeParameterConstraints tpc) {
  tpc.hasConstructorConstraint() and result = "new()"
  or
  tpc.hasUnmanagedTypeConstraint() and result = "unmanaged"
  or
  tpc.hasValueTypeConstraint() and result = "struct"
  or
  tpc.hasRefTypeConstraint() and result = "class"
  or
  result = tpc.getATypeConstraint().(TypeParameter).getName()
  or
  result = stubClassName(tpc.getATypeConstraint().(Interface))
  or
  result = stubClassName(tpc.getATypeConstraint().(Class))
}

private string stubTypeParameterConstraints(TypeParameter tp) {
  exists(TypeParameterConstraints tpc | tpc = tp.getConstraints() |
    result =
      " where " + tp.getName() + ": " + strictconcat(string s | s = stubConstraints(tpc) | s, ", ")
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
  if c.isAbstract() or c.getDeclaringType() instanceof Interface
  then result = ""
  else result = " => throw null"
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

private string stubMember(Member m) {
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
                  "    " + stubModifiers(m) + stubClassName(m.(Indexer).getType()) + " " +
                    stubExplicitImplementation(m) + "this[" + stubParameters(m) + "] { " +
                    stubGetter(m) + stubSetter(m) + "}\n"
              else
                if m instanceof Field // EnumConstants are already stubbed
                then
                  exists(string impl |
                    (if m.(Field).isConst() then impl = " = throw null" else impl = "") and
                    result =
                      "    " + stubModifiers(m) + stubClassName(m.(Field).getType()) + " " +
                        m.(Field).getName() + impl + ";\n"
                  )
                else
                  if m instanceof Event
                  then
                    result =
                      "    " + stubModifiers(m) + "event " + stubClassName(m.(Event).getType()) +
                        " " + stubExplicitImplementation(m) + m.getName() + ";\n"
                  else
                    if m instanceof GeneratedType
                    then result = m.(GeneratedType).getStub() + "\n"
                    else
                      result =
                        "    // ERR: Stub generator didn't handle member: " + m.getName() + "\n"
}

private string stubConstructorInitializer(Constructor c) {
  exists(Constructor baseCtor |
    baseCtor =
      min(Constructor bc |
        c.getDeclaringType().getBaseClass().getAMember() = bc
      |
        bc order by bc.getNumberOfParameters(), stubParameters(bc)
      ) and
    if baseCtor.getNumberOfParameters() = 0
    then result = ""
    else result = " : base(" + stubDefaultArguments(baseCtor) + ")"
  )
  or
  // abstract base class might not have a constructor
  not exists(Constructor baseCtor | c.getDeclaringType().getBaseClass().getAMember() = baseCtor) and
  result = ""
}

private string stubExplicit(ConversionOperator op) {
  op instanceof ImplicitConversionOperator and result = "implicit "
  or
  op instanceof ExplicitConversionOperator and result = "explicit "
}

private string stubGetter(DeclarationWithGetSetAccessors p) {
  if exists(p.getGetter())
  then
    if p.isAbstract() or p.getDeclaringType() instanceof Interface
    then result = "get; "
    else result = "get => throw null; "
  else result = ""
}

private string stubSetter(DeclarationWithGetSetAccessors p) {
  if exists(p.getSetter())
  then
    if p.isAbstract() or p.getDeclaringType() instanceof Interface
    then result = "set; "
    else result = "set => throw null; "
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
string generatedCode() {
  result =
    "// This file contains auto-generated code.\n" + stubSemmleExtractorOptions() + "\n" +
      any(GeneratedNamespace ns | ns.isGlobalNamespace()).getStubs()
}
